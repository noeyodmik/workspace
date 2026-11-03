import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RZL_READ_DIR_LOCAL', NAME='/usr/sap/EA3/D00/exe')
sapgenpse = [f.get('NAME') for f in res.get('FILE_TBL', []) if 'sapgenpse' in f.get('NAME').lower()]
print("sapgenpse in D00/exe:", sapgenpse)
