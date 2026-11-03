import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261103', IV_DATE_TO='20261103', IV_MAX=200)
ms = r.get('ET_MESSAGES', [])
in_19 = False
soap_lines = []
for m in ms:
    tx = m.get('MESSAGE') or ''
    if '00:28:' in tx:
        in_19 = True
    if in_19 and m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
        soap_lines.append(tx)

print(f"Total SOAP lines for 70000019: {len(soap_lines)}")
full_xml = "".join(soap_lines)
print("=== XML Preview (first 2000 chars) ===")
print(full_xml[:2000])
if 'paycompensation' in full_xml.lower():
    print("=== Found paycompensation! ===")
    idx = full_xml.lower().find('compensation')
    print(full_xml[max(0, idx-100):min(len(full_xml), idx+1500)])
else:
    print("=== No paycompensation found in XML ===")

