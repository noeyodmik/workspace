import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

ABAP_CODE = """REPORT Z_PTP_SETUP_100_EY.

DATA: ls_conf  TYPE t77sfec_ptp_conf,
      ls_cont  TYPE t77sfec_ptp_cont,
      lt_segm  TYPE STANDARD TABLE OF t77sfec_ptp_segm,
      ls_tka02 TYPE tka02.

" 1. T77SFEC_PTP_CONF: 9901_K0 복사하여 100_EY 생성
SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf WHERE config_id = '9901_K0'.
IF sy-subrc = 0.
  ls_conf-config_id = '100_EY'.
  MODIFY t77sfec_ptp_conf FROM ls_conf.
  WRITE: / 'T77SFEC_PTP_CONF 100_EY subrc:', sy-subrc.
ELSE.
  WRITE: / 'Error: 9901_K0 not found in T77SFEC_PTP_CONF'.
ENDIF.

" 2. T77SFEC_PTP_CONT: 텍스트 등록
SELECT SINGLE * FROM t77sfec_ptp_cont INTO ls_cont WHERE config_id = '9901_K0'.
IF sy-subrc = 0.
  ls_cont-config_id = '100_EY'.
  ls_cont-config_text = '100_EY PTP Replication for EYKR'.
  MODIFY t77sfec_ptp_cont FROM ls_cont.
  WRITE: / 'T77SFEC_PTP_CONT 100_EY subrc:', sy-subrc.
ENDIF.

" 3. T77SFEC_PTP_SEGM: 9901_K0 세그먼트 복사
SELECT * FROM t77sfec_ptp_segm INTO TABLE lt_segm WHERE config_id = '9901_K0'.
LOOP AT lt_segm ASSIGNING FIELD-SYMBOL(<fs_segm>).
  <fs_segm>-config_id = '100_EY'.
ENDLOOP.
IF lt_segm IS NOT INITIAL.
  MODIFY t77sfec_ptp_segm FROM TABLE lt_segm.
  WRITE: / 'T77SFEC_PTP_SEGM copied:', lines( lt_segm ), 'subrc:', sy-subrc.
ENDIF.

" 4. TKA02: 회사코드 EYKR에 관리회계영역 Z100 배정
CLEAR ls_tka02.
ls_tka02-mandt = sy-mandt.
ls_tka02-bukrs = 'EYKR'.
ls_tka02-kokrs = 'Z100'.
MODIFY tka02 FROM ls_tka02.
WRITE: / 'TKA02 EYKR -> Z100 subrc:', sy-subrc.

" 5. T001: EYKR의 KOKFI = '2' 로 업데이트
UPDATE t001 SET kokfi = '2' WHERE bukrs = 'EYKR'.
WRITE: / 'T001 EYKR KOKFI = 2 subrc:', sy-subrc.

COMMIT WORK AND WAIT.
WRITE: / 'SUCCESS: All PTP and CO Area setup committed!'.
"""

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    source_lines = [{'LINE': l} for l in ABAP_CODE.splitlines()]

    # RFC_ABAP_INSTALL_AND_RUN 으로 직접 실행
    print("Executing Z_PTP_SETUP_100_EY via RFC_ABAP_INSTALL_AND_RUN...")
    run_res = c.call('RFC_ABAP_INSTALL_AND_RUN',
                     MODE='F',
                     PROGRAM=source_lines)
    print('Run output:')
    for line in run_res.get('WRITES', []):
        print(' ', line.get('LINE'))

if __name__ == "__main__":
    main()
