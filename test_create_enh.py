import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id = 'CREATE_BADI_ENH'.
    DATA: lo_enh TYPE REF TO if_enh_tool,
          lo_badi TYPE REF TO cl_enh_tool_badi_impl,
          ls_impl TYPE enh_badi_impl_data,
          ls_flt  TYPE enh_badi_filter_impl.

    TRY.
        lo_enh = cl_enh_factory=>create_enhancement(
          enhancement_name = 'ZHRSFEC_B_CE_CHANGE_IT0008'
          enhtooltype      = 'BADI_IMPL'
          enhtype          = 'RDEF'
          devclass         = 'ZHR_PY'
          trkorr           = 'EA3K900013'
        ).
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

        lo_badi->if_enh_object~save( run_dark = 'X' trkorr = 'EA3K900013' ).
        lo_badi->if_enh_object~activate( run_dark = 'X' trkorr = 'EA3K900013' ).
        lo_badi->if_enh_object~unlock( ).

        ev_ok = 'X'.
        ev_message = 'BAdI enhancement ZHRSFEC_B_CE_CHANGE_IT0008 created and activated!'.
      CATCH cx_root INTO DATA(lx_enh).
        ev_ok = ' '.
        ev_message = lx_enh->get_text( ).
    ENDTRY.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='CREATE_BADI_ENH')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

