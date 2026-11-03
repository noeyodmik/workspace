import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query the compensation info XML for 70000019
# We can call SFAPI CompoundEmployee via ABAP or inspect the session log
CODE = """  " --- QUERY CE FOR 70000019 AND EXTRACT COMPENSATION ---
  IF iv_ext_id = 'GET_CE_19'.
    DATA: lo_repl TYPE REF TO cl_hrsfec_ptp_ee_replication,
          ls_msg  TYPE symsg,
          lv_ext  TYPE string VALUE '70000019'.

    SELECT SINGLE * FROM t77sfec_ptp_conf INTO @DATA(ls_conf) WHERE config_id = 'DEFAULT'.
    TRY.
        CREATE OBJECT lo_repl
          EXPORTING
            iv_confid                = 'DEFAULT'
            iv_ext_id                = lv_ext
            iv_use_config_individual = abap_true.

        " Use CE data provider or SFAPI query
        " Let's query SFAPI directly
        ev_ok = 'X'.
        ev_message = 'Query ready'.
      CATCH cx_root INTO DATA(lx).
        ev_ok = ' '.
        ev_message = lx->get_text( ).
    ENDTRY.
    RETURN.
  ENDIF.
"""

