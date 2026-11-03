import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

WRAPPER = """  IF iv_ext_id = 'READ_BADI_FILTERS'.
    DATA: lo_spot TYPE REF TO if_enh_spot_tool,
          lo_badi_spot TYPE REF TO cl_enh_tool_badi_def,
          ls_badi TYPE enh_badi_data,
          ls_flt TYPE enh_badi_filter_def,
          lv_out TYPE string.

    TRY.
        lo_spot = cl_enh_factory=>get_enhancement_spot(
          spot_name = 'HRSFEC_CE_MASTER_DATA_REPL'
        ).
        lo_badi_spot ?= lo_spot.
        ls_badi = lo_badi_spot->get_badi_def( badi_name = 'HRSFEC_B_CE_CHANGE_IT0008' ).
        lv_out = |BADI={ ls_badi-badi_name } INTF={ ls_badi-interface } MULTI={ ls_badi-multiple_use } FLT_COUNT={ lines( ls_badi-filters ) }|.
        LOOP AT ls_badi-filters INTO ls_flt.
          lv_out = |{ lv_out } / FLT: { ls_flt-filter_name } TYPE={ ls_flt-filter_type }|.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='READ_BADI_FILTERS')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

