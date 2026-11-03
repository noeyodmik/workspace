import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def q(tab, fields, opts=None, rows=50):
    try:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=rows,
                   OPTIONS=[{'TEXT': o} for o in (opts or [])],
                   FIELDS=[{'FIELDNAME': f} for f in fields])
        print(f"--- {tab}: {len(r['DATA'])} rows")
        for d in r['DATA']:
            print("  ", d['WA'].strip())
    except Exception as e:
        print(f"--- {tab} ERR: {str(e)[:150]}")

# 1) 로컬 큐/비동기 상태 (조회 전용)
q('TRFCQOUT', ['QNAME', 'QDEST', 'QSTATE'], rows=20)
q('TRFCQIN', ['QNAME', 'QSTATE'], rows=20)
q('ARFCSSTATE', ['ARFCDEST', 'ARFCFNAM', 'ARFCSTATE', 'ARFCDATUM', 'ARFCUZEIT'], rows=20)
# 2) SOAP 논리포트 (SOAMANAGER)
q('LPCONFIG', ['LP_NAME', 'PROXYNAME'], ["PROXYNAME LIKE '%SFEC%'"])
q('LPCONFIG', ['LP_NAME', 'PROXYNAME'], ["PROXYNAME LIKE '%EE_MDR%'"])
c.close()

