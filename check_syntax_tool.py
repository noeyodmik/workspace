import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CHECK_SNIPPET = """  IF iv_ext_id = 'CHECK_SYNTAX'.
    DATA: lt_check_src TYPE TABLE OF string,
          lv_syntax_msg TYPE string,
          lv_syntax_line TYPE i,
          lv_syntax_word TYPE string.

    APPEND 'PROGRAM subpool.' TO lt_check_src.
    APPEND 'DATA: lo_enh TYPE REF TO if_enh_tool,' TO lt_check_src.
    APPEND '      lo_badi TYPE REF TO cl_enh_tool_badi_impl,' TO lt_check_src.
    APPEND '      ls_impl TYPE enh_badi_impl_data,' TO lt_check_src.
    APPEND '      ls_flt  TYPE enh_badi_filter_impl.' TO lt_check_src.
    APPEND 'SYNTAX-CHECK FOR lt_check_src MESSAGE lv_syntax_msg LINE lv_syntax_line WORD lv_syntax_word.' TO lt_check_src.

    SYNTAX-CHECK FOR lt_check_src MESSAGE lv_syntax_msg LINE lv_syntax_line WORD lv_syntax_word.
    IF sy-subrc = 0.
      ev_ok = 'X'.
      ev_message = 'Syntax OK'.
    ELSE.
      ev_ok = ' '.
      ev_message = |Line { lv_syntax_line }: { lv_syntax_msg } (word: { lv_syntax_word })|.
    ENDIF.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CHECK_SNIPPET.splitlines() + orig_lines[31:])]
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

