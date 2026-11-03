import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- DIAGNOSE COMPENSATION DATA FOR 17 and 19 ---
  IF iv_ext_id = 'DIAG_COMP'.
    DATA: lo_repl TYPE REF TO cl_hrsfec_ptp_ee_replication,
          ls_msg  TYPE symsg,
          lt_res  TYPE string_table.

    " We can query via SFAPI directly or check past replication buffer
    SELECT * FROM hrsfec_d_repstat INTO TABLE @DATA(lt_rep)
      WHERE person_id_ext IN ('70000017', '70000019').
    LOOP AT lt_rep INTO DATA(ls_rep).
      APPEND |PERNR={ ls_rep-pernr } EXT={ ls_rep-person_id_ext } STATUS={ ls_rep-status }| TO lt_res.
    ENDLOOP.

    ev_ok = 'X'.
    ev_message = concat_lines_of( table = lt_res sep = ' / ' ).
    RETURN.
  ENDIF.
"""

def main():
    s = Settings("EA3")
    c = Connection(**s.rfc_params())

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
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='DIAG_COMP')
        print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
    finally:
        orig_source_ext = [{'LINE': l} for l in orig_lines]
        c.call('RPY_INCLUDE_UPDATE',
               INCLUDE_NAME='LZMCPU11',
               TRANSPORT_NUMBER='EA3K900019',
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=orig_source_ext)
        print("Restored.")

if __name__ == "__main__":
    main()

