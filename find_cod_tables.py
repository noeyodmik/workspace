import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for pat in ["DDTEXT LIKE '%코드 값 매핑%'", "TABNAME LIKE '%COD%' AND TABNAME LIKE '%HRSFEC%'", "TABNAME LIKE 'T%COD%MAP%'"]:
    try:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD02T',
                   OPTIONS=[{'TEXT': pat + " AND DDLANGUAGE = '3'"}] if 'DDTEXT' in pat else [{'TEXT': pat}],
                   FIELDS=[{'FIELDNAME': 'TABNAME'}, {'FIELDNAME': 'DDTEXT'}])
        print('==', pat)
        for x in r['DATA'][:30]:
            print(x['WA'])
    except Exception as e:
        print('ERR', pat, e)
