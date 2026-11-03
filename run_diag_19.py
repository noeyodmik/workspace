import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- TEST DIAGNOSTICS FOR 70000019 ---
  IF iv_ext_id = 'DIAG_70000019'.
    DATA: lo_repl_d TYPE REF TO cl_hrsfec_ptp_ee_replication,
          ls_msg_d  TYPE symsg,
          lv_ext_d  TYPE string VALUE '70000019'.

    TRY.
        CREATE OBJECT lo_repl_d
          EXPORTING
            iv_confid                = 'DEFAULT'
            iv_ext_id                = lv_ext_d
            iv_use_config_individual = abap_true.

        " Run execute
        lo_repl_d->if_hrsfec_ptp_ee_replication~execute( IMPORTING es_message = ls_msg_d ).

        " Let's get messages from message handler
        DATA: lo_h TYPE REF TO cl_hrsfec_ptp_msg_handler,
              lt_m TYPE cl_hrsfec_ptp_msg_handler=>tt_messages.
        TRY.
            lo_h ?= lo_repl_d->mo_hrsfec_message_handler.
            lo_h->get_messages( RECEIVING rt_messages = lt_m ).
          CATCH cx_root.
        ENDTRY.

        DATA: lv_all_m TYPE string.
        LOOP AT lt_m ASSIGNING FIELD-SYMBOL(<lm>).
          lv_all_m = |{ lv_all_m } / [{ <lm>-msgty }] { <lm>-msgid } { <lm>-msgno }: { <lm>-msgv1 }|.
        ENDLOOP.

        ev_ok = 'X'.
        ev_message = |LOG: { lv_all_m }|.
      CATCH cx_root INTO DATA(lx_d).
        ev_ok = ' '.
        ev_message = |EXCEPTION: { lx_d->get_text( ) }|.
    ENDTRY.
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
           TRANSPORT_NUMBER='EA3K900013',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    try:
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='DIAG_70000019')
        print("DIAG RESULT:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
    finally:
        orig_source_ext = [{'LINE': l} for l in orig_lines]
        c.call('RPY_INCLUDE_UPDATE',
               INCLUDE_NAME='LZMCPU11',
               TRANSPORT_NUMBER='EA3K900013',
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=orig_source_ext)
        print("Restored.")

    c.close()

if __name__ == "__main__":
    main()

