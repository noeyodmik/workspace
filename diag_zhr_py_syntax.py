import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
OUT = r"c:\Users\sapin\Desktop\Workspace\out_diag_genrep.txt"
BACKUP = r"c:\Users\sapin\Desktop\Workspace\LZMCPU11_BACKUP_DIAG.abap"
TR = 'EA3K900019'

c = Connection(**Settings("EA3").rfc_params())

def pool(cls):
    return cls.ljust(30, '=') + 'CP'

TARGETS = [pool('ZHR_PY'),
           pool('HRSFEC_B_CE_CHANGE_IT0002'),
           pool('HRSFEC_B_CE_CHANGE_IT0008'),
           pool('HRSFEC_B_CE_CHANGE_IT0105_EMA')]

appends = "\n".join(f"    APPEND '{t}' TO lt_dg." for t in TARGETS)

SNIPPET = """  IF iv_ext_id = 'DIAG_GENREP'.
    DATA: lt_dg      TYPE STANDARD TABLE OF program WITH EMPTY KEY,
          lv_dg_prog TYPE program,
          lv_dg_msg  TYPE string,
          lv_dg_inc  TYPE program,
          lv_dg_line TYPE i,
          lv_dg_word TYPE string,
          lv_dg_rc   TYPE sy-subrc,
          lv_dg_res  TYPE string.
""" + appends + """
    LOOP AT lt_dg INTO lv_dg_prog.
      CLEAR: lv_dg_msg, lv_dg_inc, lv_dg_line, lv_dg_word.
      GENERATE REPORT lv_dg_prog MESSAGE lv_dg_msg INCLUDE lv_dg_inc LINE lv_dg_line WORD lv_dg_word.
      lv_dg_rc = sy-subrc.
      lv_dg_res = lv_dg_res && |{ lv_dg_prog } rc={ lv_dg_rc } inc={ lv_dg_inc } line={ lv_dg_line } word={ lv_dg_word } msg={ lv_dg_msg } ;; |.
    ENDLOOP.
    ev_ok = 'X'.
    ev_message = lv_dg_res.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print("orig lines:", len(orig_lines))
if len(orig_lines) != 199:
    print("ABORT: LZMCPU11 is not the expected 199-line original")
    sys.exit(1)

with open(BACKUP, "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(orig_lines))
print("backup written:", BACKUP)

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + SNIPPET.splitlines() + orig_lines[31:])]
lines_out = []
try:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER=TR,
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)
    r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='DIAG_GENREP')
    lines_out.append(f"EV_OK={r.get('EV_OK')}")
    for part in str(r.get('EV_MESSAGE', '')).split(';;'):
        lines_out.append(part.strip())
except Exception as e:
    lines_out.append("ERROR: " + str(e)[:1500])
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER=TR,
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    lines_out.append(f"Restored identical: {back == orig_lines} ({len(back)} lines)")

txt = "\n".join(lines_out)
print(txt)
with open(OUT, "w", encoding="utf-8") as f:
    f.write(txt)
c.close()
