import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def fields(tab):
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
               OPTIONS=[{'TEXT': f"TABNAME = '{tab}'"}],
               FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    return [d['WA'].strip() for d in r['DATA']]

for tab in ('SNAP_BEG', 'SNAP'):
    print(tab, fields(tab))

# 오늘자 ABAP 덤프 헤더 (조회 전용)
for tab in ('SNAP_BEG', 'SNAP'):
    try:
        f = [x for x in fields(tab) if x in ('DATUM', 'UZEIT', 'UHRZEIT', 'UNAME', 'SEQNO')]
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=200,
                   OPTIONS=[{'TEXT': "DATUM = '20261103'"}],
                   FIELDS=[{'FIELDNAME': x} for x in f])
        print(f"--- {tab} today: {len(r['DATA'])}")
        for d in r['DATA'][-15:]:
            print("  ", d['WA'].strip())
        break
    except Exception as e:
        print(f"--- {tab} ERR: {str(e)[:120]}")
c.close()

