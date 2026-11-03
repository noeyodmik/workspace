import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  IF iv_ext_id = 'INSPECT_51_55'.
    DATA: lt_logh TYPE bal_t_logh,
          ls_logh TYPE balloghndl,
          lt_msgh TYPE bal_t_msgh,
          ls_msgh TYPE balmsghndl,
          ls_msg  TYPE bal_s_msg,
          lv_txt  TYPE string,
          lt_out  TYPE TABLE OF string,
          ls_hdr  TYPE balhdr,
          ls_042z TYPE t042z.

    APPEND '=== T042Z (KR) ===' TO lt_out.
    SELECT * FROM t042z INTO ls_042z WHERE land1 = 'KR'.
      APPEND |ZLSCH={ ls_042z-zlsch } TEXT1={ ls_042z-text1 } XBKNT={ ls_042z-xbknt }| TO lt_out.
    ENDSELECT.

    SELECT * FROM balhdr INTO ls_hdr
      WHERE lognumber IN ('00000000000000040051', '00000000000000040055')
      ORDER BY lognumber.
      CLEAR: lt_logh, lt_msgh.
      APPEND ls_hdr-log_handle TO lt_logh.
      CALL FUNCTION 'BAL_DB_LOAD'
        EXPORTING i_t_log_handle = lt_logh
        IMPORTING e_t_msg_handle = lt_msgh
        EXCEPTIONS OTHERS = 1.
      APPEND |=== { ls_hdr-lognumber } ({ ls_hdr-extnumber }) ===| TO lt_out.
      LOOP AT lt_msgh INTO ls_msgh.
        CALL FUNCTION 'BAL_LOG_MSG_READ'
          EXPORTING i_s_msg_handle = ls_msgh
          IMPORTING e_s_msg = ls_msg
          EXCEPTIONS OTHERS = 1.
        MESSAGE ID ls_msg-msgid TYPE ls_msg-msgty NUMBER ls_msg-msgno
          WITH ls_msg-msgv1 ls_msg-msgv2 ls_msg-msgv3 ls_msg-msgv4
          INTO lv_txt.
        APPEND |{ ls_msg-msgty } { ls_msg-msgid } { ls_msg-msgno } [{ ls_msg-msgv1 }|{ ls_msg-msgv2 }|{ ls_msg-msgv3 }|{ ls_msg-msgv4 }] -> { lv_txt }| TO lt_out.
      ENDLOOP.
    ENDSELECT.

    ev_ok = 'X'.
    CONCATENATE LINES OF lt_out INTO ev_message SEPARATED BY cl_abap_char_utilities=>newline.
    RETURN.
  ENDIF.
"""

def main():
    c = Connection(**Settings("EA3").rfc_params())
    for t in ['T77SFEC_CVPROPC', 'T77SFEC_CVPROPS']:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=t, DELIMITER='|',
                   OPTIONS=[{'TEXT': "EC_DATA_TYPE = 'PAY_COMPONENT'"}])
        print(f"=== {t} (PAY_COMPONENT) ===")
        for x in r['DATA']:
            print(" ", x['WA'])

    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)
    try:
        out = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='INSPECT_51_55')
        print(out.get('EV_MESSAGE'))
    finally:
        c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
               SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])

if __name__ == "__main__":
    main()
