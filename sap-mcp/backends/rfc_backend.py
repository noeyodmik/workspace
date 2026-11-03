"""pyrfc 기반 RFC 백엔드.

단계 0: RFC_PING, RFC_SYSTEM_INFO (표준 FM)만 실제 동작한다.
나머지는 abap/zmcp 의 Z_MCP_* 함수 모듈을 SAP에 등록한 뒤 구현한다.
"""
from __future__ import annotations

from typing import Any

from config import Settings
from .base import Result, SapBackend

_NOT_READY = "Z_MCP_* 함수 모듈이 아직 구현/등록되지 않았습니다 (abap/zmcp 참고)."


def _err(e: Exception) -> str:
    key = getattr(e, "key", "")
    if key == "FU_NOT_FOUND" or "FU_NOT_FOUND" in str(e):
        return _NOT_READY
    return f"{type(e).__name__}: {e}"


class RfcBackend(SapBackend):
    def __init__(self, settings: Settings):
        self.s = settings
        self._known_remote_fms: set[str] = {
            "RFC_PING",
            "RFC_SYSTEM_INFO",
            "RFC_FUNCTION_SEARCH",
            "BAPI_MESSAGE_GETDETAIL",
            "/SDF/GET_DUMP_LOG",
            "BBP_RFC_READ_TABLE",
        }

    def _conn(self):
        from pyrfc import Connection  # SAP NW RFC SDK 필요

        return Connection(**self.s.rfc_params())

    def is_remote_enabled(self, fm: str) -> bool:
        fm_upper = fm.strip().upper()
        if fm_upper in self._known_remote_fms or fm_upper.startswith("Z_MCP_"):
            return True
        try:
            with self._conn() as c:
                r = c.call("RFC_FUNCTION_SEARCH", FUNCNAME=fm_upper)
                for item in r.get("FUNCTIONS", []):
                    if item.get("FUNCNAME") == fm_upper:
                        self._known_remote_fms.add(fm_upper)
                        return True
        except Exception:
            pass
        return False

    def _call(self, fm: str, **kwargs: Any) -> dict:
        fm_upper = fm.strip().upper()
        if not self.is_remote_enabled(fm_upper):
            raise ValueError(
                f"함수 모듈 '{fm_upper}'은(는) RFC(원격 호출)가 불가능한 로컬 모듈이거나 존재하지 않습니다. "
                "CALL_FUNCTION_NOT_REMOTE 덤프 방지를 위해 호출이 사전 차단되었습니다."
            )
        with self._conn() as c:
            return c.call(fm, **kwargs)

    # --- 단계 0 -------------------------------------------------------
    def ping(self) -> Result:
        try:
            self._call("RFC_PING")
            return Result(True, "RFC_PING OK")
        except Exception as e:  # noqa: BLE001
            return Result(False, f"{type(e).__name__}: {e}")

    def system_info(self) -> Result:
        try:
            r = self._call("RFC_SYSTEM_INFO")["RFCSI_EXPORT"]
            keys = ("RFCSYSID", "RFCHOST", "RFCDEST", "RFCDBSYS", "RFCSAPRL", "RFCKERNRL")
            return Result(True, "OK", {k: r.get(k) for k in keys})
        except Exception as e:  # noqa: BLE001
            return Result(False, f"{type(e).__name__}: {e}")

    # --- 단계 1 이후 (Z_MCP_*) -----------------------------------------
    def search_object(self, pattern, obj_type="", package=""):
        try:
            r = self._call("Z_MCP_SEARCH", IV_PATTERN=pattern, IV_TYPE=obj_type, IV_PACKAGE=package)
            rows = [{"type": o["OBJECT"], "name": o["OBJ_NAME"], "package": o["DEVCLASS"],
                     "author": o.get("AUTHOR", "")} for o in r["ET_OBJECTS"]]
            return Result(True, f"{len(rows)}건", rows)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_source(self, obj_type, name):
        try:
            otype = (obj_type or "PROG").strip().upper()
            r = self._call("Z_MCP_GET_SOURCE", IV_TYPE=otype, IV_NAME=name)
            text = "\n".join(row["LINE"].rstrip() for row in r["ET_SOURCE"])
            return Result(True, f"{len(r['ET_SOURCE'])}줄", text)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_object_metadata(self, obj_type: str, name: str) -> dict[str, Any]:
        """프로그램/Include/함수모듈/클래스의 작성자(AUTHOR/CNAM), 패키지, 하위 Include 목록 등을 조회한다."""
        otype = (obj_type or "PROG").strip().upper()
        oname = name.strip().upper()
        meta: dict[str, Any] = {
            "name": oname,
            "obj_type": otype,
            "author": "",
            "package": "",
            "subc": "",
            "last_changed_by": "",
            "last_changed_on": "",
            "includes": [],
        }
        try:
            tadir_obj = "CLAS" if otype == "CLAS" else ("FUGR" if otype == "FUNC" else "PROG")
            if otype == "FUNC":
                tf = self.read_table("TFDIR", fields=["FUNCNAME", "PNAME", "INCLUDE"],
                                     where_clause=f"FUNCNAME = '{oname}'", max_rows=1)
                if tf.ok and tf.data and tf.data.get("rows"):
                    pname = tf.data["rows"][0].get("PNAME", "")
                    inc_no = tf.data["rows"][0].get("INCLUDE", "")
                    fugr = pname[4:] if pname.startswith("SAPL") else pname
                    meta["function_group"] = fugr
                    meta["include_name"] = f"L{fugr}U{inc_no}" if fugr and inc_no else ""
                    td = self.read_table("TADIR", fields=["AUTHOR", "DEVCLASS"],
                                         where_clause=f"PGMID = 'R3TR' AND OBJECT = 'FUGR' AND OBJ_NAME = '{fugr}'",
                                         max_rows=1)
                    if td.ok and td.data and td.data.get("rows"):
                        meta["author"] = td.data["rows"][0].get("AUTHOR", "")
                        meta["package"] = td.data["rows"][0].get("DEVCLASS", "")
            else:
                td = self.read_table("TADIR", fields=["AUTHOR", "DEVCLASS"],
                                     where_clause=f"PGMID = 'R3TR' AND OBJECT = '{tadir_obj}' AND OBJ_NAME = '{oname}'",
                                     max_rows=1)
                if td.ok and td.data and td.data.get("rows"):
                    meta["author"] = td.data["rows"][0].get("AUTHOR", "")
                    meta["package"] = td.data["rows"][0].get("DEVCLASS", "")

                tr = self.read_table("TRDIR", fields=["NAME", "SUBC", "CNAM", "UNAM", "UDAT"],
                                     where_clause=f"NAME = '{oname}'", max_rows=1)
                if tr.ok and tr.data and tr.data.get("rows"):
                    row = tr.data["rows"][0]
                    meta["subc"] = row.get("SUBC", "")
                    meta["last_changed_by"] = row.get("UNAM", "")
                    meta["last_changed_on"] = row.get("UDAT", "")
                    if not meta["author"]:
                        meta["author"] = row.get("CNAM", "")

                inc_res = self.read_table("D010INC", fields=["INCLUDE"],
                                          where_clause=f"MASTER = '{oname}'", max_rows=100)
                if inc_res.ok and inc_res.data and inc_res.data.get("rows"):
                    meta["includes"] = [
                        r["INCLUDE"] for r in inc_res.data["rows"]
                        if r.get("INCLUDE")
                        and not r["INCLUDE"].startswith(("<", ">", "%_", "RS", "LSVIM", "BDC", "DBPNP"))
                        and "=" not in r["INCLUDE"]
                    ]
        except Exception:
            pass
        return meta

    def read_source(self, name: str, obj_type: str = "PROG") -> Result:
        """소스와 메타데이터(작성자, 패키지, Include 구조 등)를 함께 조회하여 분석한다."""
        otype = (obj_type or "PROG").strip().upper()
        oname = name.strip().upper()
        src_res = self.get_source(otype, oname)
        if not src_res.ok and otype == "PROG":
            # FUNC 또는 CLAS 자동 폴백 탐색
            for fallback_type in ("FUNC", "CLAS", "INCL"):
                alt = self.get_source(fallback_type, oname)
                if alt.ok:
                    otype = fallback_type
                    src_res = alt
                    break
        if not src_res.ok:
            return src_res

        meta = self.get_object_metadata(otype, oname)
        lines = (src_res.data or "").splitlines()
        allowed_authors = {self.s.user.strip().upper()} | {a.upper() for a in self.s.allowed_authors}
        author_upper = (meta.get("author") or "").strip().upper()
        can_modify = (not author_upper) or (author_upper in allowed_authors)

        data = {
            "name": oname,
            "obj_type": otype,
            "system": self.s.system_id,
            "author": meta.get("author", ""),
            "package": meta.get("package", ""),
            "subc": meta.get("subc", ""),
            "last_changed_by": meta.get("last_changed_by", ""),
            "last_changed_on": meta.get("last_changed_on", ""),
            "includes": meta.get("includes", []),
            "modifiable": can_modify,
            "allowed_authors": sorted(list(allowed_authors)),
            "line_count": len(lines),
            "source": src_res.data,
        }
        msg = (
            f"{oname} ({otype}) 소스 조회 완료: {len(lines)}줄 "
            f"[작성자: {meta.get('author') or '미상'}, 패키지: {meta.get('package') or '미상'}, "
            f"수정가능: {'예' if can_modify else '아니오'}]"
        )
        return Result(True, msg, data)

    @staticmethod
    def _lines(source: str) -> list[dict]:
        lines = source.replace("\r\n", "\n").split("\n")
        too_long = [i + 1 for i, ln in enumerate(lines) if len(ln) > 255]
        if too_long:
            raise ValueError(f"255자를 넘는 줄이 있습니다: {too_long[:5]}")
        return [{"LINE": ln} for ln in lines]

    def _write_result(self, r: dict, ok_key: str = "EV_OK") -> Result:
        ok = r.get(ok_key) == "X"
        return Result(ok, r.get("EV_MESSAGE", ""))

    def syntax_check(self, obj_type, name, source):
        try:
            r = self._call("Z_MCP_SYNTAX_CHECK", IV_TYPE=obj_type, IV_NAME=name,
                           IT_SOURCE=self._lines(source))
            if r.get("EV_OK") == "X":
                return Result(True, "문법 오류 없음")
            return Result(False, r.get("EV_MESSAGE", ""),
                          messages=[{"line": r.get("EV_LINE"), "word": r.get("EV_WORD"),
                                     "text": r.get("EV_MESSAGE")}])
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def update_source(self, obj_type, name, source, transport):
        try:
            return self._write_result(self._call(
                "Z_MCP_UPDATE_SOURCE", IV_TYPE=obj_type, IV_NAME=name,
                IV_TRANSPORT=transport, IT_SOURCE=self._lines(source)))
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def activate_object(self, obj_type, name):
        try:
            return self._write_result(self._call("Z_MCP_ACTIVATE", IV_TYPE=obj_type, IV_NAME=name))
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def create_object(self, obj_type, name, package, description, transport):
        try:
            if obj_type.upper() == "PROG":
                init_lines = [{"LINE": f"REPORT {name.lower()}."}, {"LINE": f"* {description}"}]
                self._call(
                    "RPY_PROGRAM_INSERT",
                    PROGRAM_NAME=name.upper(),
                    TITLE_STRING=description or name,
                    PROGRAM_TYPE="1",
                    DEVELOPMENT_CLASS=package.upper() if package else "$TMP",
                    TRANSPORT_NUMBER=transport or "",
                    SUPPRESS_DIALOG="X",
                    SAVE_INACTIVE=" ",
                    SOURCE_EXTENDED=init_lines
                )
                return Result(True, f"프로그램 생성 및 활성화 완료: {name.upper()}")
            return self._write_result(self._call(
                "Z_MCP_CREATE_OBJECT", IV_TYPE=obj_type, IV_NAME=name, IV_PACKAGE=package,
                IV_DESCRIPTION=description, IV_TRANSPORT=transport))
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def delete_object(self, obj_type, name, transport):
        try:
            return self._write_result(self._call(
                "Z_MCP_DELETE_OBJECT", IV_TYPE=obj_type, IV_NAME=name, IV_TRANSPORT=transport))
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_where_used(self, obj_type, name):
        try:
            r = self._call("Z_MCP_WHERE_USED", IV_TYPE=obj_type, IV_NAME=name)
            rows = [x["LINE"].strip() for x in r["ET_USAGES"]]
            return Result(True, f"{len(rows)}건", rows)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))


    def list_transports(self, user=""):
        try:
            r = self._call("Z_MCP_LIST_TRANSPORTS", IV_USER=user)
            rows = [{"trkorr": t["TRKORR"], "user": t["AS4USER"], "date": str(t.get("AS4DATE", "")),
                     "function": t.get("TRFUNCTION", "")} for t in r["ET_REQUESTS"]]
            return Result(True, f"{len(rows)}건", rows)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_payroll_result(self, pernr: str, inper: str = "", payty: str = "",
                           bondt: str = "", seqnr: str = "", mask_sensitive: bool = True):
        try:
            params: dict[str, Any] = {"IV_PERNR": str(pernr).zfill(8)}
            if inper and inper.strip():
                params["IV_INPER"] = inper.strip()
            if payty and payty.strip():
                params["IV_PAYTY"] = payty.strip()
            if bondt and bondt.strip():
                params["IV_BONDT"] = bondt.strip()
            if seqnr and seqnr.strip():
                params["IV_SEQNR"] = str(seqnr).strip().zfill(5)

            r = self._call("Z_MCP_GET_PAYROLL_RESULT", **params)
            ok = r.get("EV_OK") == "X"
            msg = r.get("EV_MESSAGE", "")
            if not ok:
                return Result(False, msg)
            rt = [{"lgart": row["LGART"],
                   "betrg": "***,***" if mask_sensitive else float(row["BETRG"]),
                   "anzhl": float(row["ANZHL"])}
                  for row in r.get("ET_RT", [])]
            directory = [{"seqnr": row["SEQNR"], "inper": row["INPER"], "fpper": row["FPPER"],
                          "payty": row["PAYTY"], "payid": row["PAYID"], "bondt": str(row.get("BONDT", "")),
                          "paydt": str(row.get("PAYDT", "")), "ocrsn": row.get("OCRSN", "")}
                         for row in r.get("ET_DIRECTORY", [])]
            data = {
                "pernr": str(pernr).zfill(8),
                "seqnr": r.get("EV_SEQNR", ""),
                "fpper": r.get("EV_FPPER", ""),
                "inper": r.get("EV_INPER", ""),
                "payty": r.get("EV_PAYTY", ""),
                "payid": r.get("EV_PAYID", ""),
                "bondt": str(r.get("EV_BONDT", "")),
                "paydt": str(r.get("EV_PAYDT", "")),
                "ocrsn": r.get("EV_OCRSN", ""),
                "masked": mask_sensitive,
                "rt": rt,
                "history_count": len(directory),
                "history": directory[:10]  # 최근 10개 급여 이력 미리보기
            }
            return Result(True, f"{msg} ({len(rt)}개 임금유형, 마스킹={mask_sensitive})", data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def compare_payroll_periods(self, pernr: str, inper_a: str, inper_b: str,
                                payty_a: str = "", payty_b: str = "",
                                mask_sensitive: bool = True):
        try:
            # 기간 A 급여 결과 (내부 계산을 위해 mask_sensitive=False로 원본 금액을 읽음)
            res_a = self.get_payroll_result(pernr=pernr, inper=inper_a, payty=payty_a, mask_sensitive=False)
            if not res_a.ok:
                return Result(False, f"기준 기간({inper_a}) 급여 결과 조회 실패: {res_a.message}")

            # 기간 B 급여 결과 (내부 계산을 위해 mask_sensitive=False로 원본 금액을 읽음)
            res_b = self.get_payroll_result(pernr=pernr, inper=inper_b, payty=payty_b, mask_sensitive=False)
            if not res_b.ok:
                return Result(False, f"비교 기간({inper_b}) 급여 결과 조회 실패: {res_b.message}")

            rt_a = {row["lgart"]: float(row["betrg"]) for row in res_a.data.get("rt", [])}
            rt_b = {row["lgart"]: float(row["betrg"]) for row in res_b.data.get("rt", [])}

            all_lgarts = sorted(set(rt_a.keys()) | set(rt_b.keys()))
            items = []
            added = []
            removed = []
            changed = []
            unchanged = []

            for lg in all_lgarts:
                in_a = lg in rt_a
                in_b = lg in rt_b
                val_a = rt_a.get(lg, 0.0)
                val_b = rt_b.get(lg, 0.0)
                diff = round(val_b - val_a, 2)

                if in_a and not in_b:
                    status = "REMOVED"
                    pct = -100.0
                    removed.append(lg)
                elif not in_a and in_b:
                    status = "NEW"
                    pct = 100.0
                    added.append(lg)
                elif diff > 0:
                    status = "INCREASED"
                    pct = round((diff / abs(val_a) * 100), 2) if val_a != 0 else 100.0
                    changed.append(lg)
                elif diff < 0:
                    status = "DECREASED"
                    pct = round((diff / abs(val_a) * 100), 2) if val_a != 0 else -100.0
                    changed.append(lg)
                else:
                    status = "SAME"
                    pct = 0.0
                    unchanged.append(lg)

                items.append({
                    "lgart": lg,
                    "status": status,
                    "amount_a": "***,***" if mask_sensitive else val_a,
                    "amount_b": "***,***" if mask_sensitive else val_b,
                    "diff": "***,***" if mask_sensitive else diff,
                    "change_pct": f"{pct:+.2f}%" if pct != 0.0 else "0.00%",
                })

            def _get_status(lg):
                v_a = rt_a.get(lg)
                v_b = rt_b.get(lg)
                if v_a is None or v_b is None:
                    return "NOT_FOUND"
                if v_b > v_a:
                    return "INCREASED"
                elif v_b < v_a:
                    return "DECREASED"
                return "SAME"

            gross_stat = _get_status("/101")
            net_stat = _get_status("/560")

            summary = {
                "pernr": str(pernr).zfill(8),
                "period_a": inper_a,
                "period_b": inper_b,
                "masked": mask_sensitive,
                "total_wagetypes_a": len(rt_a),
                "total_wagetypes_b": len(rt_b),
                "added_count": len(added),
                "removed_count": len(removed),
                "changed_count": len(changed),
                "unchanged_count": len(unchanged),
                "added_wagetypes": added,
                "removed_wagetypes": removed,
                "changed_wagetypes": changed,
                "gross_pay_trend": gross_stat,
                "net_pay_trend": net_stat,
                "comparison_items": items,
            }

            msg = (f"사원 {pernr}: 기간 {inper_a} vs {inper_b} 비교 완료 "
                   f"(신규 {len(added)}건, 삭제 {len(removed)}건, 변동 {len(changed)}건, 동일 {len(unchanged)}건, 마스킹={mask_sensitive})")
            return Result(True, msg, summary)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_replication_log(self, pernr: str = "", ext_id: str = "",
                            trigger_replication: bool = False, config_id: str = "",
                            date_from: str = "", date_to: str = "",
                            msgty: str = "", subobject: str = "",
                            max_rows: int = 100):
        try:
            params: dict[str, Any] = {}
            if pernr and pernr.strip():
                params["IV_PERNR"] = str(pernr).strip().zfill(8)
            if ext_id and ext_id.strip():
                params["IV_EXT_ID"] = ext_id.strip()
            if trigger_replication:
                params["IV_TRIGGER_REPL"] = "X"
            if config_id and config_id.strip():
                params["IV_CONFIG_ID"] = config_id.strip()
            if date_from and date_from.strip():
                params["IV_DATE_FROM"] = date_from.strip()
            if date_to and date_to.strip():
                params["IV_DATE_TO"] = date_to.strip()
            if msgty and msgty.strip():
                params["IV_MSGTY"] = msgty.strip().upper()
            if subobject and subobject.strip():
                params["IV_SUBOBJECT"] = subobject.strip().upper()
            if max_rows and max_rows > 0:
                params["IV_MAX"] = int(max_rows)

            r = self._call("Z_MCP_GET_REPLICATION_LOG", **params)
            ok = r.get("EV_OK") == "X"
            msg = r.get("EV_MESSAGE", "")
            if not ok:
                return Result(False, msg)

            headers = [{
                "lognumber": row.get("LOGNUMBER", ""),
                "date": str(row.get("ALDATE", "")),
                "time": str(row.get("ALTIME", "")),
                "user": row.get("ALUSER", "").strip(),
                "extnumber": row.get("EXTNUMBER", "").strip(),
                "object": row.get("OBJECT", "").strip(),
                "subobject": row.get("SUBOBJECT", "").strip(),
                "total_msgs": row.get("MSG_CNT_AL", 0),
                "error_msgs": row.get("MSG_CNT_E", 0),
                "warning_msgs": row.get("MSG_CNT_W", 0),
            } for row in r.get("ET_HEADERS", [])]

            messages = [{
                "type": row.get("TYPE", ""),
                "id": row.get("ID", "").strip(),
                "number": row.get("NUMBER", ""),
                "message": row.get("MESSAGE", "").strip(),
                "log_no": row.get("LOG_NO", "").strip(),
                "target_id": row.get("PARAMETER", "").strip(),
            } for row in r.get("ET_MESSAGES", [])]

            data = {
                "total_logs": r.get("EV_TOTAL_LOGS", len(headers)),
                "error_count": r.get("EV_ERROR_COUNT", 0),
                "headers": headers,
                "messages": messages,
            }
            return Result(True, msg, data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def diagnose_message(self, msg_id: str = "", msg_no: str = "", query: str = "",
                         v1: str = "", v2: str = "", v3: str = "", v4: str = "",
                         lang: str = "3") -> Result:
        try:
            curated_guides = {
                ("PG", "033"): {
                    "title": "사원번호 내부 채번 충돌 (Internal Number Range Conflict)",
                    "cause": "현재 인사영역/사원그룹에 지정된 사번 번호범위가 '내부 채번(Internal)'으로 설정되어 있어 사용자가 사번을 직접 입력할 수 없습니다.",
                    "solutions": [
                        "1) [가장 권장] 사원번호 입력란을 완전히 비워두고(공란) Enter를 누르면 시스템이 번호범위 내 다음 번호를 자동 채번합니다.",
                        "2) 특정 사번을 직접 지정하려면 트랜잭션 PA04에서 해당 번호범위에 'EXT(외부)' 체크박스를 활성화해야 합니다.",
                        "3) 특정 인사영역만 외부 채번을 쓰려면 트랜잭션 PE03에서 피처 NUMKR의 분기 설정을 확인하십시오.",
                    ],
                    "related_tcodes": ["PA40", "PA30", "PA04", "PE03 (피처 NUMKR)"],
                },
                ("PG", "001"): {
                    "title": "사번 번호범위 미정의",
                    "cause": "해당 인사영역 또는 사원그룹에 연결된 번호범위 인터벌이 생성되지 않았습니다.",
                    "solutions": [
                        "트랜잭션 PA04에서 누락된 번호범위 인터벌(01 등)을 생성하십시오.",
                    ],
                    "related_tcodes": ["PA04", "PE03"],
                },
                ("PG", "051"): {
                    "title": "피처 NUMKR 오류",
                    "cause": "사원 번호범위를 결정하는 피처 NUMKR에 현재 회사코드/인사영역에 대한 반환값이 정의되지 않았습니다.",
                    "solutions": [
                        "트랜잭션 PE03에서 피처 NUMKR을 열고 결정 트리에 현재 조직 코드를 추가하십시오.",
                    ],
                    "related_tcodes": ["PE03"],
                },
                ("PG", "032"): {
                    "title": "사원번호 외부 채번 필수",
                    "cause": "현재 번호범위가 '외부 채번'으로 설정되어 있어 사원번호를 반드시 수동으로 입력해야 합니다.",
                    "solutions": [
                        "사원번호 입력란에 유효한 사원번호를 직접 입력하십시오.",
                    ],
                    "related_tcodes": ["PA40", "PA04"],
                },
            }

            matched_id = msg_id.strip().upper()
            matched_no = msg_no.strip().zfill(3) if msg_no.strip() else ""

            # 검색어로 조회하는 경우
            if query and not (matched_id and matched_no):
                q = query.strip()
                search_classes = ["PG", "PB", "RP", "00", "HR"]
                found_list = []
                with self._conn() as c:
                    for cls in search_classes:
                        for num in range(1, 100):
                            num_str = f"{num:03d}"
                            try:
                                r = c.call("BAPI_MESSAGE_GETDETAIL", ID=cls, NUMBER=num_str,
                                           LANGUAGE=lang, MESSAGE_V1=v1 or "01", TEXTFORMAT="ASC")
                                txt = r.get("MESSAGE", "")
                                if q in txt:
                                    guide = curated_guides.get((cls, num_str), {})
                                    found_list.append({
                                        "id": cls,
                                        "number": num_str,
                                        "message": txt,
                                        "guide": guide,
                                    })
                                    if len(found_list) >= 5:
                                        break
                            except Exception:
                                pass
                        if len(found_list) >= 5:
                            break
                if found_list:
                    return Result(True, f"검색어 '{q}' 관련 메시지 {len(found_list)}건 발견", found_list)
                return Result(False, f"검색어 '{q}'와 일치하는 메시지를 찾을 수 없습니다.")

            if not (matched_id and matched_no):
                return Result(False, "메시지 ID와 번호를 입력하거나 검색어(query)를 지정하십시오 (예: id='PG', number='033').")

            with self._conn() as c:
                r_kr = c.call("BAPI_MESSAGE_GETDETAIL", ID=matched_id, NUMBER=matched_no,
                              LANGUAGE=lang, MESSAGE_V1=v1, MESSAGE_V2=v2, MESSAGE_V3=v3, MESSAGE_V4=v4,
                              TEXTFORMAT="ASC")
                msg_kr = r_kr.get("MESSAGE", "").strip()
                lines_kr = [x.get("LINE", "") for x in r_kr.get("TEXT", [])]

                msg_en = ""
                lines_en = []
                try:
                    r_en = c.call("BAPI_MESSAGE_GETDETAIL", ID=matched_id, NUMBER=matched_no,
                                  LANGUAGE="E", MESSAGE_V1=v1, MESSAGE_V2=v2, MESSAGE_V3=v3, MESSAGE_V4=v4,
                                  TEXTFORMAT="ASC")
                    msg_en = r_en.get("MESSAGE", "").strip()
                    lines_en = [x.get("LINE", "") for x in r_en.get("TEXT", [])]
                except Exception:
                    pass

            guide = curated_guides.get((matched_id, matched_no), {})

            data = {
                "id": matched_id,
                "number": matched_no,
                "message_kr": msg_kr,
                "message_en": msg_en,
                "documentation_kr": lines_kr,
                "documentation_en": lines_en,
                "guide": guide,
            }

            summary = f"[{matched_id} {matched_no}] {msg_kr}"
            return Result(True, summary, data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def check_function_module(self, name: str) -> Result:
        try:
            fm_upper = name.strip().upper()
            if not fm_upper:
                return Result(False, "함수 모듈명을 입력하십시오.")

            with self._conn() as c:
                try:
                    r = c.call("RFC_FUNCTION_SEARCH", FUNCNAME=fm_upper)
                    fns = r.get("FUNCTIONS", [])
                    matched = [f for f in fns if f.get("FUNCNAME") == fm_upper]
                    if matched:
                        f_info = matched[0]
                        self._known_remote_fms.add(fm_upper)
                        return Result(
                            True,
                            f"함수 모듈 '{fm_upper}'은(는) 원격 호출(RFC)이 가능한 모듈입니다.",
                            {
                                "name": fm_upper,
                                "is_remote_enabled": True,
                                "group": f_info.get("GROUPNAME", ""),
                                "text": f_info.get("STEXT", ""),
                            },
                        )
                except Exception as e:
                    if "NO_FUNCTION_FOUND" not in str(e):
                        return Result(False, _err(e))

            return Result(
                False,
                f"함수 모듈 '{fm_upper}'은(는) 원격 호출(RFC)이 지원되지 않는 로컬 모듈이거나 존재하지 않습니다. "
                "직접 호출 시 SAP에 CALL_FUNCTION_NOT_REMOTE 덤프가 발생하므로 호출이 사전 차단되었습니다.",
                {
                    "name": fm_upper,
                    "is_remote_enabled": False,
                },
            )
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_recent_dumps(self, date_from: str = "", date_to: str = "",
                         user: str = "", program: str = "",
                         max_rows: int = 20) -> Result:
        try:
            import datetime
            today = datetime.date.today().strftime("%Y%m%d")
            d_from = date_from.strip() or today
            d_to = date_to.strip() or today

            params: dict[str, Any] = {
                "DATE_FROM": d_from,
                "DATE_TO": d_to,
            }
            r = self._call("/SDF/GET_DUMP_LOG", **params)
            raw_logs = r.get("ET_E2E_LOG", [])

            dumps = []
            filter_user = user.strip().upper()
            filter_prog = program.strip().upper()

            for item in raw_logs:
                u = item.get("E2E_USER", "").upper()
                p = item.get("FIELD4", "").upper()
                if filter_user and filter_user not in u:
                    continue
                if filter_prog and filter_prog not in p:
                    continue
                dumps.append({
                    "date": item.get("E2E_DATE", ""),
                    "time": item.get("E2E_TIME", ""),
                    "user": item.get("E2E_USER", ""),
                    "error": item.get("FIELD1", ""),
                    "program": item.get("FIELD4", ""),
                    "component": item.get("FIELD3", ""),
                    "message": item.get("FIELD9", ""),
                })
                if len(dumps) >= max_rows:
                    break

            summary = f"ST22 덤프 {len(dumps)}건 조회됨 (조회 기간: {d_from}~{d_to})"
            return Result(True, summary, dumps)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def read_table(self, table_name: str, fields: list[str] | None = None,
                   where_clause: str = "", max_rows: int = 100) -> Result:
        try:
            q_table = table_name.strip().upper()
            if not q_table:
                return Result(False, "테이블명을 입력하세요.")

            field_list = [{"FIELDNAME": f.strip().upper()} for f in (fields or []) if f.strip()]

            # OPTIONS splitting (max 72 chars per line in SAP BBP_RFC_READ_TABLE)
            options = []
            if where_clause:
                words = where_clause.strip().split(" ")
                curr_line = ""
                for word in words:
                    if not curr_line:
                        curr_line = word
                    elif len(curr_line) + len(word) + 1 <= 72:
                        curr_line += " " + word
                    else:
                        options.append({"TEXT": curr_line})
                        curr_line = word
                if curr_line:
                    options.append({"TEXT": curr_line})

            params: dict[str, Any] = {
                "QUERY_TABLE": q_table,
                "DELIMITER": "|",
                "ROWCOUNT": max_rows,
            }
            if field_list:
                params["FIELDS"] = field_list
            if options:
                params["OPTIONS"] = options

            r = self._call("BBP_RFC_READ_TABLE", **params)

            field_meta = [f["FIELDNAME"].strip() for f in r.get("FIELDS", [])]
            raw_data = r.get("DATA", [])

            rows = []
            for row in raw_data:
                wa = row.get("WA", "")
                parts = wa.split("|")
                row_dict = {}
                for i, col in enumerate(field_meta):
                    val = parts[i].strip() if i < len(parts) else ""
                    row_dict[col] = val
                rows.append(row_dict)

            return Result(
                True,
                f"테이블 {q_table}에서 {len(rows)}건 조회되었습니다.",
                {
                    "table": q_table,
                    "columns": field_meta,
                    "row_count": len(rows),
                    "rows": rows,
                },
            )
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def check_infotype_config(self, infty: str, molga: str = "") -> Result:
        try:
            infty_clean = infty.strip().zfill(4)
            molga_clean = molga.strip()

            # 1. T582A: 인포타입 기본 설정 (대화 모듈, 서브타입 필드 등)
            t582a_res = self.read_table("T582A", where_clause=f"INFTY = '{infty_clean}'", max_rows=5)

            # 2. T582V: 화면/모듈풀 버전 매핑 (DYNPRO_NOT_FOUND의 핵심 원인 점검)
            t582v_where = f"INFTY = '{infty_clean}'"
            if molga_clean:
                t582v_where += f" AND ( MOLGA = '{molga_clean}' OR MOLGA = ' ' )"
            t582v_res = self.read_table("T582V", where_clause=t582v_where, max_rows=50)

            # 3. T588M: 화면 헤더 및 필드 제어 (가변 화면)
            t588m_res = self.read_table("T588M", where_clause=f"INFTY = '{infty_clean}'", max_rows=50)

            findings = []
            if not t582a_res.ok or not t582a_res.data.get("rows"):
                findings.append(f"경고: T582A에 인포타입 '{infty_clean}' 기본 설정이 없습니다.")

            t582v_rows = t582v_res.data.get("rows", []) if t582v_res.ok else []
            has_blank_molga = any(r.get("MOLGA") == "" for r in t582v_rows)
            if not has_blank_molga:
                findings.append(
                    "주의: T582V에 기본값(MOLGA = ' ' 공백) 매핑이 없습니다. "
                    "국가그룹(MOLGA)이 매핑되지 않았거나 PA40/PA30 초기화 단계에서 "
                    "DYNPRO_NOT_FOUND 덤프가 발생할 수 있습니다."
                )

            if molga_clean:
                has_target_molga = any(r.get("MOLGA") == molga_clean for r in t582v_rows)
                if not has_target_molga:
                    findings.append(f"알림: 지정한 국가그룹 MOLGA='{molga_clean}'에 대한 전용 T582V 매핑이 없습니다. (공백 기본값 사용 여부 확인 필요)")

            data = {
                "infty": infty_clean,
                "t582a": t582a_res.data.get("rows", []) if t582a_res.ok else [],
                "t582v": t582v_rows,
                "t588m_count": len(t588m_res.data.get("rows", [])) if t588m_res.ok else 0,
                "findings": findings,
            }
            summary = f"인포타입 {infty_clean} 점검 완료 ({len(findings)}건 주의/참고사항 발견)"
            return Result(True, summary, data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def run_payroll(self, pernr: str = "", inper: str = "", test_run: bool = True,
                    schema: str = "KR00", abkrs: str = "") -> Result:
        try:
            # 1. PA03 급여 제어 레코드 사전 점검 (정확한 급여영역명 및 상태 확인)
            pa03_check = self.check_payroll_control_record(abkrs=abkrs, pernr=pernr)
            if not pa03_check.ok:
                guide_text = pa03_check.data.get("guide", "") if pa03_check.data else ""
                err_msg = f"{pa03_check.message}\n\n{guide_text}".strip()
                return Result(False, err_msg, pa03_check.data)

            pa03_data = pa03_check.data or {}
            can_run = pa03_data.get("can_run_payroll", False)
            area_display = (
                f"'{pa03_data.get('abkrs')}' ({pa03_data.get('abkrs_text')})"
                if pa03_data.get("abkrs_text")
                else f"'{pa03_data.get('abkrs')}'"
            )

            # 실제 급여 계산(test_run=False)의 경우 급여 릴리즈 상태('0')가 아니면 즉시 차단
            if not test_run and not can_run:
                err_msg = (
                    f"실제 급여 계산 실행 불가: 급여 영역 {area_display}가 급여 릴리즈 상태가 아닙니다.\n"
                    f"- 현재 상태: {pa03_data.get('state_text')}\n"
                    f"- 관리 기간: {pa03_data.get('payroll_period')}\n\n"
                    f"[필요 조치]\n{pa03_data.get('guide')}"
                )
                return Result(False, err_msg, pa03_data)

            # 2. RFC 호출 파라미터 준비
            params: dict[str, Any] = {
                "IV_SCHEMA": schema.strip() or "KR00",
                "IV_TEST": "X" if test_run else " ",
            }
            if pernr and pernr.strip():
                params["IV_PERNR"] = str(pernr).strip().zfill(8)
            if inper and inper.strip():
                params["IV_INPER"] = inper.strip()
            effective_abkrs = (abkrs or pa03_data.get("abkrs", "")).strip().upper()
            if effective_abkrs:
                params["IV_ABKRS"] = effective_abkrs

            r = self._call("Z_MCP_RUN_PAYROLL", **params)

            ok = r.get("EV_OK") == "X"
            has_error = r.get("EV_ERROR") == "X"
            msg = r.get("EV_MESSAGE", "")
            is_retro = r.get("EV_RETRO") == "X"
            retro_count = int(r.get("EV_RETRO_COUNT") or 0)

            # 3. RT 테이블 파싱 (실제 계산된 임금유형 / 금액 / 수량)
            raw_rt = r.get("ET_RT", [])
            rt = [{
                "lgart": row.get("LGART", "").strip(),
                "betrg": float(row.get("BETRG") or 0.0),
                "anzhl": float(row.get("ANZHL") or 0.0),
            } for row in raw_rt]

            # 4. 소급 기간 목록
            retro_periods = [{
                "seqnr": row.get("SEQNR", ""),
                "inper": row.get("INPER", ""),
                "fpper": row.get("FPPER", ""),
                "payty": row.get("PAYTY", ""),
                "srtza": row.get("SRTZA", ""),
            } for row in r.get("ET_RETRO_PERIODS", [])]

            # 5. 실행 로그 (오류 라인 선별)
            raw_log = [line.get("LINE", "").strip() for line in r.get("ET_LOG", [])]
            log_lines = [l for l in raw_log if l]
            error_lines = [
                l for l in log_lines
                if any(k in l for k in ("오류", "거부", "Error", "Rejected", "Fehler"))
                and "0 오류" not in l and "0 거부" not in l
            ]

            data = {
                "pernr": str(pernr).strip().zfill(8) if pernr else "",
                "abkrs": pa03_data.get("abkrs", ""),
                "abkrs_text": pa03_data.get("abkrs_text", ""),
                "test_run": test_run,
                "inper": r.get("EV_INPER", inper),
                "fpper": r.get("EV_FPPER", ""),
                "seqnr": r.get("EV_SEQNR", ""),
                "schema": schema,
                "pa03_status": pa03_data,
                "has_error": has_error,
                "error_messages": error_lines,
                "is_retro": is_retro,
                "retro_count": retro_count,
                "retro_periods": retro_periods,
                "rt_count": len(rt),
                "rt": rt,
                "log_summary": log_lines[:25] if (test_run or has_error) else [],
            }

            return Result(ok and not has_error, msg, data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def check_payroll_control_record(self, abkrs: str = "", pernr: str = "") -> Result:
        try:
            target_abkrs = abkrs.strip().upper()
            target_pernr = str(pernr).strip().zfill(8) if pernr and pernr.strip() else ""

            # 사번이 입력된 경우 PA0001에서 ABKRS 자동 판별
            if not target_abkrs and target_pernr:
                p1_res = self.read_table("PA0001", where_clause=f"PERNR = '{target_pernr}'",
                                         fields=["ABKRS", "BEGDA", "ENDDA"], max_rows=5)
                if not p1_res.ok or not p1_res.data.get("rows"):
                    return Result(False, f"사원 '{target_pernr}'의 인사 마스터(PA0001) 레코드를 찾을 수 없습니다.")
                target_abkrs = p1_res.data["rows"][0].get("ABKRS", "").strip().upper()

            if not target_abkrs:
                return Result(False, "급여 영역(ABKRS) 또는 사원번호(PERNR)를 입력해 주세요.")

            # 급여영역 텍스트 조회 (T549T: 언어 필드명은 SPRSL)
            abkrs_text = ""
            t549t_res = self.read_table("T549T", where_clause=f"ABKRS = '{target_abkrs}'",
                                        fields=["ATEXT", "SPRSL"], max_rows=10)
            if t549t_res.ok and t549t_res.data.get("rows"):
                rows = t549t_res.data["rows"]
                # 한국어(3) 또는 영문(E) 우선 탐색
                ko_row = next((r for r in rows if r.get("SPRSL") == "3"), None)
                if ko_row:
                    abkrs_text = ko_row.get("ATEXT", "").strip()
                else:
                    abkrs_text = rows[0].get("ATEXT", "").strip()

            area_display = f"'{target_abkrs}' ({abkrs_text})" if abkrs_text else f"'{target_abkrs}'"

            # 급여제어레코드 조회 (T569V)
            t569v_res = self.read_table("T569V", where_clause=f"ABKRS = '{target_abkrs}'", max_rows=5)
            if not t569v_res.ok or not t569v_res.data.get("rows"):
                guide = (
                    f"급여 영역 {area_display}의 급여 제어 레코드(PA03 / T569V)가 생성되어 있지 않습니다.\n"
                    f"[조치 방법]\n"
                    f"1. SAP GUI에서 트랜잭션 코드 'PA03'을 실행합니다.\n"
                    f"2. 급여 계산 영역에 '{target_abkrs}'를 입력하고 [생성] 버튼을 클릭합니다.\n"
                    f"3. 급여 기간(예: 2026/10) 및 최하위 소급 계산 기간을 입력하고 저장합니다.\n"
                    f"4. 상단 메뉴/버튼에서 [급여 릴리즈]를 수행하여 상태를 '급여 릴리즈'로 설정하십시오."
                )
                data = {
                    "abkrs": target_abkrs,
                    "abkrs_text": abkrs_text,
                    "pernr": target_pernr,
                    "exists": False,
                    "can_run_payroll": False,
                    "state": "",
                    "state_text": "제어 레코드 미생성 (Not created)",
                    "guide": guide,
                }
                return Result(False, f"급여 영역 {area_display}의 급여 제어 레코드(PA03)가 존재하지 않습니다.", data)

            row = t569v_res.data["rows"][0]
            state = row.get("STATE", "").strip()
            pabrj = row.get("PABRJ", "").strip()
            pabrp = row.get("PABRP", "").strip()
            uabrj = row.get("UABRJ", "").strip()
            uabrp = row.get("UABRP", "").strip()

            # SAP 표준 도메인 VWSTA 고정값:
            # 0: 신규(New), 1: 급여릴리즈(Released for payroll), 2: 수정릴리즈(Payroll correction), 3: 급여종료(Exit payroll), 4: 급여결과점검(Check payroll results)
            state_map = {
                "0": "신규 (New)",
                "1": "급여 릴리즈 (Released for payroll)",
                "2": "수정 릴리즈 (Payroll correction)",
                "3": "급여 종료 (Exit payroll)",
                "4": "급여 결과 점검 (Check payroll results)",
                "9": "삭제 (Deleted)",
            }
            state_text = state_map.get(state, f"기타 상태 ({state})")
            can_run = (state == "1")

            if can_run:
                guide = f"급여 영역 {area_display}는 현재 '급여 릴리즈' 상태({pabrj}년 {pabrp}기)로, 정상적으로 급여 계산 실행이 가능합니다."
            elif state == "0":
                guide = (
                    f"급여 영역 {area_display}는 '신규' 생성 상태입니다.\n"
                    f"[조치 방법] 트랜잭션 PA03에서 [급여 릴리즈] 버튼을 클릭하여 상태를 '급여 릴리즈(1)'로 변경하십시오."
                )
            elif state == "2":
                guide = (
                    f"급여 영역 {area_display}는 현재 '수정 릴리즈' 상태입니다. 마스터 데이터 수정만 허용되며 급여 계산은 실행할 수 없습니다.\n"
                    f"[조치 방법] 트랜잭션 PA03에서 급여 영역 '{target_abkrs}'를 조회한 후 [급여 릴리즈] 버튼을 클릭하여 상태를 '급여 릴리즈'로 변경하십시오."
                )
            elif state == "3":
                guide = (
                    f"급여 영역 {area_display}는 현재 '급여 종료' 상태({pabrj}년 {pabrp}기)입니다. 해당 회차의 급여 작업이 완료되었습니다.\n"
                    f"[조치 방법] 다음 회차 급여를 계산하려면 트랜잭션 PA03에서 [급여 릴리즈]를 수행하십시오 (회차가 1회차 자동 증가합니다)."
                )
            elif state == "4":
                guide = (
                    f"급여 영역 {area_display}는 현재 '급여 결과 점검' 상태입니다. 계산 결과를 확인 및 검토하는 단계입니다.\n"
                    f"[조치 방법] 급여를 재계산하려면 트랜잭션 PA03에서 [급여 릴리즈]를 클릭하십시오. 최종 마감하려면 [급여 종료]를 수행하십시오."
                )
            else:
                guide = f"급여 영역 {area_display}의 현재 상태({state})에서는 급여 계산이 제한될 수 있습니다. 트랜잭션 PA03 상태를 확인하세요."

            data = {
                "abkrs": target_abkrs,
                "abkrs_text": abkrs_text,
                "pernr": target_pernr,
                "exists": True,
                "state": state,
                "state_text": state_text,
                "can_run_payroll": can_run,
                "payroll_period": f"{pabrj}/{pabrp}",
                "earliest_retro_period": f"{uabrj}/{uabrp}",
                "guide": guide,
            }

            summary = f"급여 영역 {area_display} 상태: {state_text} (계산 가능 여부: {'가능' if can_run else '불가'})"
            return Result(True, summary, data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))

    def get_replication_status(self, pernr: str = "", ext_id: str = "",
                               status_filter: str = "ALL", max_rows: int = 20) -> Result:
        try:
            target_ext_id = ext_id.strip() if ext_id else ""
            target_pernr = str(pernr).strip().zfill(8) if pernr and pernr.strip() else ""

            # 만약 pernr가 주어지고 ext_id가 없으면, PA0709 (사원 매핑) 확인
            if target_pernr and not target_ext_id:
                r_map = self.read_table("PA0709", fields=["PERNR", "PERID"],
                                        where_clause=f"PERNR = '{target_pernr}'", max_rows=1)
                if r_map.ok and r_map.data and r_map.data.get("rows"):
                    target_ext_id = str(r_map.data["rows"][0].get("PERID", "")).strip()

            # HRSFEC_D_REPSTAT 조회 조건 구성
            where_parts = []
            if target_ext_id:
                where_parts.append(f"( USER_ID = '{target_ext_id}' OR EMPLOYEE_ID_EXT = '{target_ext_id}' )")

            sf = status_filter.upper().strip()
            if sf == "FAILED":
                where_parts.append("( CUR_REPL_STATUS <> '5' OR NUMBER_OF_FAILED_ATTEMPTS > 0 )")
            elif sf == "SUCCESS":
                where_parts.append("CUR_REPL_STATUS = '5' AND NUMBER_OF_FAILED_ATTEMPTS = 0")

            where_clause = " AND ".join(where_parts)

            rep_fields = ["USER_ID", "EMPLOYEE_ID_EXT", "CUR_REPL_STATUS",
                          "NUMBER_OF_FAILED_ATTEMPTS", "CUR_REPL_END_DATETIME",
                          "FIRST_FAILED_REPL_END_DATETIME"]

            r_rep = self.read_table("HRSFEC_D_REPSTAT", fields=rep_fields,
                                    where_clause=where_clause, max_rows=max_rows)

            if not r_rep.ok:
                return Result(False, f"복제 상태 테이블(HRSFEC_D_REPSTAT) 조회 실패: {r_rep.message}")

            # 최근 복제 에러/상태 메시지(HRSFEC_D_REPSMSG) 조회
            msg_where = f"PERNR = '{target_pernr}'" if target_pernr else ""
            msg_fields = ["PERNR", "INFTY", "MSGTY", "MSGID", "MSGNO", "MSGV1", "MSGV2"]
            r_msg = self.read_table("HRSFEC_D_REPSMSG", fields=msg_fields,
                                    where_clause=msg_where, max_rows=30)

            pernr_msgs: dict[str, list] = {}
            raw_msg_rows = r_msg.data.get("rows", []) if (r_msg.ok and r_msg.data) else []
            for m in raw_msg_rows:
                p = m.get("PERNR", "")
                if p not in pernr_msgs:
                    pernr_msgs[p] = []
                pernr_msgs[p].append({
                    "infty": m.get("INFTY", ""),
                    "msgty": m.get("MSGTY", ""),
                    "msgid": m.get("MSGID", ""),
                    "msgno": m.get("MSGNO", ""),
                    "v1": m.get("MSGV1", ""),
                    "v2": m.get("MSGV2", "")
                })

            status_map = {
                "5": "SUCCESS",
                "3": "IN_PROGRESS",
                "1": "PENDING"
            }

            records = []
            failed_count = 0
            success_count = 0

            rep_rows = r_rep.data.get("rows", []) if r_rep.data else []
            for row in rep_rows:
                raw_stat = str(row.get("CUR_REPL_STATUS", "")).strip()
                try:
                    fail_att = int(str(row.get("NUMBER_OF_FAILED_ATTEMPTS", "0")).strip() or "0")
                except ValueError:
                    fail_att = 0

                if raw_stat == "5" and fail_att == 0:
                    status_desc = "SUCCESS"
                    success_count += 1
                elif fail_att > 0 or (raw_stat and raw_stat != "5"):
                    status_desc = "FAILED"
                    failed_count += 1
                else:
                    status_desc = status_map.get(raw_stat, f"STATUS_{raw_stat}")

                end_dt = str(row.get("CUR_REPL_END_DATETIME", "")).strip()
                formatted_dt = end_dt
                if len(end_dt) >= 14:
                    formatted_dt = f"{end_dt[0:4]}-{end_dt[4:6]}-{end_dt[6:8]} {end_dt[8:10]}:{end_dt[10:12]}:{end_dt[12:14]}"

                rec = {
                    "user_id": row.get("USER_ID", "").strip(),
                    "employee_id_ext": row.get("EMPLOYEE_ID_EXT", "").strip(),
                    "status": status_desc,
                    "failed_attempts": fail_att,
                    "last_replicated_at": formatted_dt,
                    "messages": pernr_msgs.get(target_pernr, []) if target_pernr else []
                }
                records.append(rec)

            summary_data = {
                "filter_pernr": target_pernr,
                "filter_ext_id": target_ext_id,
                "status_filter": sf,
                "total_count": len(records),
                "failed_count": failed_count,
                "success_count": success_count,
                "recent_error_messages": raw_msg_rows[:10],
                "items": records
            }

            msg = f"EC-ECP 복제 상태 조회 완료 (총 {len(records)}건: 성공 {success_count}건, 실패 {failed_count}건)"
            return Result(True, msg, summary_data)
        except Exception as e:  # noqa: BLE001
            return Result(False, _err(e))



