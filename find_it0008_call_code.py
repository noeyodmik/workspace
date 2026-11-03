import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX')) + 'CP'

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
           OPTIONS=[{'TEXT': f"MASTER = '{pad}'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}])

print("Total includes in class:", len(r['DATA']))
for x in r['DATA']:
    inc = x['WA'].strip()
    if 'CM' in inc:
        try:
            res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
            lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
            for l in lines[:3]:
                if 'CALL_BADI_CHANGE_IT0008' in l:
                    print(f"FOUND IN {inc}:")
                    for idx, line in enumerate(lines):
                        print(f"{idx+1:03d}: {line}")
                    break
        except Exception:
            pass

c.close()

