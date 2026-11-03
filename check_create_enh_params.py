import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id = 'GET_CREATE_ENH_PARAMS'.
    DATA: lo_obj TYPE REF TO cl_abap_objectdescr,
          ls_m TYPE abap_methdescr,
          ls_p TYPE abap_parmdescr,
          lv_out TYPE string.

    lo_obj ?= cl_abap_typedescr=>describe_by_name( 'CL_ENH_FACTORY' ).
    READ TABLE lo_obj->methods INTO ls_m WITH KEY name = 'CREATE_ENHANCEMENT'.
    LOOP AT ls_m-parameters INTO ls_p.
      lv_out = |{ lv_out } / { ls_p-name } { ls_p-parm_kind }|.
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
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='GET_CREATE_ENH_PARAMS')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

