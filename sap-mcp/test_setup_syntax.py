import io
import sys
from config import Settings
from backends.rfc_backend import RfcBackend

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
b = RfcBackend(Settings())

# lzmcpu11_full.txt 읽기
with open("lzmcpu11_full.txt", "r", encoding="utf-8") as f:
    orig_src = f.read()

setup_logic = """  " --- 100_EY PTP 및 CO 배정 원클릭 셋업 트리거 ---
  IF iv_ext_id = 'SETUP_100_EY'.
    DATA: ls_conf  TYPE t77sfec_ptp_conf,
          ls_cont  TYPE t77sfec_ptp_cont,
          lt_segm  TYPE STANDARD TABLE OF t77sfec_ptp_segm,
          ls_tka02 TYPE tka02.

    " 1. T77SFEC_PTP_CONF 복사
    SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf WHERE config_id = '9901_K0'.
    IF sy-subrc = 0.
      ls_conf-config_id = '100_EY'.
      MODIFY t77sfec_ptp_conf FROM ls_conf.
    ENDIF.

    " 2. T77SFEC_PTP_CONT 등록
    SELECT SINGLE * FROM t77sfec_ptp_cont INTO ls_cont WHERE config_id = '9901_K0'.
    IF sy-subrc = 0.
      ls_cont-config_id = '100_EY'.
      ls_cont-config_text = '100_EY PTP Replication for EYKR'.
      MODIFY t77sfec_ptp_cont FROM ls_cont.
    ENDIF.

    " 3. T77SFEC_PTP_SEGM 세그먼트 복사
    SELECT * FROM t77sfec_ptp_segm INTO TABLE lt_segm WHERE config_id = '9901_K0'.
    LOOP AT lt_segm ASSIGNING FIELD-SYMBOL(<fs_segm>).
      <fs_segm>-config_id = '100_EY'.
    ENDLOOP.
    IF lt_segm IS NOT INITIAL.
      MODIFY t77sfec_ptp_segm FROM TABLE lt_segm.
    ENDIF.

    " 4. TKA02: EYKR -> Z100 배정
    CLEAR ls_tka02.
    ls_tka02-mandt = sy-mandt.
    ls_tka02-bukrs = 'EYKR'.
    ls_tka02-kokrs = 'Z100'.
    MODIFY tka02 FROM ls_tka02.

    " 5. T001: KOKFI = 2
    UPDATE t001 SET kokfi = '2' WHERE bukrs = 'EYKR'.

    COMMIT WORK AND WAIT.

    ev_ok = 'X'.
    ev_message = |100_EY PTP segments ({ lines( lt_segm ) }건) 및 Z100 배정 완료|.
    RETURN.
  ENDIF.
"""

target = "  \" 1. 대상 사원의 EC 외부 식별자 결정"
if target not in orig_src:
    print("Target anchor not found!")
    sys.exit(1)

new_src = orig_src.replace(target, setup_logic + "\n" + target)

# 문법 검사
chk = b.syntax_check("INCL", "LZMCPU11", new_src)
print("Syntax check:", chk.ok, chk.message)
