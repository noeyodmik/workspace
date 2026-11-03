import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- TEST REPLICATION WITH TARGET_SYSTEM = Y30CLNT110 ---
  IF iv_ext_id = 'TEST_Y30'.
    DATA: ls_conf TYPE t77sfec_ptp_conf,
          lo_repl TYPE REF TO if_hrsfec_ptp_ee_replication,
          ls_msg  TYPE symsg,
          lv_ext  TYPE string VALUE '70000019'.

    SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf WHERE config_id = '100_SD'.
    IF sy-subrc = 0.
      ls_conf-target_system = 'Y30CLNT110'.
      MODIFY t77sfec_ptp_conf FROM ls_conf.
      COMMIT WORK AND WAIT.
    ENDIF.

    TRY.
        CREATE OBJECT lo_repl TYPE cl_hrsfec_ptp_ee_replication
          EXPORTING
            iv_confid                = '100_SD'
            iv_ext_id                = lv_ext
            iv_use_config_individual = abap_true.

        lo_repl->execute( IMPORTING es_message = ls_msg ).

        ev_ok = 'X'.
        ev_message = |SUCCESS Y30: MSGID={ ls_msg-msgid } NO={ ls_msg-msgno } TY={ ls_msg-msgty } V1={ ls_msg-msgv1 }|.
      CATCH cx_root INTO DATA(lx).
        ev_ok = ' '.
        ev_message = |EXCEPTION: { lx->get_text( ) }|.
    ENDTRY.

    " Restore target_system to EA3CLNT100
    SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf WHERE config_id = '100_SD'.
    IF sy-subrc = 0.
      ls_conf-target_system = 'EA3CLNT100'.
      MODIFY t77sfec_ptp_conf FROM ls_conf.
      COMMIT WORK AND WAIT.
    ENDIF.

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
        print("Step 3: Triggering PTP Replication with TARGET_SYSTEM=Y30CLNT110...")
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_Y30')
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

