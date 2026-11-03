import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1) customer mapping rows for the types behind errors 163/165
for t in ['EMPLOYMENT_TYPE', 'EMPLOYEE_CLASS']:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPC', DELIMITER='|',
               OPTIONS=[{'TEXT': "EC_DATA_TYPE = '%s'" % t}])
    print('== CVMAPC', t, len(r['DATA']))
    for x in r['DATA']:
        print(x['WA'])

# 2) actual lookup logic: grep class includes for country dependency handling
cls = 'CL_HRSFEC_CODE_VALUE_MAPPING'
pad = cls + '=' * (30 - len(cls))
for i in range(1, 16):
    inc = pad + 'CM%03d' % i
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
    except Exception:
        continue
    lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    hit = [k for k, l in enumerate(lines)
           if any(w in l.upper() for w in ('COUNTRY', 'IS_COUNTRY_DEPENDENT', 'MESSAGE', '015'))]
    if hit:
        print('--- include', inc, 'lines', len(lines))
        lo = max(0, hit[0] - 5)
        hi = min(len(lines), hit[-1] + 5)
        for k in range(lo, min(hi, lo + 90)):
            print(k, lines[k])

