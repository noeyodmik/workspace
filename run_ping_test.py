import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- TEST PING OR REPLICATION ---
  IF iv_ext_id = 'TEST_PING_NEW'.
    DATA: lo_helper TYPE REF TO lcl_ptp_configuration_helper,
          lt_msg    TYPE tty_output.

    CREATE OBJECT lo_helper.
    lo_helper->perform_soap_ping( ).
    lo_helper->perform_odata_ping( 'DataReplicationProxy' ).
    lt_msg = lo_helper->get_messages( ).

    ev_ok = 'X'.
    ev_message = 'PING FINISHED'.
    LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_m>).
      ev_message = |{ ev_message } / [{ <fs_m>-status }] { <fs_m>-message }|.
    ENDLOOP.
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

    print("Step 2: Injecting PING test into LZMCPU11...")
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    try:
        print("Step 3: Running PING test via ECP_PTP_SOAP_100 / ECP_PTP_ODATA_100...")
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_PING_NEW')
        print("  Ping result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
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

