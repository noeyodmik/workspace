"""MCP 서버 쪽 안전장치와 감사 로그."""
from __future__ import annotations

import json
import re
import secrets
import time
from pathlib import Path

from config import Settings


class GuardError(Exception):
    pass


class Guard:
    def __init__(self, s: Settings):
        self.s = s
        self._pending_delete: dict[str, tuple[str, str, float]] = {}

    def check_name(self, name: str) -> None:
        if not re.match(self.s.name_pattern, name.upper()):
            raise GuardError(f"객체명 '{name}' 은 허용 패턴({self.s.name_pattern})과 맞지 않습니다.")

    def check_package(self, package: str) -> None:
        if not package.upper().startswith(self.s.package_prefixes):
            raise GuardError(f"패키지 '{package}' 는 허용 접두사 {self.s.package_prefixes} 가 아닙니다.")

    def check_author(self, author: str) -> None:
        if not author:
            return
        allowed = {self.s.user.strip().upper()} | set(self.s.allowed_authors)
        if author.strip().upper() not in allowed:
            raise GuardError(f"작성자 '{author}' 는 수정 허용된 사용자({allowed})가 아닙니다.")

    def check_write(self, sysid: str | None, transport: str = "") -> None:
        if self.s.readonly:
            raise GuardError("읽기 전용 모드입니다 (SAP_READONLY=false 로 변경 필요).")
        if not sysid or sysid.upper() not in self.s.allowed_sysids:
            raise GuardError(f"시스템 '{sysid}' 는 쓰기 허용 SID({self.s.allowed_sysids})에 없습니다.")
        if transport and transport.strip() and not re.match(r"^[A-Z0-9]{3}K\d{6}$", transport.strip().upper()):
            raise GuardError("유효한 전송 요청 번호(예: DEVK900123)가 필요합니다.")

    # 삭제 2단계 확인
    def issue_delete_token(self, obj_type: str, name: str) -> str:
        token = secrets.token_hex(4)
        self._pending_delete[token] = (obj_type.upper(), name.upper(), time.time() + 300)
        return token

    def consume_delete_token(self, token: str, obj_type: str, name: str) -> None:
        item = self._pending_delete.pop(token, None)
        if not item or item[0] != obj_type.upper() or item[1] != name.upper() or item[2] < time.time():
            raise GuardError("삭제 확인 토큰이 없거나 만료/불일치합니다. dry_run 부터 다시 실행하세요.")


class Audit:
    def __init__(self, s: Settings):
        p = Path(s.audit_log)
        if not p.is_absolute():
            p = (Path(__file__).resolve().parent / p).resolve()
        self.path = p

    def log(self, tool: str, **fields) -> None:
        rec = {"ts": time.strftime("%Y-%m-%dT%H:%M:%S"), "tool": tool, **fields}
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self.path.open("a", encoding="utf-8") as f:
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")

    def get_logs(self, limit: int = 50, tool_name: str = "") -> list[dict]:
        """감사 로그 파일에서 최근 항목을 조회한다."""
        entries: list[dict] = []
        search_paths = [self.path]
        ws_path = Path(__file__).resolve().parent.parent / "audit.log"
        if ws_path != self.path and ws_path.exists():
            search_paths.append(ws_path)

        for p in search_paths:
            if not p.exists():
                continue
            try:
                with p.open("r", encoding="utf-8", errors="ignore") as f:
                    for line in f:
                        line = line.strip()
                        if not line:
                            continue
                        try:
                            d = json.loads(line)
                            if tool_name and d.get("tool", "").lower() != tool_name.lower():
                                continue
                            entries.append(d)
                        except Exception:
                            pass
            except Exception:
                pass

        seen = set()
        unique_entries = []
        for e in entries:
            key = (e.get("ts"), e.get("tool"), json.dumps(e, sort_keys=True))
            if key not in seen:
                seen.add(key)
                unique_entries.append(e)

        unique_entries.sort(key=lambda x: x.get("ts", ""))
        return unique_entries[-limit:] if limit > 0 else unique_entries


def backup_source(s: Settings, obj_type: str, name: str, source: str) -> str:
    d = Path(s.backup_dir) / time.strftime("%Y%m%d_%H%M%S")
    d.mkdir(parents=True, exist_ok=True)
    p = d / f"{name.lower()}.{obj_type.lower()}.abap"
    p.write_text(source, encoding="utf-8")
    return str(p)


def mask_amount(amount: float | int | str, mask: bool = True) -> str | float:
    """급여 금액을 마스킹한다 (기본값 True)."""
    if not mask:
        try:
            return float(amount)
        except (ValueError, TypeError):
            return amount
    return "***,***"


def mask_personal_id(val: str, mask: bool = True) -> str:
    """주민등록번호 등 식별 번호를 뒤 6자리 마스킹 처리한다."""
    if not mask or not val:
        return val
    s = str(val).strip()
    if len(s) >= 13:
        return s[:6] + "-*******"
    elif len(s) > 4:
        return s[:len(s) - 4] + "****"
    return "****"
