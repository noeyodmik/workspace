import io
import json
import sys
import server

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test_tool(title, res):
    ok = res.get("ok")
    msg = res.get("message", "")
    print(f"  [{'OK' if ok else 'FAIL'}] {title:42s}: {msg}")
    if not ok:
        print(f"         Details: {res}")
    return res

print("=== Additional Verification on GY7 ===")
test_tool("get_source('INCL', 'LZMCPU02')", server.get_source("INCL", "LZMCPU02", system="GY7"))
test_tool("check_payroll_control_record('AA')", server.check_payroll_control_record(abkrs="AA", system="GY7"))

print("\n=== Testing Write/CRUD Lifecycle on GY7 ($TMP with TR format) ===")
tmp_prog = "Z_MCP_GY7_TEST_TMP"
tr_dummy = "GY7K901907"
test_tool("create_object(PROG, $TMP)", server.create_object("PROG", tmp_prog, "$TMP", "MCP GY7 CRUD Test", tr_dummy, system="GY7"))
test_tool("get_source(PROG, Z_MCP_GY7_TEST_TMP)", server.get_source("PROG", tmp_prog, system="GY7"))
test_tool("update_source(PROG)", server.update_source("PROG", tmp_prog, f"REPORT {tmp_prog.lower()}.\nWRITE 'Hello GY7 MCP'.", tr_dummy, system="GY7"))
test_tool("activate_object(PROG)", server.activate_object("PROG", tmp_prog, system="GY7"))
dry = test_tool("delete_object(dry_run=True)", server.delete_object("PROG", tmp_prog, tr_dummy, dry_run=True, system="GY7"))
if dry.get("ok") and dry.get("confirm_token"):
    test_tool("delete_object(dry_run=False)", server.delete_object("PROG", tmp_prog, tr_dummy, dry_run=False, confirm_token=dry["confirm_token"], system="GY7"))

# Z_TEST_MCP_SETUP (어제 테스트로 생성된 임시 프로그램)도 깔끔히 정리 확인
r_chk = server.get_source("PROG", "Z_TEST_MCP_SETUP", system="GY7")
if r_chk.get("ok"):
    dry2 = server.delete_object("PROG", "Z_TEST_MCP_SETUP", tr_dummy, dry_run=True, system="GY7")
    if dry2.get("ok") and dry2.get("confirm_token"):
        test_tool("Clean up Z_TEST_MCP_SETUP", server.delete_object("PROG", "Z_TEST_MCP_SETUP", tr_dummy, dry_run=False, confirm_token=dry2["confirm_token"], system="GY7"))
