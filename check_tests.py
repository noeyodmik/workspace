import os

p = r"c:\Users\sapin\Desktop\Workspace\sap-mcp\tests"
if os.path.exists(p):
    for f in os.listdir(p):
        print(f)
else:
    print("No tests dir")

