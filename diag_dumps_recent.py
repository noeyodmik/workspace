import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 최근 덤프만 (시스템 시간은 UTC 기준: 04:07 = KST 13:07). 조회 전용.
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SNAP_BEG', DELIMITER='|', ROWCOUNT=100,
           OPTIONS=[{'TEXT': "DATUM = '20261103' AND UZEIT >= '040000'"}],
           FIELDS=[{'FIELDNAME': 'UZEIT'}, {'FIELDNAME': 'UNAME'}, {'FIELDNAME': 'SEQNO'}])
print("dumps since 04:00 UTC:", len(r['DATA']))
for d in r['DATA']:
    print("  ", d['WA'].strip())

# 같은 시간대, DUSER03 이외 사용자(인바운드 SOAP 처리 사용자 후보)
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SNAP_BEG', DELIMITER='|', ROWCOUNT=100,
            OPTIONS=[{'TEXT': "DATUM = '20261103' AND UNAME <> 'DUSER03'"}],
            FIELDS=[{'FIELDNAME': 'UZEIT'}, {'FIELDNAME': 'UNAME'}, {'FIELDNAME': 'SEQNO'}])
print("dumps today by other users:", len(r2['DATA']))
for d in r2['DATA'][-10:]:
    print("  ", d['WA'].strip())
c.close()

