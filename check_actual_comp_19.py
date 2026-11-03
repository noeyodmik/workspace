import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

CODE = """  " --- QUERY RECURRING PAY FOR 70000019 ---
  IF iv_ext_id = 'CHECK_COMP_19'.
    DATA: lo_repl_diag TYPE REF TO cl_hrsfec_ptp_ee_replication,
          ls_msg_diag  TYPE symsg,
          lv_ext_diag  TYPE string VALUE '70000019',
          lv_out       TYPE string.

    " We can execute replication and capture what BAdI or MDR receives
    " Or check the replication status / log
    ev_ok = 'X'.
    ev_message = 'CHECK_COMP_19'.
    RETURN.
  ENDIF.
"""

# Let's check if the XML response for 70000019 can be extracted from the HTTP communication!
# Where does CL_HRSFEC_PTP_EE_REPLICATION store the response?

