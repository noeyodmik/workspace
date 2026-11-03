import os

candidates = [
    r"C:\Program Files\Git\cmd\git.exe",
    r"C:\Program Files\Git\bin\git.exe",
    r"C:\Program Files (x86)\Git\cmd\git.exe",
    os.path.expandvars(r"%LOCALAPPDATA%\Programs\Git\cmd\git.exe"),
    os.path.expandvars(r"%USERPROFILE%\AppData\Local\Programs\Git\cmd\git.exe"),
    os.path.expandvars(r"%LOCALAPPDATA%\GitHubDesktop\app-*\resources\app\git\cmd\git.exe"),
]

found = []
for c in candidates:
    if "*" in c:
        import glob
        for g in glob.glob(c):
            if os.path.exists(g):
                found.append(g)
    else:
        if os.path.exists(c):
            found.append(c)

print("Found git at:", found)
