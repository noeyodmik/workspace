import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_FUNCTIONMODULE_READ', FUNCTIONNAME='Z_MCP_GET_REPLICATION_LOG')
print("IMPORT_PARAMETER:")
for p in r.get('IMPORT_PARAMETER', []):
    print(" ", p['PARAMETER'], p['DBFIELD'])
print("EXPORT_PARAMETER:")
for p in r.get('EXPORT_PARAMETER', []):
    print(" ", p['PARAMETER'], p['DBFIELD'])
print("TABLES_PARAMETER:")
for p in r.get('TABLES_PARAMETER', []):
    print(" ", p['PARAMETER'], p['DBFIELD'])

c.close()

