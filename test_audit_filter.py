import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")

from server import get_audit_log

res = get_audit_log(limit=5, tool_name="activate_object")
print("ok:", res.get('ok'))
print("message:", res.get('message'))
print("data count:", len(res.get('data', [])))
for item in res.get('data', []):
    print(item)

