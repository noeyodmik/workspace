import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

WRAPPER = """  IF iv_ext_id = 'CHECK_SYNTAX_BADI'.
    DATA: lv_msg1 TYPE string, lv_line1 TYPE i, lv_word1 TYPE string,
          lv_msg2 TYPE string, lv_line2 TYPE i, lv_word2 TYPE string.

    SYNTAX-CHECK FOR PROGRAM 'HRSFEC_B_CE_CHANGE_IT0002=====CP'
      MESSAGE lv_msg1 LINE lv_line1 WORD lv_word1.

    SYNTAX-CHECK FOR PROGRAM 'ZHR_PY========================CP'
      MESSAGE lv_msg2 LINE lv_line2 WORD lv_word2.

    ev_ok = 'X'.
    ev_message = |IT0002: L={ lv_line1 } W={ lv_word1 } MSG={ lv_msg1 } /// ZHR_PY: L={ lv_line2 } W={ lv_word2 } MSG={ lv_msg2 }|.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + WRAPPER.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='CHECK_SYNTAX_BADI')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines, f"lines={len(back)}")

c.close()

