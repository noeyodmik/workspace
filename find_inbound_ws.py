import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())
r_inc = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
               OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_PTP_EE_REPLICATION==CP'"}],
               FIELDS=[{'FIELDNAME': 'INCLUDE'}])

for d in r_inc['DATA']:
    inc = d['WA'].strip()
    try:
        r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        for idx, l in enumerate(r_src.get('SOURCE_EXTENDED', [])):
            line = l.get('LINE', '')
            if 'METHOD INVOKE_INBOUND_WS' in line.upper():
                print(f"Found in {inc}:{idx+1}")
                # print whole method
                for j in range(idx, min(idx+40, len(r_src.get('SOURCE_EXTENDED', [])))):
                    print(r_src.get('SOURCE_EXTENDED', [])[j]['LINE'])
                break
    except:
        pass
c.close()

