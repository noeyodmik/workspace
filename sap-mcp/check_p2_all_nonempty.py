import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
fields_res = b.read_table("DD03L", where_clause="TABNAME = 'PA0002'", fields=["FIELDNAME"])
all_fields = [r["FIELDNAME"] for r in fields_res.data.get("rows", []) if not r["FIELDNAME"].startswith(".")]

non_empty = {}
chunk_size = 8
for i in range(0, len(all_fields), chunk_size):
    chunk = all_fields[i:i+chunk_size]
    try:
        r = b.read_table("PA0002", where_clause="PERNR = '00000053'", fields=chunk)
        if r.data and r.data.get("rows"):
            for k, v in r.data["rows"][0].items():
                if v and v.strip():
                    non_empty[k] = v.strip()
    except Exception as e:
        pass

print("PA0002 non-empty values:")
print(json.dumps(non_empty, ensure_ascii=False, indent=2))
