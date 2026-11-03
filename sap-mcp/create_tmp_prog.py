import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

prog_name = "Z_INS_PA0539_TMP"

# 1. Create in $TMP
cr = b.create_object("PROG", prog_name, package="$TMP", description="Insert PA0539 in TMP", transport="")
print("Create in $TMP:", cr.ok, cr.message)

# 2. Update source
prog_source = """REPORT z_ins_pa0539_tmp.

DATA: ls_pa0539 TYPE pa0539,
      ls_pa0540 TYPE pa0540.

CLEAR ls_pa0539.
ls_pa0539-mandt = sy-mandt.
ls_pa0539-pernr = '00000053'.
ls_pa0539-subty = space.
ls_pa0539-objps = space.
ls_pa0539-sprps = space.
ls_pa0539-begda = '20200101'.
ls_pa0539-endda = '99991231'.
ls_pa0539-seqnr = '000'.
ls_pa0539-aedtm = sy-datum.
ls_pa0539-uname = sy-uname.
ls_pa0539-regno = '9011111111111'.
ls_pa0539-lnmhg = '김'.
ls_pa0539-fnmhg = '검증'.
ls_pa0539-hshld = '1'.

INSERT pa0539 FROM ls_pa0539.

CLEAR ls_pa0540.
ls_pa0540-mandt = sy-mandt.
ls_pa0540-pernr = '00000053'.
ls_pa0540-subty = space.
ls_pa0540-objps = space.
ls_pa0540-sprps = space.
ls_pa0540-begda = '20200101'.
ls_pa0540-endda = '99991231'.
ls_pa0540-seqnr = '000'.
ls_pa0540-aedtm = sy-datum.
ls_pa0540-uname = sy-uname.
ls_pa0540-regno = '9011111111111'.
ls_pa0540-lnmhg = '김'.
ls_pa0540-fnmhg = '검증'.
ls_pa0540-famid = '1'.

INSERT pa0540 FROM ls_pa0540.

COMMIT WORK.
WRITE: / 'INSERT COMPLETE'.
"""

up = b.update_source("PROG", prog_name, prog_source, transport="")
print("Update in $TMP:", up.ok, up.message)

act = b.activate_object("PROG", prog_name)
print("Activate in $TMP:", act.ok, act.message)
