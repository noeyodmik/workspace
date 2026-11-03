import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  " --- TEST SEO_CLASS_GENERATE_SOURCES ---
  IF iv_ext_id = 'GEN_CLASS_SOURCES'.
    DATA: ls_clskey TYPE seoclskey.
    ls_clskey-clsname = 'ZHR_PY'.
    CALL FUNCTION 'SEO_CLASS_GENERATE_SOURCES'
      EXPORTING
        class = ls_clskey
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc = 0.
      ev_ok = 'X'.
      ev_message = 'SEO_CLASS_GENERATE_SOURCES ok'.
    ELSE.
      ev_ok = ' '.
      ev_message = |SEO_CLASS_GENERATE_SOURCES failed: { sy-subrc }|.
    ENDIF.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='GEN_CLASS_SOURCES')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

# Check CU after this call
r_cu = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CU')
print('--- CU lines now ---')
for l in r_cu.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()

