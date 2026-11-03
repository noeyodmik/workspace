import io, sys
with open(r"c:\Users\sapin\Desktop\Workspace\sap-mcp\server.py", "r", encoding="utf-8") as f:
    lines = f.readlines()

for idx, l in enumerate(lines, 1):
    if "@mcp.tool" in l or "def " in l:
        print(f"{idx:03d}: {l.strip()}")

