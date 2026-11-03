import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cls = 'CL_HRSFEC_PTP_EE_REPLICATION'
# Method 00028: check which include it is
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_PTP_EE_REPLICATION' AND METHODNAME = 'EXECUTE_PTP_QUERY'"}])
print("TMDIR for EXECUTE_PTP_QUERY:", r.get('DATA'))

c.close()

