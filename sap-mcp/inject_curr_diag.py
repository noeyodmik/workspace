import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("INCL", "LZMCPU12")
    source = r.data
    
    # 1. 유효성 검사 직후에 RP_GET_CURRENCY 진단 코드 삽입
    target = "  IF lv_schema IS INITIAL."
    inject = """  DATA: lv_test_curr TYPE t500c-waers,
        lv_subrc_c   TYPE sy-subrc.
  CALL FUNCTION 'RP_GET_CURRENCY'
    EXPORTING
      molga                         = '41'
    IMPORTING
      waers                         = lv_test_curr
    EXCEPTIONS
      molga_not_in_t001p            = 1
      no_entry_found_in_table_t001  = 2
      no_entry_found_in_table_t500p = 3
      no_entry_found_in_table_t500c = 4
      OTHERS                        = 5.
  lv_subrc_c = sy-subrc.

  IF lv_schema IS INITIAL."""

    new_source = source.replace(target, inject)
    
    # 결과 메시지 앞부분에도 진단 문자열 추가
    res_target = "  ev_ok = abap_true."
    res_inject = "  ev_message = |[CURR_CHK subrc={ lv_subrc_c }, curr={ lv_test_curr }] | && ev_message.\n  ev_ok = abap_true."
    new_source = new_source.replace(res_target, res_inject)
    
    err_target = "    ev_message = |급여 계산 중 오류가 발생했습니다: { lv_err_msg }|."
    err_inject = "    ev_message = |[CURR_CHK subrc={ lv_subrc_c }, curr={ lv_test_curr }] 급여 계산 중 오류가 발생했습니다: { lv_err_msg }|."
    new_source = new_source.replace(err_target, err_inject)
    
    up = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", new_source, "EA3K900019")
    print("Update:", up.ok, up.message)
    if up.ok:
        act = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
        print("Activate:", act.ok, act.message)

if __name__ == "__main__":
    main()
