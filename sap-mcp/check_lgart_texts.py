import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
lgarts = ["/101", "/104", "/105", "/108", "/109", "/121", "/131", "/140", "/301", "/302", "/3T1", "/4MC", "/4PC", "/4PE", "/4PR", "/4UC", "/4UE", "/4UR", "/4WD", "/550", "/560", "/565", "/700", "/840", "/844", "/845", "/001", "/003", "1010"]

r = b.read_table("T512T", where_clause="MOLGA = '41' AND SPRSL = '3'", fields=["LGART", "LGTXT"], max_rows=500)
t_map = {}
for row in r.data.get("rows", []):
    t_map[row["LGART"]] = row["LGTXT"].strip()

print("Wage type text mappings:")
for lg in lgarts:
    print(f"'{lg}': '{t_map.get(lg, '')}',")
