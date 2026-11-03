import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

prog_name = "Z_INS_PA0539_DATA"
code_lines = [
    {"LINE": "REPORT z_ins_pa0539_data."},
    {"LINE": ""},
    {"LINE": "DATA: ls_pa0539 TYPE pa0539,"},
    {"LINE": "      ls_pa0540 TYPE pa0540."},
    {"LINE": ""},
    {"LINE": "CLEAR ls_pa0539."},
    {"LINE": "ls_pa0539-mandt = sy-mandt."},
    {"LINE": "ls_pa0539-pernr = '00000053'."},
    {"LINE": "ls_pa0539-subty = space."},
    {"LINE": "ls_pa0539-objps = space."},
    {"LINE": "ls_pa0539-sprps = space."},
    {"LINE": "ls_pa0539-begda = '20200101'."},
    {"LINE": "ls_pa0539-endda = '99991231'."},
    {"LINE": "ls_pa0539-seqnr = '000'."},
    {"LINE": "ls_pa0539-aedtm = sy-datum."},
    {"LINE": "ls_pa0539-uname = sy-uname."},
    {"LINE": "ls_pa0539-regno = '9011111111111'."},
    {"LINE": "ls_pa0539-lnmhg = '김'."},
    {"LINE": "ls_pa0539-fnmhg = '검증'."},
    {"LINE": "ls_pa0539-hshld = '1'."},
    {"LINE": "INSERT pa0539 FROM ls_pa0539."},
    {"LINE": ""},
    {"LINE": "CLEAR ls_pa0540."},
    {"LINE": "ls_pa0540-mandt = sy-mandt."},
    {"LINE": "ls_pa0540-pernr = '00000053'."},
    {"LINE": "ls_pa0540-subty = space."},
    {"LINE": "ls_pa0540-objps = space."},
    {"LINE": "ls_pa0540-sprps = space."},
    {"LINE": "ls_pa0540-begda = '20200101'."},
    {"LINE": "ls_pa0540-endda = '99991231'."},
    {"LINE": "ls_pa0540-seqnr = '000'."},
    {"LINE": "ls_pa0540-aedtm = sy-datum."},
    {"LINE": "ls_pa0540-uname = sy-uname."},
    {"LINE": "ls_pa0540-regno = '9011111111111'."},
    {"LINE": "ls_pa0540-lnmhg = '김'."},
    {"LINE": "ls_pa0540-fnmhg = '검증'."},
    {"LINE": "ls_pa0540-famid = '1'."},
    {"LINE": "INSERT pa0540 FROM ls_pa0540."},
    {"LINE": ""},
    {"LINE": "COMMIT WORK."},
    {"LINE": "WRITE: / 'INSERT COMPLETE - PA0539 and PA0540 created!'."}
]

with b._conn() as c:
    try:
        r = c.call("RPY_PROGRAM_INSERT",
                   PROGRAM_NAME=prog_name,
                   TITLE_STRING="Insert PA0539 & PA0540 for Pernr 53",
                   PROGRAM_TYPE="1",
                   DEVELOPMENT_CLASS="$TMP",
                   SUPPRESS_DIALOG="X",
                   SAVE_INACTIVE=" ",
                   SOURCE_EXTENDED=code_lines)
        print("RPY_PROGRAM_INSERT result:", r)
    except Exception as e:
        print("RPY_PROGRAM_INSERT error:", e)

# Check TRDIR and TADIR
r2 = b.read_table("TRDIR", where_clause=f"NAME = '{prog_name}'", fields=["NAME", "SUBC", "CNAM", "CDAT"])
print("TRDIR:", r2.data.get("rows"))
