import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def show_fields(tab):
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
               OPTIONS=[{'TEXT': f"TABNAME = '{tab}'"}],
               FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'POSITION'}])
    print(f"\nFields of {tab}:")
    for d in r['DATA']:
        print(d['WA'].strip())

show_fields('T549B')
show_fields('T549D')
c.close()

