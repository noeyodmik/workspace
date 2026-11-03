import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 읽기 전용 진단: 임시 주입 후 finally 에서 반드시 원복
CODE = """  " --- DIAG SECONDARY INFTY ---
  IF iv_ext_id = 'DIAG_SEC'.
    DATA: lv_sec_d   TYPE infty,
          lv_viekn_d TYPE viekn,
          lv_txt_d   TYPE string.
    TRY.
        lv_viekn_d = cl_hrpa_viekn=>viekn( tclas = 'A' pernr = '00000064' ).
        lv_txt_d = |VIEKN64=[{ lv_viekn_d }]|.
      CATCH cx_root INTO DATA(lx_d1).
        lv_txt_d = |VIEKN EX: { lx_d1->get_text( ) }|.
    ENDTRY.
    TRY.
        DATA(ls_t582v_d) = cl_hr_t582v=>read( molga = lv_viekn_d infty = '0002' ).
        lv_txt_d = |{ lv_txt_d } T582V-VINFT=[{ ls_t582v_d-vinft }]|.
      CATCH cx_root INTO DATA(lx_d2).
        lv_txt_d = |{ lv_txt_d } T582V EX: { lx_d2->get_text( ) }|.
    ENDTRY.
    ev_ok = 'X'.
    ev_message = lv_txt_d.
    RETURN.
  ENDIF.
"""

def main():
    c = Connection(**Settings("EA3").rfc_params())
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    print("orig lines:", len(orig_lines))
    insert_idx = 31
    mod = [{'LINE': l} for l in (orig_lines[:insert_idx] + CODE.splitlines() + orig_lines[insert_idx:])]
    try:
        c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
               SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod)
        r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='DIAG_SEC')
        print("RESULT:", r.get('EV_OK'), r.get('EV_MESSAGE'))
    except Exception as e:
        print("ERR:", e)
    finally:
        c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
               SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
        chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
        print("restored lines:", len(chk.get('SOURCE_EXTENDED', [])))
    c.close()

if __name__ == "__main__":
    main()

