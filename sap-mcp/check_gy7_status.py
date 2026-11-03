import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

params = {
    'ashost': 'vacigy7',
    'sysnr': '00',
    'client': '100',
    'user': 'seppin',
    'passwd': 'Qwer1234@',
    'lang': 'KO',
    'saprouter': '/H/10.20.13.11/S/3299/H/payroll50.sapsf.eu/S/3299'
}

c = Connection(**params)

# 1. Z_MCP_ 함수 모듈 검색
print("=== 1. Checking Z_MCP_* Functions in GY7 ===")
try:
    r = c.call('RFC_FUNCTION_SEARCH', FUNCNAME='Z_MCP_*')
    funcs = [f.get('FUNCNAME') for f in r.get('FUNCTIONS', [])]
    print(f"Found {len(funcs)} Z_MCP_* functions:")
    for fn in funcs:
        print("  -", fn)
except Exception as e:
    print("Function search error:", e)

# 2. BBP_RFC_READ_TABLE 테스트
print("\n=== 2. Testing BBP_RFC_READ_TABLE ===")
try:
    r_tab = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T001', ROWCOUNT=5, FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'BUTXT'}])
    print(f"T001 Read OK, count: {len(r_tab.get('DATA', []))}")
    for row in r_tab.get('DATA', []):
        print(" ", row.get('WA'))
except Exception as e:
    print("Table read error:", e)

# 3. PTP 설정 테이블 확인
print("\n=== 3. Checking T77SFEC_PTP_CONF in GY7 ===")
try:
    r_ptp = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF', FIELDS=[{'FIELDNAME': 'CONFIG_ID'}])
    print("PTP configs in GY7:")
    for row in r_ptp.get('DATA', []):
        print(" ", row.get('WA').strip())
except Exception as e:
    print("PTP config table error:", e)
