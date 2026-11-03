import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_MAIN' + '=' * (30 - len('CL_HRSFEC_EE_MDR_MAIN'))

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_EE_MDR_MAIN'"},
                    {'TEXT': "AND METHODNAME = '_PROCESS_COMPENSATION'"}],
           FIELDS=[{'FIELDNAME': 'METHODINDX'}])
idx = r['DATA'][0]['WA'].strip()
print("Index:", idx)

inc = f"{pad}CM{int(idx):03d}"
res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print(f"=== {inc} ({len(lines)} lines) ===")
for i, l in enumerate(lines[:60]):
    print(f"{i+1:03d}: {l}")
