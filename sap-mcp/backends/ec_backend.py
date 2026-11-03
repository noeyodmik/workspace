"""SuccessFactors Employee Central (EC) OData API v2 연동 백엔드."""
from __future__ import annotations

from typing import Any
import httpx

from config import Settings
from .base import Result
from guard import mask_personal_id


class EcBackend:
    """SuccessFactors Employee Central (EC) OData v2 백엔드."""

    def __init__(self, settings: Settings):
        self.s = settings

    def _get_client(self) -> httpx.Client:
        auth = (f"{self.s.sf_user}@{self.s.sf_company_id}", self.s.sf_password)
        base = self.s.sf_api_url.rstrip("/")
        headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
        }
        return httpx.Client(base_url=base, auth=auth, headers=headers, timeout=15.0)

    def is_configured(self) -> bool:
        return self.s.sf_configured

    def ping(self) -> Result:
        """SF EC OData API 접속 상태를 확인한다."""
        if not self.is_configured():
            return Result(
                False,
                "SuccessFactors 접속 정보가 설정되지 않았습니다 (.env 의 SF_API_URL, SF_COMPANY_ID, SF_USER, SF_PASSWORD 확인 필요)."
            )
        try:
            with self._get_client() as client:
                resp = client.get("/User", params={"$top": 1, "$select": "userId,username", "$format": "json"})
                if resp.status_code == 200:
                    data = resp.json().get("d", {}).get("results", [])
                    return Result(True, "SuccessFactors OData API 연결 성공 (HTTP 200)", {"sample_user": data})
                elif resp.status_code in (401, 403):
                    return Result(False, f"SuccessFactors 인증 실패 (HTTP {resp.status_code}): 계정 또는 Company ID를 확인하세요.")
                else:
                    return Result(False, f"SuccessFactors 응답 오류 (HTTP {resp.status_code}): {resp.text[:200]}")
        except Exception as e:
            return Result(False, f"SuccessFactors 연결 실패: {type(e).__name__}: {e}")

    def get_employee(self, user_id: str, mask_sensitive: bool = True) -> Result:
        """EC에서 사원의 기본 정보(User)와 직무 정보(EmpJob)를 조회한다."""
        if not self.is_configured():
            return Result(False, "SuccessFactors 접속 정보가 설정되지 않았습니다.")
        uid = user_id.strip()
        try:
            with self._get_client() as client:
                # 1. EmpJob 조회 (회사, 코스트센터, 부서, 직급)
                job_resp = client.get(
                    "/EmpJob",
                    params={
                        "$filter": f"userId eq '{uid}'",
                        "$select": "userId,startDate,endDate,company,costCenter,department,division,jobCode,position,payScaleGroup",
                        "$orderby": "startDate desc",
                        "$top": 1,
                        "$format": "json",
                    },
                )
                job_data = {}
                if job_resp.status_code == 200:
                    results = job_resp.json().get("d", {}).get("results", [])
                    if results:
                        job_data = results[0]

                # 2. User 프로필 조회 (이름, 이메일, 상태)
                user_resp = client.get(
                    f"/User('{uid}')",
                    params={"$select": "userId,username,firstName,lastName,email,status", "$format": "json"},
                )
                user_data = {}
                if user_resp.status_code == 200:
                    user_data = user_resp.json().get("d", {})

                if not job_data and not user_data:
                    return Result(False, f"EC에서 사원 '{uid}'을(를) 찾을 수 없습니다.")

                first_name = user_data.get("firstName", "")
                last_name = user_data.get("lastName", "")
                email = user_data.get("email", "")

                if mask_sensitive:
                    email = mask_personal_id(email, mask=True)

                res = {
                    "user_id": uid,
                    "name": f"{last_name} {first_name}".strip(),
                    "status": user_data.get("status", ""),
                    "email": email,
                    "company": job_data.get("company", ""),
                    "cost_center": job_data.get("costCenter", ""),
                    "department": job_data.get("department", ""),
                    "division": job_data.get("division", ""),
                    "job_code": job_data.get("jobCode", ""),
                    "position": job_data.get("position", ""),
                    "start_date": job_data.get("startDate", ""),
                    "masked": mask_sensitive,
                }
                return Result(True, f"EC 사원 '{uid}' 조회 성공", res)
        except Exception as e:
            return Result(False, f"EC 사원 조회 실패: {type(e).__name__}: {e}")

    def compare_employee_with_ecp(self, user_id: str, pernr: str, rfc_backend: Any) -> Result:
        """EC 원천 데이터(EmpJob)와 ECP 결과(PA0001 조직배정)를 비교하여 불일치를 탐지한다."""
        # 1. EC 원천 데이터 조회
        ec_res = self.get_employee(user_id=user_id, mask_sensitive=False)
        if not ec_res.ok:
            return Result(False, f"EC 원천 데이터 조회 실패: {ec_res.message}")
        ec_data = ec_res.data

        # 2. ECP PA0001 (인사영역, 코스트센터, 회사코드) 조회
        target_pernr = str(pernr).strip().zfill(8)
        p1_res = rfc_backend.read_table(
            "PA0001",
            fields=["PERNR", "BUKRS", "WERKS", "BTRTL", "KOSTL", "ORGEH", "STELL", "PLANS", "BEGDA", "ENDDA"],
            where_clause=f"PERNR = '{target_pernr}'",
            max_rows=1,
        )
        if not p1_res.ok or not p1_res.data.get("rows"):
            return Result(False, f"ECP 인사 마스터(PA0001)에서 사원 '{target_pernr}'을(를) 찾을 수 없습니다.")

        ecp_data = p1_res.data["rows"][0]

        # 3. 필드 1:1 비교
        comparisons = [
            {
                "field_name": "회사코드 (Company Code)",
                "ec_field": "company",
                "ec_value": ec_data.get("company", ""),
                "ecp_field": "BUKRS",
                "ecp_value": ecp_data.get("BUKRS", ""),
            },
            {
                "field_name": "코스트센터 (Cost Center)",
                "ec_field": "costCenter",
                "ec_value": ec_data.get("cost_center", ""),
                "ecp_field": "KOSTL",
                "ecp_value": ecp_data.get("KOSTL", ""),
            },
            {
                "field_name": "소속부서/조직 (Org Unit)",
                "ec_field": "department",
                "ec_value": ec_data.get("department", ""),
                "ecp_field": "ORGEH",
                "ecp_value": ecp_data.get("ORGEH", ""),
            },
            {
                "field_name": "직무/직책 (Job / Position)",
                "ec_field": "jobCode / position",
                "ec_value": f"{ec_data.get('job_code', '')} / {ec_data.get('position', '')}",
                "ecp_field": "STELL / PLANS",
                "ecp_value": f"{ecp_data.get('STELL', '')} / {ecp_data.get('PLANS', '')}",
            },
        ]

        mismatches = []
        matches = []
        for c in comparisons:
            # 단순 동일 여부 (공백 제거 후 비교, 향후 맵핑 테이블 T77SFEC_* 규칙 적용 가능)
            ec_v = str(c["ec_value"]).strip().upper()
            ecp_v = str(c["ecp_value"]).strip().upper()
            is_match = (ec_v == ecp_v) or (not ec_v and not ecp_v)
            c["is_match"] = is_match
            if is_match:
                matches.append(c)
            else:
                mismatches.append(c)

        summary = {
            "user_id": user_id,
            "pernr": target_pernr,
            "ec_name": ec_data.get("name", ""),
            "total_checked": len(comparisons),
            "match_count": len(matches),
            "mismatch_count": len(mismatches),
            "has_mismatch": len(mismatches) > 0,
            "mismatches": mismatches,
            "matches": matches,
        }

        msg = (
            f"EC vs ECP 정합성 비교 완료: 일치 {len(matches)}개, 불일치 {len(mismatches)}개 "
            f"({'🚨 불일치 항목 발견' if mismatches else '✅ 모든 주요 필드 일치'})"
        )
        return Result(True, msg, summary)
