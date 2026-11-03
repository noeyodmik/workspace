import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def q(tab, fields, opts, rows=100):
    try:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=rows,
                   OPTIONS=[{'TEXT': o} for o in opts],
                   FIELDS=[{'FIELDNAME': f} for f in fields])
        print(f"--- {tab}: {len(r['DATA'])} rows")
        for d in r['DATA']:
            print("  ", d['WA'].strip())
    except Exception as e:
        print(f"--- {tab} ERR: {str(e)[:150]}")

# 1) ZHR_PY 가 구현하는 인터페이스 (조회 전용)
q('SEOMETAREL', ['CLSNAME', 'REFCLSNAME', 'VERSION'], ["CLSNAME = 'ZHR_PY'"])
# 2) 스팟 HRSFEC_CE_MASTER_DATA_REPL 의 BAdI 구현 목록
q('BADI_IMPL', ['ENHNAME', 'BADI_NAME', 'BADI_IMPL', 'IMPL_CLASS', 'ACTIVE'],
  ["BADI_NAME LIKE 'HRSFEC_B_CE_CHANGE%'"])
# 3) ZHR_PY 클래스/관련 메서드 상태
q('SEOCLASSDF', ['CLSNAME', 'VERSION', 'STATE', 'CHANGEDON'], ["CLSNAME = 'ZHR_PY'"])
c.close()

