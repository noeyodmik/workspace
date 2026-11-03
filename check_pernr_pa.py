import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

def check_pernr(pernr):
    print(f"\n==================== CHECKING PERNR {pernr} ====================")
    # PA0000
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0000', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'},
                       {'FIELDNAME': 'MASSN'}, {'FIELDNAME': 'MASSG'}, {'FIELDNAME': 'STAT2'}])
    print(f"PA0000 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0001
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0001', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'},
                       {'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'WERKS'}, {'FIELDNAME': 'PERSG'},
                       {'FIELDNAME': 'PERSK'}, {'FIELDNAME': 'PLANS'}])
    print(f"PA0001 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0002
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0002', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'NACHN'}, {'FIELDNAME': 'VORNA'},
                       {'FIELDNAME': 'GBDAT'}, {'FIELDNAME': 'GESCH'}, {'FIELDNAME': 'NATIO'}])
    print(f"PA0002 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0006
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0006', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'},
                       {'FIELDNAME': 'STRAS'}, {'FIELDNAME': 'LOCAT'}, {'FIELDNAME': 'LAND1'}])
    print(f"PA0006 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0008
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0008', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'},
                       {'FIELDNAME': 'TRFAR'}, {'FIELDNAME': 'TRFGB'}, {'FIELDNAME': 'TRFGR'},
                       {'FIELDNAME': 'WAERS'}, {'FIELDNAME': 'LGA01'}, {'FIELDNAME': 'BET01'}, {'FIELDNAME': 'ANSAL'}])
    print(f"PA0008 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0009
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0009', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'},
                       {'FIELDNAME': 'BANKL'}, {'FIELDNAME': 'BANKN'}, {'FIELDNAME': 'ZLSCH'}])
    print(f"PA0009 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0105
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0105', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'},
                       {'FIELDNAME': 'USRID'}, {'FIELDNAME': 'USRID_LONG'}])
    print(f"PA0105 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

    # PA0539
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0539', DELIMITER='|',
               OPTIONS=[{'TEXT': f"PERNR = '{pernr}'"}],
               FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'},
                       {'FIELDNAME': 'CTXTY'}, {'FIELDNAME': 'CTTYP'}])
    print(f"PA0539 ({len(r['DATA'])}):")
    for d in r['DATA']: print(" ", d['WA'])

check_pernr('00000063')
check_pernr('00000064')
check_pernr('00000065')
c.close()
