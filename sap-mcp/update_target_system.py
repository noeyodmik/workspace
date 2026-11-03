import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

UPDATE_CODE = """  " --- 100_EY TARGET_SYSTEM = 'EA3CLNT100' 업데이트 ---
  IF iv_ext_id = 'SET_TARGET_EA3'.
    UPDATE t77sfec_ptp_conf SET target_system = 'EA3CLNT100' WHERE config_id = '100_EY'.
    COMMIT WORK AND WAIT.
    ev_ok = 'X'.
    ev_message = 'SUCCESS: 100_EY TARGET_SYSTEM updated to EA3CLNT100'.
    RETURN.
  ENDIF.
"""

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    print("Step 1: Reading current LZMCPU11...")
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

    insert_idx = 30
    setup_lines = UPDATE_CODE.splitlines()
    mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + setup_lines + orig_lines[insert_idx:])]

    print("Step 2: Injecting update logic into LZMCPU11...")
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    print("Step 3: Executing SET_TARGET_EA3...")
    r_call = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='SET_TARGET_EA3')
    print("Execution result:", r_call.get('EV_OK'), r_call.get('EV_MESSAGE'))

    print("Step 4: Restoring original LZMCPU11...")
    orig_source_ext = [{'LINE': l} for l in orig_lines]
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=orig_source_ext)
    print("Restore completed.")

    print("Step 5: Verifying T77SFEC_PTP_CONF 100_EY...")
    r_conf = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF',
                    OPTIONS=[{'TEXT': "CONFIG_ID = '100_EY'"}],
                    FIELDS=[{'FIELDNAME': 'CONFIG_ID'}, {'FIELDNAME': 'TARGET_SYSTEM'}])
    for r in r_conf.get('DATA', []):
        print(" ", r.get('WA'))

if __name__ == "__main__":
    main()
