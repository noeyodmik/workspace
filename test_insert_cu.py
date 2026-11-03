import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  " --- TEST INSERT REPORT CU ---
  IF iv_ext_id = 'UPDATE_CU_REPORT'.
    DATA: lt_source TYPE TABLE OF string.
    APPEND 'CLASS ZHR_PY DEFINITION' TO lt_source.
    APPEND '  PUBLIC' TO lt_source.
    APPEND '  FINAL' TO lt_source.
    APPEND '  CREATE PUBLIC .' TO lt_source.
    APPEND '' TO lt_source.
    APPEND 'PUBLIC SECTION.' TO lt_source.
    APPEND '' TO lt_source.
    APPEND '  INTERFACES IF_BADI_INTERFACE .' TO lt_source.
    APPEND '  INTERFACES IF_HRSFEC_CE_CHANGE_IT0002 .' TO lt_source.
    APPEND '  INTERFACES IF_HRSFEC_CE_CHANGE_IT0105_EMA .' TO lt_source.
    APPEND '  INTERFACES IF_HRSFEC_CE_CHANGE_IT0008 .' TO lt_source.

    INSERT REPORT 'ZHR_PY========================CU' FROM lt_source.
    IF sy-subrc = 0.
      ev_ok = 'X'.
      ev_message = 'INSERT REPORT CU ok'.
    ELSE.
      ev_ok = ' '.
      ev_message = |INSERT REPORT CU failed: { sy-subrc }|.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='UPDATE_CU_REPORT')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

r_cu = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CU')
print('--- CU lines now ---')
for l in r_cu.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()

