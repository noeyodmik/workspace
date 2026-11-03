import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id = 'FIND_FLT_BADI'.
    DATA: lt_enh TYPE TABLE OF enhheader-enhname,
          lv_enh TYPE enhheader-enhname,
          lo_enh TYPE REF TO if_enh_tool,
          lo_tool TYPE REF TO cl_enh_tool_badi_impl,
          lt_impls TYPE enh_badi_impl_data_it,
          ls_impl TYPE enh_badi_impl_data,
          lv_out TYPE string.

    SELECT enhname FROM enhheader INTO TABLE lt_enh UP TO 50 ROWS
      WHERE enhtooltype = 'BADI_IMPL'.

    LOOP AT lt_enh INTO lv_enh.
      TRY.
          lo_enh = cl_enh_factory=>get_enhancement( enhancement_id = lv_enh ).
          lo_tool ?= lo_enh.
          lt_impls = lo_tool->get_implementations( ).
          LOOP AT lt_impls INTO ls_impl.
            IF ls_impl-filter_values IS NOT INITIAL.
              lv_out = |ENH={ lv_enh } BADI={ ls_impl-badi_name } FLT_COUNT={ lines( ls_impl-filter_values ) }|.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF lv_out IS NOT INITIAL.
            EXIT.
          ENDIF.
        CATCH cx_root.
      ENDTRY.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='FIND_FLT_BADI')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

