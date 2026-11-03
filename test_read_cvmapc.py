import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check Z_MCP_READ_TABLE or Z_MCP_RUN_ABAP
# Let's test Z_MCP_RUN_ABAP
abap_code = """
DATA: lt_cvmapc TYPE TABLE OF t77sfec_cvmapc,
      ls_cvmapc TYPE t77sfec_cvmapc.

SELECT * FROM t77sfec_cvmapc INTO TABLE lt_cvmapc.
LOOP AT lt_cvmapc INTO ls_cvmapc.
  WRITE: / ls_cvmapc-ec_data_type, ls_cvmapc-ec_code, ls_cvmapc-erp_code.
ENDLOOP.
"""

r = c.call('Z_MCP_RUN_ABAP', IV_CODE=abap_code)
print("EV_OUTPUT:")
print(r.get('EV_OUTPUT'))
print("EV_ERROR:", r.get('EV_ERROR'))
c.close()

