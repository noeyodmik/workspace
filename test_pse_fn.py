import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for applic in ['100_SP', '100_EY', '100_SD', 'DFAULT']:
    try:
        # Check SSFPSE_FILENAME
        res_fn = c.call('SSFPSE_FILENAME', CONTEXT='SSLC', APPLIC=applic)
        print(f"[{applic}] PSE filename:", res_fn.get('PROFILE'))
    except Exception as e:
        print(f"[{applic}] PSE error:", e)

