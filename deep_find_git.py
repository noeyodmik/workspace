import os

search_roots = [
    r"C:\Program Files",
    r"C:\Program Files (x86)",
    os.path.expandvars(r"%LOCALAPPDATA%"),
    os.path.expandvars(r"%APPDATA%"),
    r"C:\tools",
    r"C:\Git"
]

found = []
for root_dir in search_roots:
    if not os.path.exists(root_dir):
        continue
    for root, dirs, files in os.walk(root_dir):
        # Avoid deep node_modules or caches
        if "node_modules" in root or "site-packages" in root or "Cache" in root or "AppData\\Local\\Microsoft" in root:
            continue
        if "git.exe" in files:
            p = os.path.join(root, "git.exe")
            print("Found:", p)
            found.append(p)
            if len(found) >= 5:
                break
    if found:
        break

if not found:
    print("git.exe not found in common locations.")

