import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  " --- TEST SAPGENPSE ---
  IF iv_ext_id = 'TEST_SAPGENPSE'.
    DATA: lv_cmd TYPE string,
          lt_out TYPE TABLE OF char255,
          lv_line TYPE char255.

    lv_cmd = '/usr/sap/EA3/D00/exe/sapgenpse maintain_pk -l -p /usr/sap/EA3/D00/sec/SAPSSL100_SP.pse'.
    CALL 'SYSTEM' ID 'COMMAND' FIELD lv_cmd
                  ID 'TAB'     FIELD lt_out.

    ev_ok = 'X'.
    DATA lv_res TYPE string.
    LOOP AT lt_out INTO lv_line.
      lv_res = |{ lv_res }\n{ lv_line }|.
    ENDLOOP.
    ev_message = lv_res.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

insert_idx = 31
diag_lines = CODE.splitlines()
mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + diag_lines + orig_lines[insert_idx:])]

c.call('RPY_INCLUDE_UPDATE',
       INCLUDE_NAME='LZMCPU11',
       TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ',
       SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_SAPGENPSE')
    print("SAPGENPSE Output:\n", r_test.get('EV_MESSAGE'))
finally:
    orig_source_ext = [{'LINE': l} for l in orig_lines]
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=orig_source_ext)

