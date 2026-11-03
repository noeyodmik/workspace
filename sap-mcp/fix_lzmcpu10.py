import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU10')
    source_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    
    new_lines = []
    replaced = False
    for line in source_lines:
        if 'LV_INPER  TYPE INPER,' in line:
            new_lines.append(line.replace('LV_INPER  TYPE INPER,', 'LV_INPER  TYPE IPERI,'))
            replaced = True
        elif 'LV_INPER TYPE INPER,' in line:
            new_lines.append(line.replace('LV_INPER TYPE INPER,', 'LV_INPER TYPE IPERI,'))
            replaced = True
        else:
            new_lines.append(line)
            
    print(f'Replaced: {replaced}')
    if not replaced:
        print('Could not find LV_INPER TYPE INPER')
        return

    # RPY_INCLUDE_UPDATE 호출
    source_ext = [{'LINE': l} for l in new_lines]
    upd = c.call('RPY_INCLUDE_UPDATE',
                 INCLUDE_NAME='LZMCPU10',
                 TRANSPORT_NUMBER='EA3K900019',
                 SAVE_INACTIVE=' ',
                 SOURCE_EXTENDED=source_ext)
    print('RPY_INCLUDE_UPDATE LZMCPU10 completed successfully!')

if __name__ == "__main__":
    main()
