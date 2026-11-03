import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings().rfc_params())

log_no = '00000000000000040022'
res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALM',
             OPTIONS=[{'TEXT': f"LOGNUMBER = '{log_no}'"}],
             FIELDS=[{'FIELDNAME': 'MSGTY'}, {'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'MSGNO'},
                     {'FIELDNAME': 'MSGV1'}, {'FIELDNAME': 'MSGV2'}, {'FIELDNAME': 'MSGV3'}, {'FIELDNAME': 'MSGV4'}])

print(f"Messages in log {log_no}: count = {len(res.get('DATA', []))}")
for r in res.get('DATA', []):
    wa = r.get('WA')
    msgty = wa[0:1]
    msgid = wa[1:21].strip()
    msgno = wa[21:24].strip()
    v1 = wa[24:74].strip() if len(wa) > 24 else ""
    v2 = wa[74:124].strip() if len(wa) > 74 else ""
    # 메시지 텍스트 가져오기
    try:
        t_res = c.call('BAPI_MESSAGE_GETDETAIL', ID=msgid, NUMBER=msgno,
                       TEXTFORMAT='NAT',
                       MESSAGE_V1=v1, MESSAGE_V2=v2)
        txt = t_res.get('MESSAGE', '')
    except Exception:
        txt = ""
    print(f"  [{msgty}] {msgid} {msgno}: {txt} | ({v1} / {v2})")
