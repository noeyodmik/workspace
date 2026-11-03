import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- ADD T77SFEC_CVMAPC: PAYMENT_METHOD / PAY_COMPONENT / ADDRESS_TYPE ---
  IF iv_ext_id = 'ADD_CVMAPC_3_MAPPINGS'.
    DATA: lt_rows  TYPE STANDARD TABLE OF t77sfec_cvmapc,
          ls_map   TYPE t77sfec_cvmapc,
          lt_e071  TYPE STANDARD TABLE OF e071,
          ls_e071  TYPE e071,
          lt_e071k TYPE STANDARD TABLE OF e071k,
          ls_e071k TYPE e071k,
          lv_tot   TYPE i,
          lv_erpl  TYPE i,
          lv_keyl  TYPE i.

    DESCRIBE FIELD ls_map LENGTH lv_tot IN CHARACTER MODE.
    DESCRIBE FIELD ls_map-erp_code_value LENGTH lv_erpl IN CHARACTER MODE.
    lv_keyl = lv_tot - lv_erpl.

    " 1. PAYMENT_METHOD: 05 -> blank (' ')
    CLEAR ls_map.
    ls_map-mandt = sy-mandt. ls_map-ec_data_type = 'PAYMENT_METHOD'.
    ls_map-country_iso = ' '. ls_map-ec_code_value = '05'. ls_map-erp_code_value = ' '.
    APPEND ls_map TO lt_rows.
    ls_map-country_iso = 'KR'.
    APPEND ls_map TO lt_rows.

    " 2. PAY_COMPONENT: SEPPIN_BASESALARY -> 1010
    CLEAR ls_map.
    ls_map-mandt = sy-mandt. ls_map-ec_data_type = 'PAY_COMPONENT'.
    ls_map-country_iso = ' '. ls_map-ec_code_value = 'SEPPIN_BASESALARY'. ls_map-erp_code_value = '1010'.
    APPEND ls_map TO lt_rows.
    ls_map-country_iso = 'KR'.
    APPEND ls_map TO lt_rows.

    " 3. ADDRESS_TYPE: HOME -> 3
    CLEAR ls_map.
    ls_map-mandt = sy-mandt. ls_map-ec_data_type = 'ADDRESS_TYPE'.
    ls_map-country_iso = ' '. ls_map-ec_code_value = 'HOME'. ls_map-erp_code_value = '3'.
    APPEND ls_map TO lt_rows.
    ls_map-country_iso = 'KR'.
    APPEND ls_map TO lt_rows.

    CLEAR ls_e071.
    ls_e071-pgmid    = 'R3TR'.
    ls_e071-object   = 'TABU'.
    ls_e071-obj_name = 'T77SFEC_CVMAPC'.
    ls_e071-objfunc  = 'K'.
    APPEND ls_e071 TO lt_e071.

    LOOP AT lt_rows INTO ls_map.
      CLEAR ls_e071k.
      ls_e071k-pgmid      = 'R3TR'.
      ls_e071k-object     = 'TABU'.
      ls_e071k-objname    = 'T77SFEC_CVMAPC'.
      ls_e071k-mastertype = 'TABU'.
      ls_e071k-mastername = 'T77SFEC_CVMAPC'.
      ls_e071k-tabkey     = ls_map(lv_keyl).
      APPEND ls_e071k TO lt_e071k.
    ENDLOOP.

    CALL FUNCTION 'TR_APPEND_TO_COMM_OBJS_KEYS'
      EXPORTING
        wi_simulation         = ' '
        wi_suppress_key_check = 'X'
        wi_trkorr             = 'EA3K900020'
      TABLES
        wt_e071               = lt_e071
        wt_e071k              = lt_e071k
      EXCEPTIONS
        OTHERS                = 1.
    IF sy-subrc <> 0.
      ev_ok = ' '.
      ev_message = |TR APPEND FAILED rc={ sy-subrc }|.
      RETURN.
    ENDIF.

    MODIFY t77sfec_cvmapc FROM TABLE lt_rows.
    IF sy-subrc <> 0.
      ROLLBACK WORK.
      ev_ok = ' '.
      ev_message = |MODIFY FAILED rc={ sy-subrc }|.
      RETURN.
    ENDIF.
    COMMIT WORK.
    ev_ok = 'X'.
    ev_message = |MODIFIED { lines( lt_rows ) } rows into T77SFEC_CVMAPC (EA3K900020)|.
    RETURN.
  ENDIF.
"""


def main():
    c = Connection(**Settings("EA3").rfc_params())
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    print("Original LZMCPU11 lines:", len(orig_lines))

    insert_idx = 31
    mod_lines = [{'LINE': l} for l in (orig_lines[:insert_idx] + CODE.splitlines() + orig_lines[insert_idx:])]

    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)
    try:
        r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='ADD_CVMAPC_3_MAPPINGS')
        print("Result:", r.get('EV_OK'), r.get('EV_MESSAGE'))
    finally:
        c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
               SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
        chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
        back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
        print("Restored identical to original:", back == orig_lines)

    v = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPC', DELIMITER='|',
               OPTIONS=[{'TEXT': "EC_DATA_TYPE IN ('PAYMENT_METHOD', 'PAY_COMPONENT', 'ADDRESS_TYPE')"}])
    for x in v['DATA']:
        print("DB row:", x['WA'])


if __name__ == "__main__":
    main()

