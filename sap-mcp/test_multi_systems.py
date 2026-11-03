import io
import json
import sys
import server

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

print("=== 1. list_systems() ===")
print(json.dumps(server.list_systems(), ensure_ascii=False, indent=2))

print("\n=== 2. ping(system='EA3') ===")
print(json.dumps(server.ping(system="EA3"), ensure_ascii=False, indent=2))

print("\n=== 3. ping(system='GY7') ===")
print(json.dumps(server.ping(system="GY7"), ensure_ascii=False, indent=2))

print("\n=== 4. switch_system('GY7') ===")
sw_gy7 = server.switch_system("GY7")
print(json.dumps(sw_gy7, ensure_ascii=False, indent=2))

print("\n=== 5. read_table('T001') on active system (GY7) ===")
res_gy7 = server.read_table("T001", fields=["BUKRS", "BUTXT"], max_rows=3)
print("GY7 T001 rows:", res_gy7.get("data", {}).get("rows"))

print("\n=== 6. switch_system('EA3') ===")
sw_ea3 = server.switch_system("EA3")
print(json.dumps(sw_ea3, ensure_ascii=False, indent=2))

print("\n=== 7. read_table('T001') on active system (EA3) ===")
res_ea3 = server.read_table("T001", fields=["BUKRS", "BUTXT"], max_rows=3)
print("EA3 T001 rows:", res_ea3.get("data", {}).get("rows"))
