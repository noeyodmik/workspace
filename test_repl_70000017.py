import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- TEST REPLICATION WITH 70000017 ---
  IF iv_ext_id = 'TEST_17_DEFAULT'.
    DATA: lo_repl_17 TYPE REF TO if_hrsfec_ptp_ee_replication,
          ls_msg_17  TYPE symsg,
          lv_ext_17  TYPE string VALUE '70000017'.

    TRY.
        CREATE OBJECT lo_repl_17 TYPE cl_hrsfec_ptp_ee_replication
          EXPORTING
            iv_confid                = 'DEFAULT'
            iv_ext_id                = lv_ext_17
            iv_use_config_individual = abap_true.

        lo_repl_17->execute( IMPORTING es_message = ls_msg_17 ).

        ev_ok = 'X'.
        ev_message = |SUCCESS DEFAULT: MSGID={ ls_msg_17-msgid } NO={ ls_msg_17-msgno } TY={ ls_msg_17-msgty } V1={ ls_msg_17-msgv1 }|.
      CATCH cx_root INTO DATA(lx_17).
        ev_ok = ' '.
        ev_message = |EXCEPTION: { lx_17->get_text( ) }|.
    ENDTRY.
    RETURN.
  ENDIF.
"""

def main():
    s = Settings("EA3")
    c = Connection(**s.rfc_params())

    print("Step 1: Reading current LZMCPU11...")
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

    insert_idx = 31
    diag_lines = CODE.splitlines()
    mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + diag_lines + orig_lines[insert_idx:])]

    print("Step 2: Injecting test logic into LZMCPU11...")
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    try:
        print("Step 3: Triggering PTP Replication with DEFAULT for 70000017...")
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_17_DEFAULT')
        print("  Replication result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
    finally:
        print("Step 4: Restoring original LZMCPU11...")
        orig_source_ext = [{'LINE': l} for l in orig_lines]
        c.call('RPY_INCLUDE_UPDATE',
               INCLUDE_NAME='LZMCPU11',
               TRANSPORT_NUMBER='EA3K900019',
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=orig_source_ext)
        print("Restore completed.")

if __name__ == "__main__":
    main()

