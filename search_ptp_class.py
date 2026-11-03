import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_PTP_EE_REPLICATION==CP')
print("CL_HRSFEC_PTP_EE_REPLICATION pool read.")
# Let's search includes of CL_HRSFEC_PTP_EE_REPLICATION
res_inc = c.call('BBP_RFC_READ_TABLE', 
                 QUERY_TABLE='D010INC',
                 OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_PTP_EE_REPLICATION==CP'"}],
                 FIELDS=[{'FIELDNAME': 'INCLUDE'}])

for r in res_inc['DATA']:
    print(r['WA'])

