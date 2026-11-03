import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    print("Step 1: Reading current LZMCPU11...")
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

    # AND RETURN. 앞에 EXPORTING LIST TO MEMORY 추가
    new_lines = []
    modified = False
    for line in orig_lines:
        if 'AND RETURN.' in line:
            new_lines.append('        EXPORTING LIST TO MEMORY')
            new_lines.append(line)
            modified = True
        else:
            new_lines.append(line)

    print(f"Modified: {modified}")
    if not modified:
        print("Could not find AND RETURN.")
        return

    print("Step 2: Updating LZMCPU11 with EXPORTING LIST TO MEMORY...")
    source_ext = [{'LINE': l} for l in new_lines]
    c.call('RPY_INCLUDE_UPDATE',
           INCLUDE_NAME='LZMCPU11',
           TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ',
           SOURCE_EXTENDED=source_ext)
    print("RPY_INCLUDE_UPDATE OK.")

    # 활성화
    try:
        act = c.call('Z_MCP_ACTIVATE', IV_TYPE='FUNC', IV_NAME='Z_MCP_GET_REPLICATION_LOG')
        print("Activate result:", act.get('EV_OK'), act.get('EV_MESSAGE'))
    except Exception as e:
        print("Activate notice:", e)

if __name__ == "__main__":
    main()
