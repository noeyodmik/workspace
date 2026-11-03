import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

SETUP_CODE = """  " --- 100_EY PTP 및 CO 배정 원클릭 셋업 트리거 ---
  IF iv_ext_id = 'SETUP_100_EY'.
    DATA: ls_conf  TYPE t77sfec_ptp_conf,
          ls_cont  TYPE t77sfec_ptp_cont,
          lt_segm  TYPE STANDARD TABLE OF t77sfec_ptp_segm,
          ls_tka02 TYPE tka02.

    " 1. T77SFEC_PTP_CONF 복사
    SELECT SINGLE * FROM t77sfec_ptp_conf INTO ls_conf WHERE config_id = '9901_K0'.
    IF sy-subrc = 0.
      ls_conf-config_id = '100_EY'.
      MODIFY t77sfec_ptp_conf FROM ls_conf.
    ENDIF.

    " 2. T77SFEC_PTP_CONT 등록
    SELECT SINGLE * FROM t77sfec_ptp_cont INTO ls_cont WHERE config_id = '9901_K0'.
    IF sy-subrc = 0.
      ls_cont-config_id = '100_EY'.
      ls_cont-config_text = '100_EY PTP Replication for EYKR'.
      MODIFY t77sfec_ptp_cont FROM ls_cont.
    ENDIF.

    " 3. T77SFEC_PTP_SEGM 세그먼트 복사
    SELECT * FROM t77sfec_ptp_segm INTO TABLE lt_segm WHERE config_id = '9901_K0'.
    LOOP AT lt_segm ASSIGNING FIELD-SYMBOL(<fs_segm>).
      <fs_segm>-config_id = '100_EY'.
    ENDLOOP.
    IF lt_segm IS NOT INITIAL.
      MODIFY t77sfec_ptp_segm FROM TABLE lt_segm.
    ENDIF.

    " 4. TKA02: EYKR -> Z100 배정
    CLEAR ls_tka02.
    ls_tka02-mandt = sy-mandt.
    ls_tka02-bukrs = 'EYKR'.
    ls_tka02-kokrs = 'Z100'.
    MODIFY tka02 FROM ls_tka02.

    " 5. T001: KOKFI = 2
    UPDATE t001 SET kokfi = '2' WHERE bukrs = 'EYKR'.

    COMMIT WORK AND WAIT.

    ev_ok = 'X'.
    ev_message = 'SUCCESS: 100_EY segments registered and Z100 assigned to EYKR!'.
    RETURN.
  ENDIF.
"""

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    print("Step 1: Reading current LZMCPU11...")
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    orig_source = "\n".join(orig_lines)
    print(f"Read {len(orig_lines)} lines.")
    for idx, l in enumerate(orig_lines[:35]):
        print(f"{idx}: {repr(l)}")

    insert_idx = 30
    print(f"Found insert index at line {insert_idx}")
    setup_lines = SETUP_CODE.splitlines()
    mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + setup_lines + orig_lines[insert_idx:])]

    print("Step 2: Injecting setup logic into LZMCPU11 via RPY_INCLUDE_UPDATE...")
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)
    print("RPY_INCLUDE_UPDATE OK.")

    # 활성화
    print("Step 3: Activating...")
    try:
        act = c.call('Z_MCP_ACTIVATE', IV_TYPE='FUNC', IV_NAME='Z_MCP_GET_REPLICATION_LOG')
        print("Activate FUNC Z_MCP_GET_REPLICATION_LOG:", act.get('EV_OK'), act.get('EV_MESSAGE'))
    except Exception as e:
        print("Activate notice:", e)

    # 실행!
    print("Step 4: Executing SETUP_100_EY...")
    r_call = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='SETUP_100_EY')
    print("Execution result:", r_call.get('EV_OK'), r_call.get('EV_MESSAGE'))

    # 원복
    print("Step 5: Restoring original LZMCPU11...")
    orig_source_ext = [{'LINE': l} for l in orig_lines]
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=orig_source_ext)
    try:
        act = c.call('Z_MCP_ACTIVATE', IV_TYPE='FUNC', IV_NAME='Z_MCP_GET_REPLICATION_LOG')
        print("Restore activate:", act.get('EV_OK'), act.get('EV_MESSAGE'))
    except Exception as e:
        print("Restore notice:", e)

    print("Step 6: Verifying DB records...")
    # T77SFEC_PTP_CONF
    r_conf = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF',
                    OPTIONS=[{'TEXT': "CONFIG_ID = '100_EY'"}],
                    FIELDS=[{'FIELDNAME': 'CONFIG_ID'}])
    print("T77SFEC_PTP_CONF 100_EY:", len(r_conf.get('DATA', [])))

    # T77SFEC_PTP_SEGM
    r_segm = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_SEGM',
                    OPTIONS=[{'TEXT': "CONFIG_ID = '100_EY'"}],
                    FIELDS=[{'FIELDNAME': 'CONFIG_ID'}, {'FIELDNAME': 'SEGMENT_ID'}])
    segm_rows = [x['WA'].strip() for x in r_segm.get('DATA', [])]
    print(f"T77SFEC_PTP_SEGM 100_EY count: {len(segm_rows)}")
    for s_name in segm_rows:
        print("  -", s_name)

    # TKA02
    r_tka = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TKA02',
                   OPTIONS=[{'TEXT': "BUKRS = 'EYKR'"}],
                   FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'KOKRS'}])
    print("TKA02 EYKR:", [x['WA'].strip() for x in r_tka.get('DATA', [])])

    # T001
    r_t001 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T001',
                    OPTIONS=[{'TEXT': "BUKRS = 'EYKR'"}],
                    FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'BUTXT'}, {'FIELDNAME': 'KOKFI'}])
    print("T001 EYKR:", [x['WA'].strip() for x in r_t001.get('DATA', [])])

if __name__ == "__main__":
    main()
