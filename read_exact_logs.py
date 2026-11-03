import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for lognum in ['00000000000000040058', '00000000000000040061', '00000000000000040063']:
    print(f"\n==================== LOG {lognum} ====================")
    r = c.call('APPL_LOG_READ_DB',
               OBJECT='HRSFEC',
               LOGNUMBER=lognum)
    headers = r.get('HEADER_DATA', [])
    messages = r.get('MESSAGES', [])
    print(f"Headers: {len(headers)}, Messages: {len(messages)}")
    for m in messages:
        msgtxt = m.get('MESSAGE', '')
        msgty = m.get('MSGTY', '')
        msgid = m.get('MSGID', '')
        msgno = m.get('MSGNO', '')
        v1 = m.get('MSGV1', '')
        v2 = m.get('MSGV2', '')
        if msgty in ['E', 'A', 'W'] or 'PA' in msgtxt or '성공' in msgtxt or '실패' in msgtxt or '0008' in msgtxt:
            print(f"[{msgty}] {msgid} {msgno}: {msgtxt} | V1={v1} V2={v2}")

c.close()

