import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  " --- TEST SEO_METHOD_GENERATE_INCLUDE ---
  IF iv_ext_id = 'GEN_METHOD_INC'.
    DATA: ls_mtdkey TYPE seocpdkey.
    ls_mtdkey-clsname = 'ZHR_PY'.
    ls_mtdkey-cpdname = 'IF_HRSFEC_CE_CHANGE_IT0008~CHANGE_INFO_TYPE_DATA'.

    CALL FUNCTION 'SEO_METHOD_GENERATE_INCLUDE'
      EXPORTING
        mtdkey        = ls_mtdkey
        suppress_corr = 'X'
        force         = 'X'
      EXCEPTIONS
        OTHERS        = 1.

    IF sy-subrc = 0.
      ev_ok = 'X'.
      ev_message = 'SEO_METHOD_GENERATE_INCLUDE ok'.
    ELSE.
      ev_ok = ' '.
      ev_message = |SEO_METHOD_GENERATE_INCLUDE failed: { sy-subrc }|.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='GEN_METHOD_INC')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

