import os, stat

workspace_dir = r"c:\Users\sapin\Desktop\Workspace"
for root, dirs, files in os.walk(workspace_dir):
    for f in files:
        if "audit" in f.lower() or "log" in f.lower():
            p = os.path.join(root, f)
            if "audit" in f.lower():
                try:
                    st = os.stat(p)
                    mode = stat.filemode(st.st_mode)
                    size = st.st_size
                    print(f"File: {p}")
                    print(f"  Size: {size} bytes")
                    print(f"  Mode: {mode}")
                    print(f"  Read-only attr: {bool(st.st_file_attributes & stat.FILE_ATTRIBUTE_READONLY) if hasattr(stat, 'FILE_ATTRIBUTE_READONLY') else 'N/A'}")
                except Exception as e:
                    print(f"File: {p} - Error: {e}")

# Also check sap-mcp or other directories
for p_dir in [r"c:\Users\sapin\Desktop\Workspace\sap-mcp", r"C:\Users\sapin\.gemini\antigravity"]:
    for root, dirs, files in os.walk(p_dir):
        for f in files:
            if "audit.log" in f.lower():
                p = os.path.join(root, f)
                try:
                    st = os.stat(p)
                    print(f"Found in {p_dir}: {p}, size={st.st_size}")
                except Exception as e:
                    print(f"Err {p}: {e}")

