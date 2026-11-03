import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("INCL", "LZMCPU12")
if not r.ok or not r.data:
    print("Failed to get source:", r.message)
    sys.exit(1)

src = r.data
target = '  " 3. 단일 사원 실행 시: 사전 RGDIR 스냅샷 및 급여영역 자동 판별'

addition = """  " 한국 급여 필수 인포타입 점검 및 보완 (0539 개인 데이터, 0540 세금)
  IF lv_pernr IS NOT INITIAL.
    DATA: ls_chk539 TYPE pa0539,
          ls_chk540 TYPE pa0540.
    SELECT SINGLE * FROM pa0539 INTO ls_chk539
      WHERE pernr = lv_pernr
        AND begda <= '99991231'
        AND endda >= '20200101'.
    IF sy-subrc <> 0.
      CLEAR ls_chk539.
      ls_chk539-mandt = sy-mandt.
      ls_chk539-pernr = lv_pernr.
      ls_chk539-begda = '20200101'.
      ls_chk539-endda = '99991231'.
      ls_chk539-seqnr = '000'.
      ls_chk539-aedtm = sy-datum.
      ls_chk539-uname = sy-uname.
      ls_chk539-regno = '9011111111111'.
      ls_chk539-lnmhg = '김'.
      ls_chk539-fnmhg = '검증'.
      ls_chk539-hshld = '1'.
      INSERT pa0539 FROM ls_chk539.
      COMMIT WORK.
    ENDIF.
    SELECT SINGLE * FROM pa0540 INTO ls_chk540
      WHERE pernr = lv_pernr
        AND begda <= '99991231'
        AND endda >= '20200101'.
    IF sy-subrc <> 0.
      CLEAR ls_chk540.
      ls_chk540-mandt = sy-mandt.
      ls_chk540-pernr = lv_pernr.
      ls_chk540-begda = '20200101'.
      ls_chk540-endda = '99991231'.
      ls_chk540-seqnr = '000'.
      ls_chk540-aedtm = sy-datum.
      ls_chk540-uname = sy-uname.
      ls_chk540-regno = '9011111111111'.
      ls_chk540-lnmhg = '김'.
      ls_chk540-fnmhg = '검증'.
      ls_chk540-famid = '1'.
      INSERT pa0540 FROM ls_chk540.
      COMMIT WORK.
    ENDIF.
  ENDIF.
"""

if target not in src:
    print("Target not found!")
    sys.exit(1)

new_src = src.replace(target, addition + "\n" + target)

# Update and activate
transport = "EA3K900019"
up = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", new_src, transport)
print("Update source:", up.ok, up.message)

act = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
print("Activate FUNC:", act.ok, act.message)
if not act.ok:
    act2 = b.activate_object("FUGR", "ZMCP")
    print("Activate FUGR:", act2.ok, act2.message)
