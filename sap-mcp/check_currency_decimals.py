import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

# 1. Check TCURX for KRW
tcurx = b.read_table("TCURX", where_clause="CURRKEY = 'KRW'")
print("TCURX KRW:", tcurx.data.get("rows") if tcurx.data else tcurx.message)

# 2. Check PA0008 for 53
p8 = b.read_table("PA0008", where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA", "WAERS", "BET01", "LGART", "LGA01", "TRFGR", "TRFST"])
print("PA0008 53:", p8.data.get("rows") if p8.data else p8.message)
