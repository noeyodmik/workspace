import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings().rfc_params())

# 1. T77SFEC_KMAPCOSC (코스트센터 매핑 테이블) 확인
print("=== 1. T77SFEC_KMAPCOSC (Cost Center Mapping) ===")
r_cc = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_KMAPCOSC', ROWCOUNT=20)
print('Count:', len(r_cc.get('DATA', [])))
for row in r_cc.get('DATA', []):
    print(' ', row.get('WA'))

# 2. T77SFEC_PTP_CONF의 TARGET_SYSTEM 확인
print("\n=== 2. T77SFEC_PTP_CONF 100_EY ===")
r_conf = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF',
                OPTIONS=[{'TEXT': "CONFIG_ID = '100_EY'"}],
                FIELDS=[{'FIELDNAME': 'CONFIG_ID'}, {'FIELDNAME': 'TARGET_SYSTEM'}, {'FIELDNAME': 'COMPANY'}])
for row in r_conf.get('DATA', []):
    print(' ', row.get('WA'))

# 3. Z100 관리회계영역의 CSKS (코스트센터 마스터) 확인
print("\n=== 3. CSKS in Controlling Area Z100 ===")
r_csks = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='CSKS',
                OPTIONS=[{'TEXT': "KOKRS = 'Z100'"}],
                FIELDS=[{'FIELDNAME': 'KOKRS'}, {'FIELDNAME': 'KOSTL'}, {'FIELDNAME': 'BUKRS'}],
                ROWCOUNT=10)
print('CSKS Count:', len(r_csks.get('DATA', [])))
for row in r_csks.get('DATA', []):
    print(' ', row.get('WA'))
