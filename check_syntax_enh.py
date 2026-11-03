import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

TARGET_CODE = """PROGRAM subpool.
DATA: lo_enh TYPE REF TO if_enh_tool,
      lo_badi TYPE REF TO cl_enh_tool_badi_impl,
      ls_impl TYPE enh_badi_impl_data,
      ls_flt  TYPE enh_badi_filter_impl,
      lv_devclass TYPE devclass VALUE 'ZHR_PY',
      lv_trkorr   TYPE trkorr   VALUE 'EA3K900013'.

CALL METHOD cl_enh_factory=>create_enhancement
  EXPORTING
    enhname     = 'ZHRSFEC_B_CE_CHANGE_IT0008'
    enhtype     = 'RDEF'
    enhtooltype = 'BADI_IMPL'
    dark        = 'X'
  IMPORTING
    enhancement = lo_enh
  CHANGING
    devclass    = lv_devclass
    trkorr      = lv_trkorr.

lo_badi ?= lo_enh.
lo_badi->set_spot_name( 'HRSFEC_CE_MASTER_DATA_REPL' ).

ls_impl-spot_name  = 'HRSFEC_CE_MASTER_DATA_REPL'.
ls_impl-badi_name  = 'HRSFEC_B_CE_CHANGE_IT0008'.
ls_impl-impl_name  = 'ZHRSFEC_B_CE_CHANGE_IT0008'.
ls_impl-impl_class = 'ZHR_PY'.
ls_impl-active     = 'X'.

ls_flt-filter_name          = 'COUNTRY_GROUPING'.
ls_flt-filter_string_value1 = '41'.
ls_flt-filter_type          = 'C'.
APPEND ls_flt TO ls_impl-filters.

lo_badi->add_implementation( ls_impl ).

lo_badi->if_enh_object~save(
  EXPORTING run_dark = 'X'
  CHANGING  trkorr   = lv_trkorr ).

lo_badi->if_enh_object~activate(
  EXPORTING run_dark = 'X'
  CHANGING  trkorr   = lv_trkorr ).

lo_badi->if_enh_object~unlock( ).
"""

def esc(s):
    return s.replace("'", "''")

lines_abap = "\n".join([f"    APPEND '{esc(l)}' TO lt_check_src." for l in TARGET_CODE.splitlines()])

CHECK_SNIPPET = """  IF iv_ext_id = 'CHECK_SYNTAX_ENH'.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='CHECK_SYNTAX_ENH')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()
