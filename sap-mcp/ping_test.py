"""단계 0: SAProuter 경유 RFC 접속 검증. 사용법: python ping_test.py"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from backends.rfc_backend import RfcBackend  # noqa: E402
from config import Settings  # noqa: E402

s = Settings()
miss = s.missing()
if miss:
    sys.exit(f"[X] .env 에 값이 없습니다: {', '.join(miss)}")

print(f"saprouter={s.saprouter or '(없음)'} ashost={s.ashost} sysnr={s.sysnr} client={s.client}")
b = RfcBackend(s)
for label, fn in (("RFC_PING", b.ping), ("RFC_SYSTEM_INFO", b.system_info)):
    r = fn()
    print(f"[{'OK' if r.ok else 'FAIL'}] {label}: {r.message}")
    if r.data:
        for k, v in r.data.items():
            print(f"      {k}: {v}")
