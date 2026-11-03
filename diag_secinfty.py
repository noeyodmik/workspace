import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 원본 리포트 변경 없이 RFC_ABAP_INSTALL_AND_RUN 으로 임시 리포트 실행 (읽기 전용 진단)
code = """REPORT ZTMP_DIAG_SEC.
DATA: lv_sec TYPE infty,
      lv_viekn TYPE viekn,
      lx TYPE REF TO cx_root.
TRY.
    lv_viekn = cl_hrpa_viekn=>viekn( tclas = 'A' pernr = '00000064' ).
    WRITE: / 'VIEKN(00000064):', lv_viekn.
  CATCH cx_root INTO lx.
    WRITE: / 'VIEKN EX:', lx->get_text( ).
ENDTRY.
TRY.
    lv_sec = cl_hrpa_infotype_container=>secondary_infty(
      tclas = 'A' pernr = '00000064' primary_infty = '0002' itbld = '' ).
    WRITE: / 'SECONDARY_INFTY(0002):', lv_sec.
  CATCH cx_root INTO lx.
    WRITE: / 'SEC EX:', lx->get_text( ).
ENDTRY.
"""

try:
    r = c.call('RFC_ABAP_INSTALL_AND_RUN', PROGRAM=[{'LINE': l} for l in code.splitlines()])
    for w in r.get('WRITES', []):
        print(w.get('ZEILE', w))
    for e in r.get('ERRORMESSAGE', []) if isinstance(r.get('ERRORMESSAGE'), list) else [r.get('ERRORMESSAGE')]:
        if e:
            print("ERR:", e)
except Exception as e:
    print("EXC:", e)

c.close()

