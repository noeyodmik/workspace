"""SapBackend 인터페이스.

MCP 도구는 이 인터페이스만 사용한다. 지금은 RfcBackend, 이후 Synology
리버스 프록시가 준비되면 AdtBackend를 추가해 백엔드만 교체한다.
"""
from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any


@dataclass
class Result:
    ok: bool
    message: str = ""
    data: Any = None
    messages: list[dict] = field(default_factory=list)


class SapBackend(ABC):
    @abstractmethod
    def ping(self) -> Result: ...

    @abstractmethod
    def system_info(self) -> Result: ...

    @abstractmethod
    def search_object(self, pattern: str, obj_type: str = "", package: str = "") -> Result: ...

    @abstractmethod
    def get_source(self, obj_type: str, name: str) -> Result: ...

    @abstractmethod
    def syntax_check(self, obj_type: str, name: str, source: str) -> Result: ...

    @abstractmethod
    def update_source(self, obj_type: str, name: str, source: str, transport: str) -> Result: ...

    @abstractmethod
    def activate_object(self, obj_type: str, name: str) -> Result: ...

    @abstractmethod
    def create_object(self, obj_type: str, name: str, package: str, description: str,
                      transport: str) -> Result: ...

    @abstractmethod
    def delete_object(self, obj_type: str, name: str, transport: str) -> Result: ...

    @abstractmethod
    def get_where_used(self, obj_type: str, name: str) -> Result: ...

    @abstractmethod
    def list_transports(self, user: str = "") -> Result: ...

    @abstractmethod
    def get_payroll_result(self, pernr: str, inper: str = "", payty: str = "",
                           bondt: str = "", seqnr: str = "") -> Result: ...

    @abstractmethod
    def get_replication_log(self, pernr: str = "", ext_id: str = "",
                            trigger_replication: bool = False, config_id: str = "",
                            date_from: str = "", date_to: str = "",
                            msgty: str = "", subobject: str = "",
                            max_rows: int = 100) -> Result: ...

    @abstractmethod
    def diagnose_message(self, msg_id: str = "", msg_no: str = "", query: str = "",
                         v1: str = "", v2: str = "", v3: str = "", v4: str = "",
                         lang: str = "3") -> Result: ...

    @abstractmethod
    def check_function_module(self, name: str) -> Result: ...

    @abstractmethod
    def get_recent_dumps(self, date_from: str = "", date_to: str = "",
                         user: str = "", program: str = "",
                         max_rows: int = 20) -> Result: ...

    @abstractmethod
    def read_table(self, table_name: str, fields: list[str] | None = None,
                   where_clause: str = "", max_rows: int = 100) -> Result: ...

    @abstractmethod
    def check_infotype_config(self, infty: str, molga: str = "") -> Result: ...

    @abstractmethod
    def run_payroll(self, pernr: str = "", inper: str = "", test_run: bool = True,
                    schema: str = "KR00", abkrs: str = "") -> Result: ...

    @abstractmethod
    def check_payroll_control_record(self, abkrs: str = "", pernr: str = "") -> Result: ...

    @abstractmethod
    def compare_payroll_periods(self, pernr: str, inper_a: str, inper_b: str,
                                payty_a: str = "", payty_b: str = "",
                                mask_sensitive: bool = True) -> Result: ...

    @abstractmethod
    def get_replication_status(self, pernr: str = "", ext_id: str = "",
                               status_filter: str = "ALL", max_rows: int = 20) -> Result: ...


