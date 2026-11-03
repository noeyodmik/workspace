import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for fm in ['RZL_READ_DIR_LOCAL', 'SUBST_GET_FILE_LIST', 'PFL_READ_PROFILE']:
    try:
        res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR', OPTIONS=[{'TEXT': f"FUNCNAME = '{fm}'"}], FIELDS=[{'FIELDNAME': 'FMODE'}])
        print(f"{fm} FMODE:", res['DATA'])
    except Exception as e:
        print(f"{fm} err:", e)

