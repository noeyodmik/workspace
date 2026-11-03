import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cls = 'CL_HRSFEC_PTP_EE_REPLICATION'
# 28 chars, so cls + '==' + 'CM011' etc.
for num in ['CM009', 'CM010', 'CM025', 'CM037']:
    inc = cls + '==' + num
    try:
        r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        print(f"Found {inc}: {len(r.get('SOURCE_EXTENDED', []))} lines")
        for l in r.get('SOURCE_EXTENDED', [])[:15]:
            print(" ", l['LINE'])
    except Exception as e:
        pass

c.close()

