import os

for root, dirs, files in os.walk(r"c:\Users\sapin\Desktop\Workspace\sap-mcp"):
    for f in files:
        if f.endswith(".py"):
            p = os.path.join(root, f)
            with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                txt = fp.read()
                if "audit.log" in txt or "audit" in txt:
                    print(f"Audit referenced in {p}")

