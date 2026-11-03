import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Read current LZMCPU11
res_read = c.call("RPY_PROGRAM_READ", PROGRAM_NAME="LZMCPU11")
orig_source = res_read["SOURCE_EXTENDED"]

test_code = """
  DATA: lo_repl TYPE REF TO cl_hrsfec_ptp_ee_replication.
  TRY.
      CREATE OBJECT lo_repl
        EXPORTING
          iv_config_id = 'DEFAULT'
          iv_ext_id    = '70000019'.
      lo_repl->execute( ).
      ev_ok = 'X'.
      ev_message = 'SUCCESS DEFAULT: triggered replication for 70000019'.
    CATCH cx_root INTO DATA(lx_err).
      ev_ok = ' '.
      ev_message = lx_err->get_text( ).
  ENDTRY.
"""

new_source = []
inside_func = False
injected = False

for line in orig_source:
    ltext = line["LINE"]
    new_source.append({"LINE": ltext})
    if "FUNCTION z_mcp_get_replication_log" in ltext.lower():
        inside_func = True
    elif inside_func and not injected and not ltext.strip().startswith('"') and not ltext.strip().startswith("*") and ltext.strip() != "":
        for tline in test_code.strip().splitlines():
            new_source.append({"LINE": tline})
        new_source.append({"LINE": "  RETURN."})
        injected = True

try:
    print("Injecting DEFAULT test run into LZMCPU11...")
    c.call("RPY_PROGRAM_UPDATE", PROGRAM_NAME="LZMCPU11", SOURCE_EXTENDED=new_source, CORRNUMBER="EA3K900019")
    
    print("Executing replication with CONFIG_ID = DEFAULT...")
    exec_res = c.call("Z_MCP_GET_REPLICATION_LOG")
    print("Result:", exec_res.get("EV_OK"), exec_res.get("EV_MESSAGE"))
finally:
    print("Restoring original LZMCPU11...")
    c.call("RPY_PROGRAM_UPDATE", PROGRAM_NAME="LZMCPU11", SOURCE_EXTENDED=orig_source, CORRNUMBER="EA3K900019")
    print("Restore done.")

