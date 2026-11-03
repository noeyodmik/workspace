import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
p2 = b.read_table("PA0002", where_clause="PERNR = '00000053'")
print("PA0002 ok:", p2.ok, p2.message)
if p2.ok and p2.data:
    print("PA0002 rows:", len(p2.data.get("rows", [])))
    print(p2.data.get("rows"))

p539 = b.read_table("PA0539", where_clause="PERNR = '00000053'")
print("PA0539 ok:", p539.ok, p539.message)
if p539.ok and p539.data:
    print("PA0539 rows:", len(p539.data.get("rows", [])))
    print(p539.data.get("rows"))
