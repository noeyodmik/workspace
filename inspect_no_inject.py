import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check T042Z fields and rows for KR
f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'POSITION'}],
           OPTIONS=[{'TEXT': "TABNAME = 'T042Z' AND AS4LOCAL = 'A'"}])
print("T042Z fields:", sorted([x['WA'] for x in f['DATA']], key=lambda s: s.split('|')[1]))

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T042Z', DELIMITER='|',
           FIELDS=[{'FIELDNAME': 'LAND1'}, {'FIELDNAME': 'ZLSCH'}, {'FIELDNAME': 'TEXT1'}],
           OPTIONS=[{'TEXT': "LAND1 = 'KR'"}])
print("=== T042Z (KR) ===")
for x in r['DATA']:
    print(" ", x['WA'])

# 2. Check T77SFEC_CVPROPC fields
f2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'POSITION'}],
            OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_CVPROPC' AND AS4LOCAL = 'A'"}])
print("T77SFEC_CVPROPC fields:", sorted([x['WA'] for x in f2['DATA']], key=lambda s: s.split('|')[1]))

# 3. Find classes/includes referencing HRSFEC_CE_CONV or HRSFEC_COMPENSAT
for cls in ['%CE_CONV%', '%COMP_XX%', '%PAYCOMP%', '%WT_PAYCOMP%']:
    tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
                FIELDS=[{'FIELDNAME': 'NAME'}],
                OPTIONS=[{'TEXT': f"NAME LIKE 'CL_HRSFEC{cls}'"}])
    for x in tr['DATA']:
        print("Program:", x['WA'].strip())

# 4. Read logs for 70000017 and 70000019
for ext in ['70000017', '70000019']:
    lg = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261030', IV_DATE_TO='20261030', IV_EXT_ID=ext, IV_MAX=2)
    print(f"\n=== HEADERS for {ext} ===")
    for h in lg.get('ET_HEADERS', []):
        print(" ", h.get('LOGNUMBER'), h.get('ALTIME'), "Tot:", h.get('MSG_CNT_AL'), "Err:", h.get('MSG_CNT_E'))
    print(f"=== MESSAGES for {ext} (latest run) ===")
    for m in lg.get('ET_MESSAGES', [])[-120:]:
        print(f"  {m.get('TYPE')} {m.get('ID')} {m.get('NUMBER')} | {m.get('MESSAGE_V1')} | {m.get('MESSAGE_V2')} | {m.get('MESSAGE_V3')} | {m.get('MESSAGE_V4')} -> {m.get('MESSAGE')}")
