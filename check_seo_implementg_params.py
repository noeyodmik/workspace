import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'SAPLSEOC' + '=' * (30 - len('SAPLSEOC')) + 'CU'
# Let's inspect function module parameter table FPARAREF or read the FM directly
# We can read the include of SEO_IMPLEMENTG_CREATE
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "FUNCNAME = 'SEO_IMPLEMENTG_CREATE'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}])
print("Include:", r['DATA'])
inc = 'LSEOCU' + r['DATA'][0]['WA'].strip()
r2 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
for idx, l in enumerate(r2.get('SOURCE_EXTENDED', [])[:35]):
    print(f"{idx+1:03d}: {l['LINE']}")

c.close()

