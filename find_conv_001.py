import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_API_CE_TYPE_CONV===CP')
print("CP read.")

# Read all includes of CL_HRSFEC_API_CE_TYPE_CONV
r_inc = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
               OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_API_CE_TYPE_CONV===CP'"}],
               FIELDS=[{'FIELDNAME': 'INCLUDE'}])

for d in r_inc['DATA']:
    inc = d['WA'].strip()
    try:
        r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        for idx, l in enumerate(r_src.get('SOURCE_EXTENDED', [])):
            line = l.get('LINE', '')
            if '001' in line and 'HRSFEC_CE_CONV' in line:
                print(f"{inc}:{idx+1}: {line}")
                for j in range(max(0, idx-5), min(len(r_src.get('SOURCE_EXTENDED', [])), idx+15)):
                    print(f"  {r_src.get('SOURCE_EXTENDED', [])[j]['LINE']}")
    except Exception as e:
        pass

c.close()

