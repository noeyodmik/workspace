import urllib.request
import json
import zipfile
import os

target_dir = os.path.expandvars(r"%LOCALAPPDATA%\Programs\MinGit")
os.makedirs(target_dir, exist_ok=True)

# Query latest release of git-for-windows
api_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"
req = urllib.request.Request(api_url, headers={"User-Agent": "Python"})

try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode())
    
    download_url = None
    for asset in data.get("assets", []):
        name = asset.get("name", "")
        if name.startswith("MinGit-") and name.endswith("-64-bit.zip") and "busybox" not in name:
            download_url = asset.get("browser_download_url")
            print("Found asset:", name, "url:", download_url)
            break
            
    if download_url:
        zip_path = os.path.join(target_dir, "mingit.zip")
        print("Downloading to:", zip_path)
        urllib.request.urlretrieve(download_url, zip_path)
        print("Extracting...")
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(target_dir)
        os.remove(zip_path)
        git_exe = os.path.join(target_dir, "cmd", "git.exe")
        print("Extracted successfully! git.exe exists:", os.path.exists(git_exe))
    else:
        print("MinGit asset not found in latest release.")
except Exception as e:
    print("Error:", e)
