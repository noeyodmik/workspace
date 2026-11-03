import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

with b._conn() as c:
    # 1. Read LZMCPU12
    r_read = c.call("RPY_INCLUDE_READ", INCLUDE_NAME="LZMCPU12")
    raw_source = [row["LINE"] for row in r_read.get("SOURCE", [])]
    full_text = "\n".join(raw_source)
    print("Read LZMCPU12 lines:", len(raw_source))

    # 2. Target to replace
    old_target = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  IF lv_inper IS NOT INITIAL.
    DATA: lv_pabrj TYPE qppnp-pabrj,
          lv_pabrp TYPE qppnp-pabrp.
    IF strlen( lv_inper ) >= 6.
      lv_pabrj = lv_inper+0(4).
      lv_pabrp = lv_inper+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper ) TO lt_rsparams.
  ENDIF."""

    new_replacement = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  DATA: lv_inper_str TYPE string,
        lv_pabrj     TYPE qppnp-pabrj,
        lv_pabrp     TYPE qppnp-pabrp.
  lv_inper_str = iv_inper.
  IF lv_inper_str IS NOT INITIAL.
    IF strlen( lv_inper_str ) >= 6.
      lv_pabrj = lv_inper_str(4).
      lv_pabrp = lv_inper_str+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper_str ) TO lt_rsparams.
  ENDIF."""

    if old_target not in full_text:
        print("Exact old_target not found! Searching partial...")
        for i, line in enumerate(raw_source):
            if "lv_inper+0(4)" in line or "strlen( lv_inper )" in line:
                print(f"L{i+1}: {line}")
        # Try replacing lv_inper+0(4) directly
        full_text = full_text.replace("lv_pabrj = lv_inper+0(4).", "lv_pabrj = lv_inper(4).")
    else:
        full_text = full_text.replace(old_target, new_replacement)

    new_lines = [{"LINE": l} for l in full_text.splitlines()]

    # 3. Update LZMCPU12
    r_up = c.call("RPY_INCLUDE_UPDATE",
                  INCLUDE_NAME="LZMCPU12",
                  TRANSPORT_NUMBER="EA3K900019",
                  SAVE_INACTIVE=" ",
                  SOURCE_EXTENDED=new_lines)
    print("RPY_INCLUDE_UPDATE completed successfully!")
