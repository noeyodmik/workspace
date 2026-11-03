"""SAP MCP 서버 진입점 (FastMCP, stdio). 다중 SAP 시스템(EA3, GY7 등) 지원."""
from __future__ import annotations

import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from mcp.server.fastmcp import FastMCP  # noqa: E402

from backends.base import Result, SapBackend  # noqa: E402
from backends.rfc_backend import RfcBackend  # noqa: E402
from backends.ec_backend import EcBackend  # noqa: E402
from config import Settings, list_available_systems  # noqa: E402
from guard import Audit, Guard, GuardError, backup_source  # noqa: E402

mcp = FastMCP("sap-abap")

# 다중 시스템 컨텍스트 관리
_backends: dict[str, RfcBackend] = {}
_guards: dict[str, Guard] = {}
_audits: dict[str, Audit] = {}
_settings_map: dict[str, Settings] = {}
_sysid_cache: dict[str, str] = {}

_active_system: str = os.getenv("SAP_DEFAULT_SYSTEM", "EA3").strip().upper()
_default_settings = Settings(_active_system)
_default_ec_backend = EcBackend(_default_settings)


def _get_context(system_id: str = "") -> tuple[RfcBackend, Guard, Audit, Settings]:
    """지정된 시스템 ID 또는 현재 활성 시스템의 백엔드 컨텍스트를 반환한다."""
    global _active_system
    sys_id = (system_id or _active_system).strip().upper()
    if sys_id not in _settings_map:
        s = Settings(sys_id)
        _settings_map[sys_id] = s
        _backends[sys_id] = RfcBackend(s)
        _guards[sys_id] = Guard(s)
        _audits[sys_id] = Audit(s)
    return _backends[sys_id], _guards[sys_id], _audits[sys_id], _settings_map[sys_id]


def _out(r: Result) -> dict:
    return {"ok": r.ok, "message": r.message, "data": r.data, "messages": r.messages}


def _sysid(system: str = "") -> str | None:
    backend, _, _, s = _get_context(system)
    key = s.system_id
    if key not in _sysid_cache:
        r = backend.system_info()
        if r.ok and r.data:
            _sysid_cache[key] = r.data.get("RFCSYSID", key)
        else:
            _sysid_cache[key] = key
    return _sysid_cache.get(key)


# --- 다중 시스템 관리 툴 ---------------------------------------------
@mcp.tool()
def list_systems() -> dict:
    """설정된 SAP 시스템 목록과 현재 활성화된 시스템을 조회한다."""
    available = list_available_systems()
    return {
        "ok": True,
        "active_system": _active_system,
        "available_systems": available,
        "message": f"현재 활성 시스템: {_active_system} (사용 가능: {', '.join(available)})"
    }


@mcp.tool()
def switch_system(system_id: str) -> dict:
    """작업 대상 기본 SAP 시스템을 전환한다 (예: 'EA3' <-> 'GY7').
    - system_id: 전환할 시스템 ID (예: 'GY7', 'EA3')
    """
    global _active_system
    target = system_id.strip().upper()
    available = list_available_systems()
    if target not in available:
        return {
            "ok": False,
            "message": f"등록되지 않은 시스템 ID입니다: '{target}'. 사용 가능한 시스템: {', '.join(available)}"
        }

    _active_system = target
    b, _, _, s = _get_context(target)
    miss = s.missing()
    if miss:
        return {
            "ok": False,
            "active_system": _active_system,
            "message": f"활성 시스템이 '{target}'(으)로 변경되었으나 필수 접속 환경변수가 누락되었습니다: {', '.join(miss)}"
        }

    # 연결 테스트
    ping_res = b.ping()
    sys_info = b.system_info()
    return {
        "ok": ping_res.ok,
        "active_system": _active_system,
        "ping_ok": ping_res.ok,
        "system_info": sys_info.data if sys_info.ok else None,
        "message": f"활성 SAP 시스템이 '{target}'(으)로 전환되었습니다. (연결 상태: {ping_res.message})"
    }


# --- 기존 도구들 (system 파라미터 지원) --------------------------------
@mcp.tool()
def ping(system: str = "") -> dict:
    """SAP 접속을 확인한다 (RFC_PING).
    - system: 특정 시스템 ID (선택, 미입력 시 현재 활성 시스템)
    """
    b, _, _, s = _get_context(system)
    miss = s.missing()
    if miss:
        return {"ok": False, "message": f"환경변수 누락 ({s.system_id}): {', '.join(miss)}"}
    res = b.ping()
    out = _out(res)
    out["system"] = s.system_id
    return out


@mcp.tool()
def system_info(system: str = "") -> dict:
    """접속한 SAP 시스템 정보(SID, 호스트, 릴리스)를 조회한다.
    - system: 특정 시스템 ID (선택, 미입력 시 현재 활성 시스템)
    """
    b, _, _, s = _get_context(system)
    res = b.system_info()
    out = _out(res)
    out["target_system"] = s.system_id
    return out


@mcp.tool()
def search_object(pattern: str, obj_type: str = "", package: str = "", system: str = "") -> dict:
    """객체를 이름 패턴(예: ZMY*), 유형, 패키지로 검색한다."""
    b, _, a, _ = _get_context(system)
    a.log("search_object", pattern=pattern, obj_type=obj_type, package=package)
    return _out(b.search_object(pattern, obj_type, package))


@mcp.tool()
def get_source(obj_type: str, name: str, system: str = "") -> dict:
    """소스를 조회한다. obj_type: PROG, INCL, CLAS, FUNC."""
    b, _, a, _ = _get_context(system)
    a.log("get_source", obj_type=obj_type, name=name)
    return _out(b.get_source(obj_type, name))


@mcp.tool()
def read_source(name: str, obj_type: str = "PROG", system: str = "") -> dict:
    """기존 ABAP 프로그램/Include/함수모듈/클래스의 소스와 메타데이터(작성자, 패키지, 하위 Include 목록, 수정 가능 여부)를 조회·분석한다.
    - name: 조회할 객체 이름 (예: 'ZHRB0014_R', 'ZHR14014', 'SAPMZHR0002')
    - obj_type: 객체 유형 ('PROG', 'INCL', 'FUNC', 'CLAS', 기본값 'PROG'이며 미일치 시 자동 탐색)
    - system: 대상 SAP 시스템 (예: 'GY7', 'EA3', 미입력 시 활성 시스템)
    """
    b, _, a, _ = _get_context(system)
    a.log("read_source", name=name, obj_type=obj_type)
    return _out(b.read_source(name=name, obj_type=obj_type))


@mcp.tool()
def syntax_check(obj_type: str, name: str, source: str, system: str = "") -> dict:
    """소스를 저장하지 않고 문법만 검사한다."""
    b, _, _, _ = _get_context(system)
    return _out(b.syntax_check(obj_type, name, source))


@mcp.tool()
def update_source(obj_type: str, name: str, source: str, transport: str = "",
                  activate: bool = False, system: str = "") -> dict:
    """소스를 수정·저장한다. 변경 전 소스를 자동 백업하며, activate=True 지정 시 저장 후 즉시 활성화한다.
    GY7 서버에서는 작성자(AUTHOR/CNAM)가 SEPPIN 또는 PADO01 인 프로그램만 수정 가능하다.
    """
    b, g, a, s = _get_context(system)
    try:
        g.check_name(name)
        g.check_write(_sysid(s.system_id), transport)
        meta = b.get_object_metadata(obj_type, name)
        if meta.get("author"):
            g.check_author(meta["author"])
        old = b.get_source(obj_type, name)
        path = backup_source(s, obj_type, name, old.data or "") if old.ok else None
        r = b.update_source(obj_type, name, source, transport)
        a.log("update_source", obj_type=obj_type, name=name, transport=transport, ok=r.ok, backup=path)
        out = _out(r)
        out["backup"] = path
        out["author"] = meta.get("author", "")
        out["system"] = s.system_id
        if r.ok and activate:
            act_r = b.activate_object(obj_type, name)
            a.log("activate_object", obj_type=obj_type, name=name, ok=act_r.ok)
            out["activated"] = act_r.ok
            out["activate_message"] = act_r.message
            if act_r.ok:
                out["message"] = f"{r.message} -> {act_r.message}"
        return out
    except GuardError as e:
        return {"ok": False, "message": str(e)}


@mcp.tool()
def activate_object(obj_type: str, name: str, system: str = "") -> dict:
    """객체를 활성화한다. GY7 서버에서는 SEPPIN 또는 PADO01 작성 객체를 활성화할 수 있다."""
    b, g, a, s = _get_context(system)
    try:
        g.check_name(name)
        g.check_write(_sysid(s.system_id), "")
        meta = b.get_object_metadata(obj_type, name)
        if meta.get("author"):
            g.check_author(meta["author"])
        r = b.activate_object(obj_type, name)
        a.log("activate_object", obj_type=obj_type, name=name, ok=r.ok)
        out = _out(r)
        out["author"] = meta.get("author", "")
        out["system"] = s.system_id
        return out
    except GuardError as e:
        return {"ok": False, "message": str(e)}


@mcp.tool()
def create_object(obj_type: str, name: str, package: str, description: str, transport: str, system: str = "") -> dict:
    """새 객체를 만든다. Z/Y 이름, 허용 패키지, 전송 요청이 필수."""
    b, g, a, s = _get_context(system)
    try:
        g.check_name(name)
        g.check_package(package)
        g.check_write(_sysid(s.system_id), transport)
        r = b.create_object(obj_type, name, package, description, transport)
        a.log("create_object", obj_type=obj_type, name=name, package=package, transport=transport, ok=r.ok)
        out = _out(r)
        out["system"] = s.system_id
        return out
    except GuardError as e:
        return {"ok": False, "message": str(e)}


@mcp.tool()
def delete_object(obj_type: str, name: str, transport: str, dry_run: bool = True,
                  confirm_token: str = "", system: str = "") -> dict:
    """객체를 삭제한다. dry_run=True 로 사용처와 토큰을 받은 뒤, 토큰과 함께 dry_run=False 로 재호출."""
    b, g, a, s = _get_context(system)
    try:
        g.check_name(name)
        g.check_write(_sysid(s.system_id), transport)
        if dry_run:
            wu = b.get_where_used(obj_type, name)
            return {"ok": True, "dry_run": True, "where_used": wu.data,
                    "confirm_token": g.issue_delete_token(obj_type, name)}
        g.consume_delete_token(confirm_token, obj_type, name)
        old = b.get_source(obj_type, name)
        path = backup_source(s, obj_type, name, old.data or "") if old.ok else None
        r = b.delete_object(obj_type, name, transport)
        a.log("delete_object", obj_type=obj_type, name=name, transport=transport, ok=r.ok, backup=path)
        out = _out(r)
        out["system"] = s.system_id
        return out
    except GuardError as e:
        return {"ok": False, "message": str(e)}


@mcp.tool()
def get_where_used(obj_type: str, name: str, system: str = "") -> dict:
    """객체의 사용처를 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("get_where_used", obj_type=obj_type, name=name)
    return _out(b.get_where_used(obj_type, name))


@mcp.tool()
def list_transports(user: str = "", system: str = "") -> dict:
    """수정 가능한 전송 요청 목록을 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("list_transports", user=user)
    return _out(b.list_transports(user))


@mcp.tool()
def get_payroll_result(pernr: str, inper: str = "", payty: str = "",
                       bondt: str = "", seqnr: str = "",
                       mask_sensitive: bool = True, system: str = "") -> dict:
    """특정 사원(PERNR)의 한국 급여 결과(RT 테이블 임금유형/금액)를 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("get_payroll_result", pernr=pernr, inper=inper, payty=payty, bondt=bondt, seqnr=seqnr, mask_sensitive=mask_sensitive)
    return _out(b.get_payroll_result(pernr, inper, payty, bondt, seqnr, mask_sensitive=mask_sensitive))


@mcp.tool()
def compare_payroll_periods(pernr: str, inper_a: str, inper_b: str,
                            payty_a: str = "", payty_b: str = "",
                            mask_sensitive: bool = True, system: str = "") -> dict:
    """동일 사원의 두 급여 기간 급여 결과(RT)를 비교하여 신규 발생, 누락, 금액 증감 및 변동률(%)을 분석한다."""
    b, _, a, _ = _get_context(system)
    a.log("compare_payroll_periods", pernr=pernr, inper_a=inper_a, inper_b=inper_b, mask_sensitive=mask_sensitive)
    return _out(b.compare_payroll_periods(pernr, inper_a, inper_b, payty_a, payty_b, mask_sensitive=mask_sensitive))


@mcp.tool()
def get_replication_log(pernr: str = "", ext_id: str = "",
                         trigger_replication: bool = False, config_id: str = "",
                         date_from: str = "", date_to: str = "",
                         msgty: str = "", subobject: str = "",
                         max_rows: int = 100, system: str = "") -> dict:
    """EC-ECP 마스터 데이터 복제 로그(SLG1: Object HRSFEC)를 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("get_replication_log", pernr=pernr, ext_id=ext_id,
          trigger_replication=trigger_replication, config_id=config_id,
          date_from=date_from, date_to=date_to, msgty=msgty,
          subobject=subobject, max_rows=max_rows)
    return _out(b.get_replication_log(pernr, ext_id, trigger_replication, config_id,
                                      date_from, date_to, msgty, subobject, max_rows))


@mcp.tool()
def get_replication_status(pernr: str = "", ext_id: str = "",
                            status_filter: str = "ALL", max_rows: int = 20, system: str = "") -> dict:
    """EC-ECP 사원 복제 상태 테이블(HRSFEC_D_REPSTAT) 및 최근 에러 메시지(HRSFEC_D_REPSMSG)를 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("get_replication_status", pernr=pernr, ext_id=ext_id, status_filter=status_filter, max_rows=max_rows)
    return _out(b.get_replication_status(pernr=pernr, ext_id=ext_id,
                                         status_filter=status_filter, max_rows=max_rows))


@mcp.tool()
def diagnose_message(msg_id: str = "", msg_no: str = "", query: str = "",
                      v1: str = "", v2: str = "", v3: str = "", v4: str = "",
                      lang: str = "3", system: str = "") -> dict:
    """SAP 메시지(에러/경고/안내)를 분석하고 해결 가이드를 제공한다."""
    b, _, a, _ = _get_context(system)
    a.log("diagnose_message", msg_id=msg_id, msg_no=msg_no, query=query)
    return _out(b.diagnose_message(msg_id=msg_id, msg_no=msg_no, query=query,
                                   v1=v1, v2=v2, v3=v3, v4=v4, lang=lang))


@mcp.tool()
def check_function_module(name: str, system: str = "") -> dict:
    """함수 모듈이 SAP 원격 호출(RFC)이 가능한지 사전 검사한다."""
    b, _, a, _ = _get_context(system)
    a.log("check_function_module", name=name)
    return _out(b.check_function_module(name=name))


@mcp.tool()
def get_recent_dumps(date_from: str = "", date_to: str = "",
                     user: str = "", program: str = "",
                     max_rows: int = 20, system: str = "") -> dict:
    """SAP 시스템에 발생한 최근 ABAP 덤프(ST22 런타임 오류) 목록을 실시간 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("get_recent_dumps", date_from=date_from, date_to=date_to, user=user, program=program)
    return _out(b.get_recent_dumps(date_from=date_from, date_to=date_to,
                                   user=user, program=program, max_rows=max_rows))


@mcp.tool()
def read_table(table_name: str, fields: list[str] | None = None,
               where_clause: str = "", max_rows: int = 100, system: str = "") -> dict:
    """SAP 투명 테이블/뷰의 데이터를 원격 조회한다 (BBP_RFC_READ_TABLE 기반).
    - table_name: 조회할 테이블명 (예: 'T001', 'PA0001', 'T77SFEC_PTP_CONF')
    - fields: 조회할 필드 목록
    - where_clause: SQL WHERE 조건
    - max_rows: 최대 조회 건수 (기본 100)
    - system: 대상 SAP 시스템 (선택, 예: 'GY7', 'EA3', 미입력 시 활성 시스템)
    """
    b, _, a, _ = _get_context(system)
    a.log("read_table", table_name=table_name, fields=fields, where_clause=where_clause, max_rows=max_rows)
    return _out(b.read_table(table_name=table_name, fields=fields,
                             where_clause=where_clause, max_rows=max_rows))


@mcp.tool()
def check_infotype_config(infty: str, molga: str = "", system: str = "") -> dict:
    """인사 인포타입(PA)의 화면 버전 매핑(T582V), 대화모듈(T582A), 가변화면(T588M)을 점검한다."""
    b, _, a, _ = _get_context(system)
    a.log("check_infotype_config", infty=infty, molga=molga)
    return _out(b.check_infotype_config(infty=infty, molga=molga))


@mcp.tool()
def run_payroll(pernr: str = "", inper: str = "", test_run: bool = True,
                schema: str = "KR00", abkrs: str = "", system: str = "") -> dict:
    """한국 급여 계산 드라이버(HKRCALC0)를 원격 SUBMIT 실행하고 결과를 조회한다."""
    b, _, a, _ = _get_context(system)
    a.log("run_payroll", pernr=pernr, inper=inper, test_run=test_run, schema=schema, abkrs=abkrs)
    return _out(b.run_payroll(pernr=pernr, inper=inper, test_run=test_run,
                              schema=schema, abkrs=abkrs))


@mcp.tool()
def check_payroll_control_record(abkrs: str = "", pernr: str = "", system: str = "") -> dict:
    """급여 제어 레코드(PA03 / T569V)의 상태를 점검한다."""
    b, _, a, _ = _get_context(system)
    a.log("check_payroll_control_record", abkrs=abkrs, pernr=pernr)
    return _out(b.check_payroll_control_record(abkrs=abkrs, pernr=pernr))


@mcp.tool()
def ec_ping() -> dict:
    """SuccessFactors Employee Central (EC) OData API 접속 상태를 점검한다."""
    _, _, a, _ = _get_context()
    a.log("ec_ping")
    return _out(_default_ec_backend.ping())


@mcp.tool()
def get_ec_employee(user_id: str, mask_sensitive: bool = True) -> dict:
    """SuccessFactors Employee Central(EC) 원천 시스템에서 사원 데이터를 조회한다."""
    _, _, a, _ = _get_context()
    a.log("get_ec_employee", user_id=user_id, mask_sensitive=mask_sensitive)
    return _out(_default_ec_backend.get_employee(user_id=user_id, mask_sensitive=mask_sensitive))


@mcp.tool()
def compare_employee_records(user_id: str, pernr: str, system: str = "") -> dict:
    """SF EC 원천 데이터와 SAP ECP 마스터(PA0001) 간 1:1 일치 여부를 비교한다."""
    b, _, a, _ = _get_context(system)
    a.log("compare_employee_records", user_id=user_id, pernr=pernr)
    return _out(_default_ec_backend.compare_employee_with_ecp(user_id=user_id, pernr=pernr, rfc_backend=b))


@mcp.tool()
def get_audit_log(limit: int = 50, tool_name: str = "") -> dict:
    """MCP 서버의 작업 감사 로그(audit.log)의 최근 호출 내역을 조회한다.
    
    Args:
        limit: 조회할 최대 로그 건수 (기본 50)
        tool_name: 특정 도구명으로 필터링 (예: 'read_table', 'activate_object' 등, 공백 시 전체)
    """
    _, _, a, _ = _get_context()
    logs = a.get_logs(limit=limit, tool_name=tool_name)
    return _out(Result(ok=True, message=f"감사 로그 {len(logs)}건 조회 완료 (경로: {a.path})", data=logs))



if __name__ == "__main__":
    mcp.run()
