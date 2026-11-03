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
    
    # 4. HKRCALC0 SUBMIT 파라미터 구성 부분을 통째로 완벽하게 교체
    start_marker = '  " 4. HKRCALC0 SUBMIT 파라미터 구성'
    end_marker = '  " 5. HKRCALC0 호출'
    
    start_pos = source.find(start_marker)
    end_pos = source.find(end_marker)
    
    if start_pos == -1 or end_pos == -1:
        print("Markers not found!")
        return
        
    new_block = '''  " 4. HKRCALC0 SUBMIT 파라미터 구성 (LDB PNP 및 RPCFDP09 표준 파라미터 명칭)
  CLEAR lt_rsparams.

  " 사번 조건 (SELECT-OPTIONS PNPPERNR)
  IF lv_pernr IS NOT INITIAL.
    APPEND VALUE #( selname = 'PNPPERNR' kind = 'S' sign = 'I' option = 'EQ' low = lv_pernr ) TO lt_rsparams.
  ENDIF.

  " 급여 계산 영역 (LDB PNP의 최상단 필수 파라미터 PNPXABKR 및 필터 PNPABKRS)
  IF lv_abkrs IS NOT INITIAL.
    APPEND VALUE #( selname = 'PNPXABKR' kind = 'P' low = lv_abkrs ) TO lt_rsparams.
    APPEND VALUE #( selname = 'PNPABKRS' kind = 'S' sign = 'I' option = 'EQ' low = lv_abkrs ) TO lt_rsparams.
    APPEND VALUE #( selname = 'P_ABKRS'  kind = 'P' low = lv_abkrs ) TO lt_rsparams.
  ENDIF.

  " 급여 기간 조건 (지정된 경우 PNPTIMRA + 연도/기간, 미지정 시 PNPTIMR9 현재 기간)
  DATA: lv_inper_str TYPE string,
        lv_pabrj     TYPE qppnp-pabrj,
        lv_pabrp     TYPE qppnp-pabrp.
  lv_inper_str = iv_inper.
  IF lv_inper_str IS NOT INITIAL AND strlen( lv_inper_str ) >= 6.
    lv_pabrj = lv_inper_str(4).
    lv_pabrp = lv_inper_str+4(2).
    APPEND VALUE #( selname = 'PNPTIMRA' kind = 'P' low = 'X' ) TO lt_rsparams.
    APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
    APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper_str ) TO lt_rsparams.
  ELSE.
    APPEND VALUE #( selname = 'PNPTIMR9' kind = 'P' low = 'X' ) TO lt_rsparams.
  ENDIF.

  " 스키마 (PARAMETERS SCHEMA)
  APPEND VALUE #( selname = 'SCHEMA'   kind = 'P' low = lv_schema ) TO lt_rsparams.
  APPEND VALUE #( selname = 'CALCSCHM' kind = 'P' low = lv_schema ) TO lt_rsparams.

  " 테스트 실행 플래그 (PARAMETERS TST_ON / TESTRUN)
  IF lv_test = 'X'.
    APPEND VALUE #( selname = 'TST_ON'  kind = 'P' low = 'X' ) TO lt_rsparams.
    APPEND VALUE #( selname = 'TESTRUN' kind = 'P' low = 'X' ) TO lt_rsparams.
    APPEND VALUE #( selname = 'TEST'    kind = 'P' low = 'X' ) TO lt_rsparams.
  ELSE.
    APPEND VALUE #( selname = 'TST_ON'  kind = 'P' low = ' ' ) TO lt_rsparams.
    APPEND VALUE #( selname = 'TESTRUN' kind = 'P' low = ' ' ) TO lt_rsparams.
    APPEND VALUE #( selname = 'TEST'    kind = 'P' low = ' ' ) TO lt_rsparams.
  ENDIF.

  " 로그 출력 플래그 (PARAMETERS PRT_PROT / SHOWLOG)
  APPEND VALUE #( selname = 'PRT_PROT' kind = 'P' low = 'X' ) TO lt_rsparams.
  APPEND VALUE #( selname = 'SHOWLOG'  kind = 'P' low = 'X' ) TO lt_rsparams.

'''

    new_source = source[:start_pos] + new_block + source[end_pos:]
    
    # 업데이트 및 활성화
    up = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", new_source, "EA3K900019")
    print("Update:", up.ok, up.message)
    if up.ok:
        act = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
        print("Activate:", act.ok, act.message)

if __name__ == "__main__":
    main()
