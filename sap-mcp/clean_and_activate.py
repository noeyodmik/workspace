import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with open("current_in_sap.txt", "r", encoding="utf-8") as f:
    src = f.read()

# 1. Clean up declarations: remove inner DATAs
src = src.replace("""  DATA: lv_test_curr TYPE t500c-waers,
        lv_subrc_c   TYPE sy-subrc.""", "")

src = src.replace("""    DATA: ls_chk539 TYPE pa0539,
          ls_chk540 TYPE pa0540.""", "")

src = src.replace("""  DATA: lv_inper_str TYPE string,
        lv_pabrj     TYPE qppnp-pabrj,
        lv_pabrp     TYPE qppnp-pabrp.""", "")

# 2. Add all declarations at the top
old_top_decl = """        lv_has_error    TYPE abap_bool VALUE abap_false,
        lv_err_msg      TYPE string."""

new_top_decl = """        lv_has_error    TYPE abap_bool VALUE abap_false,
        lv_err_msg      TYPE string,
        lv_test_curr    TYPE t500c-waers,
        lv_subrc_c      TYPE sy-subrc,
        lv_inper_str    TYPE string,
        lv_pabrj        TYPE qppnp-pabrj,
        lv_pabrp        TYPE qppnp-pabrp,
        ls_chk539       TYPE pa0539,
        ls_chk540       TYPE pa0540."""

src = src.replace(old_top_decl, new_top_decl)

transport = "EA3K900019"
up = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", src, transport)
print("Update:", up.ok, up.message)

act = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
print("Activate FUNC:", act.ok, act.message)
