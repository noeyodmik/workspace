import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for tab in ['SRT_MONI_TS', 'SRT_MONLOG_DATA2', 'SRT_MONILOG_DATA']:
    try:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=10)
        print(f"\n=== {tab} (Total {len(r['DATA'])}) ===")
        for d in r['DATA']:
            print(d['WA'][:120])
    except Exception as e:
        print(f"{tab} error: {e}")

c.close()

