import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 04:07:42(UTC) = 복제 실행 시각(13:07 KST)의 덤프 본문 앞부분 (조회 전용)
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SNAP_BEG', DELIMITER='|', ROWCOUNT=40,
           OPTIONS=[{'TEXT': "DATUM = '20261103' AND UZEIT = '040742'"},
                    {'TEXT': "AND SEQNO < '010'"}],
           FIELDS=[{'FIELDNAME': 'SEQNO'}, {'FIELDNAME': 'FLIST'}])
for d in r['DATA']:
    print(d['WA'].rstrip())
c.close()
