import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    # 셀렉션 텍스트 (TRDIRT 또는 D344T 등)
    # RPY_PROGRAM_READ로 텍스트 읽기
    try:
        r = b._call("READ_SELECTION_TEXTS", PROGRAM="HKRCALC0", LANGUAGE="3")
        texts = r.get("SELECTION_TEXTS", [])
        print("HKRCALC0 Selection Texts (KO):")
        for t in texts:
            print(f"  {t.get('NAME')}: {t.get('KIND')} | {t.get('TEXT')}")
    except Exception as e:
        print("READ_SELECTION_TEXTS err:", e)

if __name__ == "__main__":
    main()
