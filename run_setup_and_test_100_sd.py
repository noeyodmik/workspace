import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Setup 100_SD in PTP tables by copying from 100_EY
SETUP_SD_CODE = """  " --- 100_SD PTP SETUP ---
  IF iv_ext_id = 'SETUP_100_SD'.
    DATA: ls_conf_sd TYPE t77sfec_ptp_conf,
          ls_cont_sd TYPE t77sfec_ptp_cont,
          lt_segm_sd TYPE STANDARD TABLE OF t77sfec_ptp_segm.

    " 1. T77SFEC_PTP_CONF
    SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf_sd WHERE config_id = '100_EY'.
    IF sy-subrc = 0.
      ls_conf_sd-config_id = '100_SD'.
      ls_conf_sd-target_system = 'EA3CLNT100'.
      MODIFY t77sfec_ptp_conf FROM ls_conf_sd.
    ENDIF.

    " 2. T77SFEC_PTP_CONT
    SELECT SINGLE * FROM t77sfec_ptp_cont INTO ls_cont_sd WHERE config_id = '100_EY'.
    IF sy-subrc = 0.
      ls_cont_sd-config_id = '100_SD'.
      ls_cont_sd-config_text = '100_SD PTP Replication (api50.sapsf.com)'.
      MODIFY t77sfec_ptp_cont FROM ls_cont_sd.
    ENDIF.

    " 3. T77SFEC_PTP_SEGM
    SELECT * FROM t77sfec_ptp_segm INTO TABLE lt_segm_sd WHERE config_id = '100_EY'.
    LOOP AT lt_segm_sd ASSIGNING FIELD-SYMBOL(<fs_segm_sd>).
      <fs_segm_sd>-config_id = '100_SD'.
    ENDLOOP.
    IF lt_segm_sd IS NOT INITIAL.
      MODIFY t77sfec_ptp_segm FROM TABLE lt_segm_sd.
    ENDIF.

    COMMIT WORK AND WAIT.
    ev_ok = 'X'.
    ev_message = 'SUCCESS: 100_SD setup completed.'.
    RETURN.
  ENDIF.

  " --- TEST REPLICATION WITH 100_SD ---
  IF iv_ext_id = 'TEST_100_SD'.
    DATA: lo_repl_sd TYPE REF TO if_hrsfec_ptp_ee_replication,
          ls_msg_sd  TYPE symsg,
          lv_ext_sd  TYPE string VALUE '70000019'.

    TRY.
        CREATE OBJECT lo_repl_sd TYPE cl_hrsfec_ptp_ee_replication
          EXPORTING
            iv_confid                = '100_SD'
            iv_ext_id                = lv_ext_sd
            iv_use_config_individual = abap_true.

        lo_repl_sd->execute( IMPORTING es_message = ls_msg_sd ).

        ev_ok = 'X'.
        ev_message = |SUCCESS 100_SD: MSGID={ ls_msg_sd-msgid } NO={ ls_msg_sd-msgno } TY={ ls_msg_sd-msgty } V1={ ls_msg_sd-msgv1 }|.
      CATCH cx_root INTO DATA(lx_sd).
        ev_ok = ' '.
        ev_message = |EXCEPTION: { lx_sd->get_text( ) }|.
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
    diag_lines = SETUP_SD_CODE.splitlines()
    mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + diag_lines + orig_lines[insert_idx:])]

    print("Step 2: Injecting 100_SD setup & test logic into LZMCPU11...")
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    try:
        print("Step 3-1: Setting up 100_SD in PTP tables...")
        r_setup = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='SETUP_100_SD')
        print("  Setup result:", r_setup.get('EV_OK'), r_setup.get('EV_MESSAGE'))

        print("Step 3-2: Triggering PTP Replication with 100_SD for 70000019...")
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_100_SD')
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

