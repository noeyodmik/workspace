import winreg
import os

mingit_cmd = os.path.expandvars(r"%LOCALAPPDATA%\Programs\MinGit\cmd")

# Open Environment key in HKCU
key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Environment", 0, winreg.KEY_READ | winreg.KEY_WRITE)
try:
    val, typ = winreg.QueryValueEx(key, "Path")
except FileNotFoundError:
    val, typ = "", winreg.REG_EXPAND_SZ

paths = val.split(";") if val else []
if mingit_cmd not in paths:
    paths.append(mingit_cmd)
    new_val = ";".join(paths)
    winreg.SetValueEx(key, "Path", 0, typ, new_val)
    print("Added MinGit to HKCU\\Environment\\Path:", mingit_cmd)
else:
    print("MinGit already in HKCU\\Environment\\Path")
winreg.CloseKey(key)

