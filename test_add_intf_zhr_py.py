import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  " --- ADD INTERFACE IF_HRSFEC_CE_CHANGE_IT0008 TO ZHR_PY ---
  IF iv_ext_id = 'ADD_INTF_IT0008'.
    DATA: ls_clskey TYPE seoclskey,
          lt_impls  TYPE seor_implementings_w,
          ls_impl   TYPE vseoimplem,
          lv_msg    TYPE string.

    ls_clskey-clsname = 'ZHR_PY'.
    ls_impl-clsname = 'ZHR_PY'.
    ls_impl-refclsname = 'IF_HRSFEC_CE_CHANGE_IT0008'.
    ls_impl-state = '1'.
    APPEND ls_impl TO lt_impls.

    CALL FUNCTION 'SEO_IMPLEMENTG_CREATE'
      EXPORTING
        clskey        = ls_clskey
        implementings = lt_impls
      EXCEPTIONS
        OTHERS        = 1.

    IF sy-subrc = 0.
      ev_ok = 'X'.
      ev_message = 'SEO_IMPLEMENTG_CREATE succeeded'.
    ELSE.
      ev_ok = ' '.
      ev_message = |SEO_IMPLEMENTG_CREATE failed with sy-subrc={ sy-subrc }|.
    ENDIF.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='ADD_INTF_IT0008')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

