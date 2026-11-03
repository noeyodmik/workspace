import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cls = 'CL_HRSFEC_PTP_EE_REPLICATION==CP'
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC',
           OPTIONS=[{'TEXT': f"MASTER = '{cls}'"}])
for d in r.get('DATA', []):
    print("D010INC:", d['WA'])

c.close()
