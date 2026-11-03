"""환경변수 기반 설정. 비밀번호는 .env 에만 두고 git 에 올리지 않는다."""
from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

try:
    from dotenv import load_dotenv

    load_dotenv(Path(__file__).resolve().parent.parent / ".env")
    # 워크스페이스 루트 및 현재 디렉토리 둘 다 지원
    load_dotenv(Path(__file__).resolve().parent / ".env")
except ImportError:  # python-dotenv 미설치 시 OS 환경변수만 사용
    pass


def _register_nwrfc_sdk() -> None:
    """Windows: Python 3.8+ 는 PATH 만으로 SDK DLL을 못 찾으므로 명시적으로 등록한다."""
    if not hasattr(os, "add_dll_directory"):
        return
    candidates = [os.getenv("SAP_NWRFC_LIB", "")] + os.environ.get("PATH", "").split(os.pathsep)
    for d in candidates:
        if d and (Path(d) / "sapnwrfc.dll").exists():
            os.add_dll_directory(d)
            return


_register_nwrfc_sdk()


def _b(val: str, default: str = "true") -> bool:
    return val.strip().lower() in ("1", "true", "yes", "y")


def list_available_systems() -> list[str]:
    """환경변수에 정의된 사용 가능한 SAP 시스템 ID 목록을 반환한다."""
    systems = set()
    # 기본 시스템이 설정되어 있으면 추가
    def_sys = os.getenv("SAP_DEFAULT_SYSTEM", "EA3").strip().upper()
    if os.getenv("SAP_ASHOST"):
        systems.add(def_sys)
    # SAP_<SYS>_ASHOST 형식 검색
    for k in os.environ:
        if k.startswith("SAP_") and k.endswith("_ASHOST"):
            part = k[4:-7]  # SAP_ 와 _ASHOST 사이
            if part and part != "DEFAULT":
                systems.add(part.upper())
    return sorted(list(systems))


@dataclass
class Settings:
    system_id: str = "EA3"

    # RFC 접속
    saprouter: str = ""
    ashost: str = ""
    sysnr: str = ""
    client: str = ""
    user: str = ""
    passwd: str = ""
    lang: str = "KO"

    # 안전장치
    readonly: bool = True
    allowed_sysids: tuple = ()
    name_pattern: str = r"^([ZY]|SAPM[ZY]|MP9|L[ZY])\w*$"
    package_prefixes: tuple = ("Z", "Y", "$TMP")
    allowed_authors: tuple = ()
    backup_dir: str = ".backup"
    audit_log: str = "audit.log"

    # SuccessFactors EC OData API 접속
    sf_api_url: str = ""
    sf_company_id: str = ""
    sf_user: str = ""
    sf_password: str = ""

    def __init__(self, system_id: str | None = None):
        def_sys = os.getenv("SAP_DEFAULT_SYSTEM", "EA3").strip().upper()
        self.system_id = (system_id or def_sys).strip().upper()
        prefix = f"SAP_{self.system_id}_" if self.system_id != "EA3" and os.getenv(f"SAP_{self.system_id}_ASHOST") else "SAP_"

        # 특정 시스템 전용 접두사가 없으면 기본 SAP_ 접두사 폴백
        def _get(key: str, default: str = "") -> str:
            if prefix != "SAP_":
                val = os.getenv(f"SAP_{self.system_id}_{key}")
                if val is not None:
                    return val
            return os.getenv(f"SAP_{key}", default)

        self.saprouter = _get("SAPROUTER", "")
        self.ashost = _get("ASHOST", "")
        self.sysnr = _get("SYSNR", "00")
        self.client = _get("CLIENT", "100")
        self.user = _get("USER", "")
        self.passwd = _get("PASSWORD", "")
        self.lang = _get("LANG", "KO")

        self.readonly = _b(_get("READONLY", "false"))
        allowed_sys = _get("WRITE_SYSIDS", self.system_id)
        self.allowed_sysids = tuple(x.strip().upper() for x in allowed_sys.split(",") if x.strip())
        self.name_pattern = _get("NAME_PATTERN", r"^([ZY]|SAPM[ZY]|MP9|L[ZY])\w*$")
        self.package_prefixes = tuple(x.strip().upper() for x in _get("PACKAGE_PREFIXES", "Z,Y,$TMP").split(",") if x.strip())
        default_authors = "seppin,pado01" if self.system_id == "GY7" else "duser03,seppin"
        authors_set = {x.strip().upper() for x in _get("ALLOWED_AUTHORS", default_authors).split(",") if x.strip()}
        if self.system_id == "GY7":
            authors_set.update({"SEPPIN", "PADO01"})
        self.allowed_authors = tuple(sorted(authors_set))
        self.backup_dir = _get("BACKUP_DIR", ".backup")
        self.audit_log = _get("AUDIT_LOG", "audit.log")

        # SuccessFactors EC
        self.sf_api_url = os.getenv("SF_API_URL", "")
        self.sf_company_id = os.getenv("SF_COMPANY_ID", "")
        self.sf_user = os.getenv("SF_USER", "")
        self.sf_password = os.getenv("SF_PASSWORD", "")

    @property
    def sf_configured(self) -> bool:
        return bool(self.sf_api_url and self.sf_company_id and self.sf_user and self.sf_password)

    def rfc_params(self) -> dict:
        p = dict(ashost=self.ashost, sysnr=self.sysnr, client=self.client,
                 user=self.user, passwd=self.passwd, lang=self.lang)
        if self.saprouter:
            p["saprouter"] = self.saprouter
        return p

    def missing(self) -> list[str]:
        need = {"ASHOST": self.ashost, "SYSNR": self.sysnr, "CLIENT": self.client,
                "USER": self.user, "PASSWORD": self.passwd}
        return [f"SAP_{k}" if self.system_id == "EA3" else f"SAP_{self.system_id}_{k}"
                for k, v in need.items() if not v]
