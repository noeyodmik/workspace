import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search cross reference or source of CL_HRSFEC_PTP_EE_REPLICATION for '069'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_PTP_EE_REPLICATION==CP')
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
print(f"Total lines in CP: {len(lines)}")

# Read all includes of CL_HRSFEC_PTP_EE_REPLICATION
r_inc = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
               OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_PTP_EE_REPLICATION==CP'"}],
               FIELDS=[{'FIELDNAME': 'INCLUDE'}])

for d in r_inc['DATA']:
    inc = d['WA'].strip()
    r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
    for idx, l in enumerate(r_src.get('SOURCE_EXTENDED', [])):
        line = l.get('LINE', '')
        if '069' in line or '사원 복제' in line or 'BUNDLE' in line.upper():
            print(f"{inc}:{idx+1}: {line}")

c.close()

