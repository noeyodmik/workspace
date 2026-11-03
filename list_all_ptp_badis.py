import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query TADIR for BADI definitions in HRSFEC packages
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TADIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "PGMID = 'R3TR' AND OBJECT = 'BADI' AND OBJ_NAME LIKE 'HRSFEC%'"}],
           FIELDS=[{'FIELDNAME': 'OBJ_NAME'}, {'FIELDNAME': 'DEVCLASS'}])
print("=== BADI in TADIR ===")
for x in r['DATA']:
    print(x['WA'].strip())

# Query ENHSPOTHEADER / ENHSPOTCOMPOSITE
try:
    r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHSPOTHEADER', DELIMITER='|',
                OPTIONS=[{'TEXT': "SPOTNAME LIKE 'HRSFEC%'"}],
                FIELDS=[{'FIELDNAME': 'SPOTNAME'}, {'FIELDNAME': 'DEVCLASS'}])
    print("=== ENHSPOTHEADER ===")
    for x in r2['DATA']:
        print(x['WA'].strip())
except Exception as e:
    print("ENHSPOTHEADER err:", e)

# Also check SXS_INTER for exit names
try:
    r3 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SXS_INTER', DELIMITER='|',
                OPTIONS=[{'TEXT': "EXIT_NAME LIKE 'HRSFEC%'"}],
                FIELDS=[{'FIELDNAME': 'EXIT_NAME'}, {'FIELDNAME': 'INTER_NAME'}])
    print("=== SXS_INTER ===")
    for x in r3['DATA']:
        print(x['WA'].strip())
except Exception as e:
    print("SXS_INTER err:", e)

