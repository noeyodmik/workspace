import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pernrs = ['70000017', '70000019']

for pernr in pernrs:
    print(f"\n==================== PERNR: {pernr} ====================")
    for infty in ['PA0000', 'PA0001', 'PA0002', 'PA0006', 'PA0008', 'PA0009', 'PA0105', 'PA0539']:
        try:
            r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=infty, DELIMITER='|',
                       OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}])
            print(f"--- {infty} ({len(r['DATA'])} records) ---")
            for d in r['DATA']:
                print(d['WA'][:150])
        except Exception as e:
            print(f"--- {infty}: Error {e} ---")

c.close()

