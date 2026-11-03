import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'CONFIG_ID'}, {'FIELDNAME': 'TARGET_SYSTEM'}, {'FIELDNAME': 'FULL_TRANS_START_DATE'}]
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF', FIELDS=fields)
for d in r.get('DATA', []):
    print("CONF:", d['WA'])

c.close()

