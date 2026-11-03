import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Search where HRSFEC_CE_CONV 001 is raised
tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC_API_CE_TYPE_CONV%'"}])
for x in tr['DATA']:
    prog = x['WA'].strip()
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if '001' in txt or 'CUT_OFF' in txt:
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                if '001' in l or 'CUT_OFF' in l or 'METHOD' in l:
                    print(f"{idx:03d}: {l}")
    except Exception:
        pass

# 2. Check 70000017 and 70000019 compensation and job data in CompoundEmployee payload
r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261030', IV_DATE_TO='20261030', IV_MAX=50)
ms = r.get('ET_MESSAGES', [])
for i, m in enumerate(ms):
    tx = m.get('MESSAGE') or ''
    if '<paycompensation_recurring>' in tx or '<compensation_information>' in tx or '<payment_information>' in tx:
        print(f"[{i}] {tx[:300]}")

