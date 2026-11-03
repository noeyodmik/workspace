import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

WRAPPER = """  IF iv_ext_id = 'LIST_ALL_BADIS'.
    DATA: lo_spot TYPE REF TO if_enh_spot_tool,
          lo_badi_spot TYPE REF TO cl_enh_tool_badi_def,
          lt_badis TYPE enh_badi_data_it,
          ls_badi TYPE enh_badi_data,
          lv_out TYPE string.

    TRY.
        lo_spot = cl_enh_factory=>get_enhancement_spot(
          spot_name = 'HRSFEC_CE_MASTER_DATA_REPL'
        ).
        lo_badi_spot ?= lo_spot.
        lt_badis = lo_badi_spot->get_badi_defs( ).
        LOOP AT lt_badis INTO ls_badi.
          lv_out = |{ lv_out } / { ls_badi-badi_name } ({ ls_badi-interface })|.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='LIST_ALL_BADIS')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

