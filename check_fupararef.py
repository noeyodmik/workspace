import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'PARAMETER'}, {'FIELDNAME': 'PARAMTYPE'}, {'FIELDNAME': 'STRUCTURE'}]
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='FUPARAREF',
           FIELDS=fields,
           OPTIONS=[{'TEXT': "FUNCNAME = 'Z_MCP_GET_REPLICATION_LOG'"}])
for d in r.get('DATA', []):
    print("PARAM:", d['WA'])

c.close()

