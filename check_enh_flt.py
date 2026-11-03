import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

WRAPPER = """  IF iv_ext_id = 'READ_ENH_FLT'.
    DATA: lo_enh TYPE REF TO if_enh_tool,
          lo_tool TYPE REF TO cl_enh_tool_badi_impl,
          lt_impls TYPE enh_badi_impl_data_it,
          ls_impl TYPE enh_badi_impl_data,
          ls_flt TYPE enh_badi_filter_impl,
          ls_fval TYPE enh_badiimpl_filter_value,
          lv_out TYPE string.

    TRY.
        lo_enh = cl_enh_factory=>get_enhancement(
          enhancement_id = 'ZHRSFEC_B_CE_CHANGE_IT0002'
        ).
        lo_tool ?= lo_enh.
        lt_impls = lo_tool->get_implementations( ).
        READ TABLE lt_impls INTO ls_impl INDEX 1.
        lv_out = |FILTERS_COUNT={ lines( ls_impl-filters ) } FVAL_COUNT={ lines( ls_impl-filter_values ) } FROOT_COUNT={ lines( ls_impl-filter_root ) } FTREE_COUNT={ lines( ls_impl-filter_tree ) }|.
        LOOP AT ls_impl-filters INTO ls_flt.
          lv_out = |{ lv_out } / FLT: { ls_flt-filter_name } VAL1={ ls_flt-filter_string_value1 }|.
        ENDLOOP.
        LOOP AT ls_impl-filter_values INTO ls_fval.
          lv_out = |{ lv_out } / FVAL: { ls_fval-filter_name } CVAL1={ ls_fval-filter_char_value1 } COMP={ ls_fval-compare } ID={ ls_fval-id }|.
        ENDLOOP.
        ev_ok = 'X'.
        ev_message = lv_out.
      CATCH cx_root INTO DATA(lx).
        ev_ok = ' '.
        ev_message = lx->get_text( ).
    ENDTRY.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + WRAPPER.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='READ_ENH_FLT')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

