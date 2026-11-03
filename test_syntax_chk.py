import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """FUNCTION-POOL ZMCP.
  DATA: lo_enh TYPE REF TO if_enh_tool,
        lo_badi_impl TYPE REF TO cl_enh_tool_badi_impl,
        lt_impls TYPE enh_badi_impl_data_it,
        ls_impl TYPE enh_badi_impl_data,
        lv_spot TYPE enhspotname,
        lv_out TYPE string.
"""

# Call SYNTAX_CHECK
try:
    r = c.call('RFC_CHECK_ABAP_SYNTAX', PROGRAM='LZMCPU11')
    print("Direct check:", r)
except Exception as e:
    print("Err:", e)

c.close()

