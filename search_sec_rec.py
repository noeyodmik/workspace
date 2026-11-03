import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_PAD_SFEC_EE_MDR_BNDL_REQ_IN'"}],
           FIELDS=[{'FIELDNAME': 'METHODINDX'}, {'FIELDNAME': 'METHODNAME'}])
print("TMDIR CL_PAD_SFEC_EE_MDR_BNDL_REQ_IN:")
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

