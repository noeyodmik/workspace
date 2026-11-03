import io, sys, re
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

t = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T542A', DELIMITER='|',
           OPTIONS=[{'TEXT': "MOLGA = '41'"}])
print('T542A MOLGA=41:', [x['WA'] for x in t['DATA']])

CUT = sys.argv[1] if len(sys.argv) > 1 else '08:28'
r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261030', IV_DATE_TO='20261030', IV_MAX=50)
for h in r.get('ET_HEADERS', [])[-6:]:
    print(h.get('LOGNUMBER'), h.get('SUBOBJECT'), h.get('EXTNUMBER'), 'Tot', h.get('MSG_CNT_AL'), 'Err', h.get('MSG_CNT_E'), h.get('ALTIME'))

ms = r.get('ET_MESSAGES', [])
start = None
for i, m in enumerate(ms):
    mt = re.search(r'2026-10-30 (\d\d:\d\d)', m.get('MESSAGE') or '')
    if mt and mt.group(1) >= CUT:
        start = i
        break
print('block start:', start)
if start is not None:
    for m in ms[start:]:
        tx = m.get('MESSAGE') or ''
        if m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
            continue
        if m.get('TYPE') in ('E', 'W', 'A', 'S') or m.get('NUMBER') in ('026', '106', '114', '081'):
            print(m.get('TYPE'), m.get('ID'), m.get('NUMBER'), tx[:160])
