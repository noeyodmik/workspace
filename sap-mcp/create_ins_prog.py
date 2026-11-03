import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
transport = "EA3K900019"

# 1. Create program Z_INS_PA0539
cr = b.create_object("PROG", "Z_INS_PA0539", package="ZHRD", description="Insert PA0539 for 53", transport=transport)
print("Create PROG:", cr.ok, cr.message)

# 2. Update source
prog_source = """REPORT z_ins_pa0539.

DATA: ls_pa0539 TYPE pa0539.

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
IF sy-subrc = 0.
  COMMIT WORK.
  WRITE: / 'PA0539 inserted successfully!'.
ELSE.
  WRITE: / 'Insert failed, sy-subrc =', sy-subrc.
ENDIF.
"""

up = b.update_source("PROG", "Z_INS_PA0539", prog_source, transport=transport)
print("Update PROG:", up.ok, up.message)

# 3. Activate PROG
act = b.activate_object("PROG", "Z_INS_PA0539")
print("Activate PROG:", act.ok, act.message)
