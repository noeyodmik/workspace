import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings

s = Settings("EA3")
print("audit_log path:", s.audit_log)
print("readonly setting:", s.readonly)

