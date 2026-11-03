import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SRT_MONILOG_ADM', DELIMITER='|',
           OPTIONS=[{'TEXT': "EXEC_DATE = '20261103'"}],
           FIELDS=[{'FIELDNAME': 'LOG_ID'}, {'FIELDNAME': 'EXEC_TIME'},
                   {'FIELDNAME': 'INTERFACE_NAME'}, {'FIELDNAME': 'OPERATION_NAME'},
                   {'FIELDNAME': 'STATUS'}])
print(f"Total SRT_MONILOG_ADM today: {len(r['DATA'])}")
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

