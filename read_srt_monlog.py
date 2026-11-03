import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SRT_MONLOG_DATA2', DELIMITER='|',
           ROWCOUNT=15,
           FIELDS=[{'FIELDNAME': 'IF_NAME_E'}, {'FIELDNAME': 'OP_NAME'},
                   {'FIELDNAME': 'PROC_STATE'}, {'FIELDNAME': 'MSG_STATE'},
                   {'FIELDNAME': 'ERRORTYPE'}, {'FIELDNAME': 'TS_CALL'}])
print(f"Latest SRT_MONLOG_DATA2 records ({len(r['DATA'])}):")
for d in r['DATA']:
    print(d['WA'].strip())
c.close()

