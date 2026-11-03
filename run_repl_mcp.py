import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("Triggering replication via Z_MCP_GET_REPLICATION_LOG for 70000017...")
r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_TRIGGER_REPL='X',
           IV_CONFIG_ID='DEFAULT',
           IV_EXT_ID='70000017')

print("OK:", r.get('EV_OK'))
print("Message:", r.get('EV_MESSAGE'))

print("\n--- Log Summary ---")
for s in r.get('ET_LOG_SUMMARY', []):
    print(f"Log: {s.get('LOGNUMBER')} | Ext: {s.get('EXTNUMBER')} | All: {s.get('MSG_CNT_AL')} | E: {s.get('MSG_CNT_E')} | W: {s.get('MSG_CNT_W')}")

print("\n--- Log Details ---")
for d in r.get('ET_LOG_DETAILS', []):
    print(f"[{d.get('MSGTY')}] {d.get('MESSAGE')}")

# Check PA0008
r_pa8 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0008', DELIMITER='|',
               OPTIONS=[{'TEXT': "PERNR = '70000017'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'},
                       {'FIELDNAME': 'TRFAR'}, {'FIELDNAME': 'TRFGB'}, {'FIELDNAME': 'TRFGR'},
                       {'FIELDNAME': 'WAERS'}, {'FIELDNAME': 'LGA01'}, {'FIELDNAME': 'BET01'}, {'FIELDNAME': 'ANSAL'}])
print("\n--- PA0008 Records ---")
for x in r_pa8['DATA']:
    print(x['WA'].strip())

c.close()

