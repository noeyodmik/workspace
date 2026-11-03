import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_PTP_EE_REPLICATION'"}])
for d in r.get('DATA', []):
    wa = d['WA']
    if 'EXECUTE_PTP_QUERY' in wa or 'PROCESS_EE_MDR' in wa or 'EC_SFAPI_QUERY' in wa:
        print(wa)

c.close()

