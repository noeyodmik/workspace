import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

WRAPPER = """  IF iv_ext_id = 'CHECK_SYNTAX'.
    DATA: lt_code TYPE string_table,
          lv_msg TYPE string,
          lv_line TYPE i,
          lv_word TYPE string.

    APPEND 'PROGRAM sub.' TO lt_code.
    APPEND 'DATA: lo_enh TYPE REF TO if_enh_tool.' TO lt_code.
    APPEND 'DATA: lo_tool TYPE REF TO cl_enh_tool_badi_impl.' TO lt_code.
    APPEND 'DATA: lt_impls TYPE enh_badi_impl_data_it.' TO lt_code.

    SYNTAX-CHECK FOR lt_code MESSAGE lv_msg LINE lv_line WORD lv_word
      PROGRAM 'SAPLZMCP'.

    ev_ok = 'X'.
    ev_message = |LINE={ lv_line } WORD={ lv_word } MSG={ lv_msg }|.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + WRAPPER.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='CHECK_SYNTAX')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()
