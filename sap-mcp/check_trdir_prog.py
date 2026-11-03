import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r1 = b.read_table('TADIR', where_clause="OBJ_NAME LIKE 'Z_INS_PA%'", fields=['OBJECT', 'OBJ_NAME', 'DEVCLASS', 'AUTHOR'])
print('TADIR:', r1.data.get('rows'))
r2 = b.read_table('TRDIR', where_clause="NAME LIKE 'Z_INS_PA%'", fields=['NAME', 'SUBC', 'CNAM'])
print('TRDIR:', r2.data.get('rows'))
