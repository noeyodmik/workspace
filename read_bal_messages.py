import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id = 'READ_LOG_40066'.
    DATA: lt_lognumbers TYPE bal_t_logn,
          lt_msg        TYPE bal_t_msg,
          ls_msg        TYPE bal_s_msg,
          lv_out        TYPE string.

    APPEND '00000000000000040066' TO lt_lognumbers.

    CALL FUNCTION 'APPL_LOG_READ_DB'
      EXPORTING
        lognumbers = lt_lognumbers
      IMPORTING
        messages   = lt_msg
      EXCEPTIONS
        OTHERS     = 1.

    LOOP AT lt_msg INTO ls_msg.
      DATA lv_txt TYPE string.
      MESSAGE ID ls_msg-msgid TYPE ls_msg-msgty NUMBER ls_msg-msgno
        WITH ls_msg-msgv1 ls_msg-msgv2 ls_msg-msgv3 ls_msg-msgv4
        INTO lv_txt.
      lv_out = |{ lv_out } / [{ ls_msg-msgty }] { lv_txt }|.
    ENDLOOP.

    ev_ok = 'X'.
    ev_message = lv_out.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='READ_LOG_40066')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

