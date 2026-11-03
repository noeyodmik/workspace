import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    chk = b.check_function_module("HR_INFOTYPE_OPERATION")
    print("HR_INFOTYPE_OPERATION rfc:", chk.ok)

if __name__ == "__main__":
    main()
