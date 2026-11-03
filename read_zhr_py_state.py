import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def q(tab, fields, opts, rows=100):
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=rows,
               OPTIONS=[{'TEXT': o} for o in opts],
               FIELDS=[{'FIELDNAME': f} for f in fields])
    return [d['WA'].strip() for d in r['DATA']]

print("TMDIR ZHR_PY:")
for x in q('TMDIR', ['METHODINDX', 'METHODNAME'], ["CLASSNAME = 'ZHR_PY'"]):
    print("  ", x)
print("TRDIR ZHR_PY includes:")
for x in q('TRDIR', ['NAME', 'SUBC', 'UDAT', 'UNAM'], ["NAME LIKE 'ZHR_PY%'"]):
    print("  ", x)

# 각 include 내용 + 클래스 풀 구문 (읽기 전용)
for suffix in ['========================CP', '========================CU',
               '========================CM001', '========================CM002', '========================CM003']:
    name = 'ZHR_PY' + suffix
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=name)
        L = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"===== {name} ({len(L)} lines)")
        for i, l in enumerate(L[:60], 1):
            print(f"{i:3}: {l}")
    except Exception as e:
        print(f"===== {name} ERR: {str(e)[:100]}")
c.close()

