import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search SO_HRSFEC_UTIL in CL_HRSFEC_PTP_EE_REPLICATION includes
r_inc = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
               OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_PTP_EE_REPLICATION==CP'"}],
               FIELDS=[{'FIELDNAME': 'INCLUDE'}])

for d in r_inc['DATA']:
    inc = d['WA'].strip()
    try:
        r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        for idx, l in enumerate(r_src.get('SOURCE_EXTENDED', [])):
            line = l.get('LINE', '')
            if 'SO_HRSFEC_UTIL' in line:
                print(f"{inc}:{idx+1}: {line}")
    except:
        pass
c.close()

