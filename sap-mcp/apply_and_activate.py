import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    
    # 1. 현재 LZMCPU12 소스 읽기
    r = b.get_source("INCL", "LZMCPU12")
    if not r.ok or not r.data:
        print("get_source failed:", r.message)
        return
    
    source = r.data
    
    # 2. 에러가 발생한 라인 교체
    # 기존 코드:
    old_target = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  IF lv_inper IS NOT INITIAL.
    DATA: lv_pabrj TYPE qppnp-pabrj,
          lv_pabrp TYPE qppnp-pabrp.
    IF strlen( lv_inper ) >= 6.
      lv_pabrj = lv_inper+0(4).
      lv_pabrp = lv_inper+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper ) TO lt_rsparams.
  ENDIF."""

    new_replacement = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  DATA: lv_inper_str TYPE string,
        lv_pabrj     TYPE qppnp-pabrj,
        lv_pabrp     TYPE qppnp-pabrp.
  lv_inper_str = iv_inper.
  IF lv_inper_str IS NOT INITIAL.
    IF strlen( lv_inper_str ) >= 6.
      lv_pabrj = lv_inper_str(4).
      lv_pabrp = lv_inper_str+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper_str ) TO lt_rsparams.
  ENDIF."""

    if old_target not in source:
        print("Target block not found in current source! Checking partial match...")
        # 부분 확인
        for line in source.split("\n"):
            if "lv_inper+0(4)" in line or "strlen( lv_inper )" in line:
                print("Found matching line:", line)
        return

    new_source = source.replace(old_target, new_replacement)
    
    # 3. 소스 업데이트 전송 (FUNC 타입으로 전송)
    transport = "EA3K900019"
    up_res = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", new_source, transport)
    print(f"update_source result: ok={up_res.ok}, msg={up_res.message}")
    
    if not up_res.ok:
        return
        
    # 4. 활성화 실행
    act_res = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
    print(f"activate_object FUNC: ok={act_res.ok}, msg={act_res.message}")
    
    if not act_res.ok:
        act_res2 = b.activate_object("FUGR", "ZMCP")
        print(f"activate_object FUGR ZMCP: ok={act_res2.ok}, msg={act_res2.message}")

if __name__ == "__main__":
    main()
