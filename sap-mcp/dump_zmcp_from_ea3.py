import io
import json
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c_ea3 = Connection(**config.Settings('EA3').rfc_params())

# 1. ZMCP 함수 목록
res_fms = c_ea3.call('RFC_FUNCTION_SEARCH', FUNCNAME='Z_MCP_*')
func_names = [f['FUNCNAME'] for f in res_fms.get('FUNCTIONS', [])]
print(f"EA3 Z_MCP Functions ({len(func_names)}):", func_names)

zmcp_data = {
    "includes": {},
    "functions": {}
}

# 2. LZMCPTOP 읽기
try:
    r_top = c_ea3.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPTOP')
    zmcp_data["includes"]["LZMCPTOP"] = [l['LINE'] for l in r_top.get('SOURCE_EXTENDED', [])]
    print(f"Read LZMCPTOP: {len(zmcp_data['includes']['LZMCPTOP'])} lines")
except Exception as e:
    print("Read LZMCPTOP error:", e)

# 3. 각 함수 모듈의 인터페이스 및 소스 읽기
for fn in sorted(func_names):
    fn_info = {}
    try:
        # 인터페이스
        r_if = c_ea3.call('RFC_GET_FUNCTION_INTERFACE', FUNCNAME=fn)
        fn_info["params"] = r_if.get('PARAMS', [])
        fn_info["resumable_exceptions"] = r_if.get('RESUMABLE_EXCEPTIONS', [])
        fn_info["remote_call"] = r_if.get('REMOTE_CALL', 'X')

        # TFDIR 에서 INCLUDE 명칭 확인
        r_tf = c_ea3.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR',
                          OPTIONS=[{'TEXT': f"FUNCNAME = '{fn}'"}],
                          FIELDS=[{'FIELDNAME': 'INCLUDE'}])
        inc_sfx = r_tf.get('DATA', [{}])[0].get('WA', '').strip()
        inc_name = f"LZMCPU{inc_sfx}" if inc_sfx else ""
        fn_info["include"] = inc_name

        if inc_name:
            r_src = c_ea3.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc_name)
            fn_info["source"] = [l['LINE'] for l in r_src.get('SOURCE_EXTENDED', [])]
            print(f"Read {fn} ({inc_name}): {len(fn_info['source'])} lines, {len(fn_info['params'])} params")
        else:
            print(f"Warning: No include found for {fn}")

        zmcp_data["functions"][fn] = fn_info
    except Exception as e:
        print(f"Error reading {fn}:", e)

with open("zmcp_exported_data.json", "w", encoding="utf-8") as f:
    json.dump(zmcp_data, f, ensure_ascii=False, indent=2)

print(f"\nSuccessfully exported ZMCP data to zmcp_exported_data.json!")
