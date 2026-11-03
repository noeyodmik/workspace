import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_ENH_FACTORY' + '=' * (30 - len('CL_ENH_FACTORY')) + 'CP'
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_ENH_FACTORY' AND "},
                    {'TEXT': "METHODNAME = 'CREATE_ENHANCEMENT'"}],
           FIELDS=[{'FIELDNAME': 'METHODINDX'}])
indx = r['DATA'][0]['WA'].strip()
print("Method index:", indx)

pad_m = 'CL_ENH_FACTORY' + '=' * (30 - len('CL_ENH_FACTORY')) + f"CM{indx[-3:]}"
r_m = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=pad_m)
lines = [l['LINE'] for l in r_m.get('SOURCE_EXTENDED', [])]
print(f"Total lines: {len(lines)}")
for idx, l in enumerate(lines[:60]):
    print(f"{idx+1:03d}: {l}")

c.close()

