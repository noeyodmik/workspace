import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

TARGET_CODE = """PROGRAM subpool.
DATA: lo_badi_call TYPE REF TO if_hrsfec_badi_call,
      lt_comp_info TYPE pad_sfec_ce_compensation_tab,
      ls_comp_info TYPE pad_sfec_ce_compensation_info,
      ls_recurr    TYPE pad_sfec_ce_paycomp_recurring,
      lt_p0008     TYPE p0008_tab,
      ls_p0008     TYPE p0008,
      lt_prelp_sec TYPE prelp_tab,
      lv_prelp_sec TYPE infty,
      lt_map_msg   TYPE if_hrsfec_mapping_message=>gty_t_mapping_message.

ls_recurr-paycompvalue = '5000000'.
ls_recurr-currency_code = 'KRW'.
APPEND ls_recurr TO ls_comp_info-paycompensation_recurring.
APPEND ls_comp_info TO lt_comp_info.

lo_badi_call = cl_hrsfec_badi_call=>get_instance( ).

lo_badi_call->hrsfec_b_ce_change_it0008(
  EXPORTING
    iv_country_grouping            = '41'
    iv_personnel_number            = '70000017'
    it_compensation_information    = lt_comp_info
    iv_full_transmission_start_dat = '20260101'
    it_map_messages                = lt_map_msg
  CHANGING
    ct_infty_0008                  = lt_p0008
    ct_prelp_secondary             = lt_prelp_sec
    cv_infty_prelp_secondary       = lv_prelp_sec
).
"""

def esc(s):
    return s.replace("'", "''")

lines_abap = "\n".join([f"    APPEND '{esc(l)}' TO lt_check_src." for l in TARGET_CODE.splitlines()])

CHECK_SNIPPET = """  IF iv_ext_id = 'CHECK_SYNTAX_CALL'.
    DATA: lt_check_src TYPE TABLE OF string,
          lv_syntax_msg TYPE string,
          lv_syntax_line TYPE i,
          lv_syntax_word TYPE string.

""" + lines_abap + """

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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='CHECK_SYNTAX_CALL')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

