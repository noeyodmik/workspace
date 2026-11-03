import os

workspace_dir = r"c:\Users\sapin\Desktop\Workspace"
for root, dirs, files in os.walk(workspace_dir):
    if ".git" in root or ".venv" in root:
        continue
    for f in files:
        if f.endswith(".py"):
            path = os.path.join(root, f)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as fp:
                    content = fp.read()
                    if "Z_MCP" in content:
                        print(f"Found in {f}")
            except Exception as e:
                pass

