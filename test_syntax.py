import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Test syntax of CODE
code_to_check = """
REPORT ZTEST_SYNTAX.
DATA: lo_repl TYPE REF TO if_hrsfec_ptp_ee_replication,
      ls_msg  TYPE symsg,
      lv_ext  TYPE string VALUE '70000019'.

TRY.
    CREATE OBJECT lo_repl TYPE cl_hrsfec_ptp_ee_replication
      EXPORTING
        iv_confid                = 'DEFAULT'
        iv_ext_id                = lv_ext
        iv_use_config_individual = abap_true.

    lo_repl->execute( IMPORTING es_message = ls_msg ).
  CATCH cx_root INTO DATA(lx).
ENDTRY.
"""

r = c.call('RFC_ABAP_INSTALL_AND_RUN', PROGRAM=code_to_check.splitlines())
print(r)

c.close()

