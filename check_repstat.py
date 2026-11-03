import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query HRSFEC_D_REPSTAT
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT',
           OPTIONS=[{'TEXT': "EXTERNAL_CODE IN ('70000017', '70000019')"}])
fields = [f['FIELDNAME'] for f in r.get('FIELDS', [])]
print(f"HRSFEC_D_REPSTAT fields: {fields}")
for d in r.get('DATA', []):
    print("REPSTAT:", d['WA'])

# Query any other entries in HRSFEC_D_REPSTAT
r_all = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT', ROWCOUNT=10)
for d in r_all.get('DATA', []):
    print("ALL REPSTAT:", d['WA'])

c.close()
