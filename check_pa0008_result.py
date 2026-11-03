import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check replication log via Z_MCP_GET_REPLICATION_LOG
r_log = c.call('Z_MCP_GET_REPLICATION_LOG', IV_PERNR='70000017')
print("Log OK:", r_log.get('EV_OK'))
print("Log Message:", r_log.get('EV_MESSAGE'))
print("Log Details:")
for l in r_log.get('ET_LOG_DETAILS', []):
    print(f"[{l.get('MSGTY')}] {l.get('MESSAGE')}")

# 2. Query PA0008 directly
r_pa8 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0008', DELIMITER='|',
               OPTIONS=[{'TEXT': "PERNR = '70000017'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'},
                       {'FIELDNAME': 'TRFAR'}, {'FIELDNAME': 'TRFGB'}, {'FIELDNAME': 'TRFGR'},
                       {'FIELDNAME': 'WAERS'}, {'FIELDNAME': 'LGA01'}, {'FIELDNAME': 'BET01'}, {'FIELDNAME': 'ANSAL'}])
print("\nPA0008 Records:")
for x in r_pa8['DATA']:
    print(x['WA'].strip())

c.close()

