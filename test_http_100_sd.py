import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- TEST HTTP CALL WITH 100_SD ---
  IF iv_ext_id = 'TEST_HTTP_100_SD'.
    DATA: lo_client TYPE REF TO if_http_client,
          lv_subrc  TYPE sysubrc,
          lv_err    TYPE string.

    cl_http_client=>create_by_destination(
      EXPORTING
        destination = '100_SD'
      IMPORTING
        client      = lo_client
      EXCEPTIONS
        OTHERS      = 1 ).

    IF sy-subrc <> 0.
      ev_ok = ' '.
      ev_message = 'Failed to create HTTP client for 100_SD'.
      RETURN.
    ENDIF.

    lo_client->send( EXCEPTIONS OTHERS = 1 ).
    IF sy-subrc <> 0.
      lo_client->get_last_error( IMPORTING message = lv_err ).
      ev_ok = ' '.
      ev_message = |SEND ERROR: { lv_err }|.
      RETURN.
    ENDIF.

    lo_client->receive( EXCEPTIONS OTHERS = 1 ).
    IF sy-subrc <> 0.
      lo_client->get_last_error( IMPORTING message = lv_err ).
      ev_ok = ' '.
      ev_message = |RECEIVE ERROR: { lv_err }|.
      RETURN.
    ENDIF.

    lo_client->response->get_status( IMPORTING code = DATA(lv_code) reason = DATA(lv_reason) ).
    DATA(lv_body) = lo_client->response->get_cdata( ).
    ev_ok = 'X'.
    ev_message = |HTTP { lv_code } { lv_reason }: { lv_body(150) }|.
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
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=mod_lines)

    try:
        r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_HTTP_100_SD')
        print("HTTP 100_SD Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
    finally:
        orig_source_ext = [{'LINE': l} for l in orig_lines]
        c.call('RPY_INCLUDE_UPDATE',
               INCLUDE_NAME='LZMCPU11',
               TRANSPORT_NUMBER='EA3K900019',
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=orig_source_ext)

if __name__ == "__main__":
    main()

