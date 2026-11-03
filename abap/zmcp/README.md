# abap/zmcp

SAP에 등록할 RFC 함수 그룹 `ZMCP` 소스를 둘 위치.

단계 0(`RFC_PING`)은 표준 FM이라 이 폴더 없이 동작한다.
단계 1부터 `Z_MCP_SEARCH`, `Z_MCP_GET_SOURCE` 등을 여기에 추가한다.
모든 FM은 Remote-Enabled 로 만들고, 시작부에서 AUTHORITY-CHECK 와 Z/Y 이름 검사를 수행한다.

## 단계 1 등록 절차 (SE37)

1. SE80 → 함수 그룹 `ZMCP` 생성 (패키지 `$TMP` 또는 개인 Z 패키지).
2. SE37 에서 아래 FM 3개를 생성한다. 처리 유형(Processing Type)은 **원격 지원 기능(Remote-Enabled Module)**.
3. 각 FM 의 **소스 코드 탭**에 `.abap` 파일의 `FUNCTION` ~ `ENDFUNCTION` 을 붙여 넣는다
   (자동 생성되는 `FUNCTION ... .` / `ENDFUNCTION.` 줄은 파일 내용으로 교체).
4. 파라미터를 아래 표대로 입력하고, 모두 활성화한다.

### Z_MCP_SEARCH
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | `IV_PATTERN` | `STRING` | 값 전달(Pass Value) 체크 |
| Import | `IV_TYPE` | `CHAR4` | 선택, 값 전달 |
| Import | `IV_PACKAGE` | `DEVCLASS` | 선택, 값 전달 |
| Import | `IV_MAX` | `I` | 선택, 값 전달 |
| Tables | `ET_OBJECTS` | `TADIR` | |
| Exceptions | `NOT_ALLOWED` | | |

### Z_MCP_GET_SOURCE
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | `IV_TYPE` | `CHAR4` | 값 전달 |
| Import | `IV_NAME` | `CHAR40` | 값 전달 |
| Tables | `ET_SOURCE` | `ABAPTXT255` | |
| Exceptions | `NOT_ALLOWED`, `NOT_FOUND` | | |

### Z_MCP_LIST_TRANSPORTS
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | `IV_USER` | `XUBNAME` | 선택, 값 전달 |
| Tables | `ET_REQUESTS` | `E070` | |
| Exceptions | `NOT_ALLOWED` | | |

> `Z_MCP_GET_SOURCE` 의 CLAS 분기(`cl_oo_factory`)는 시스템 릴리스에 따라
> 문법 오류가 날 수 있다. 오류 메시지를 알려주면 수정한다.

## 단계 2 등록 (SE37) — 모두 Remote-Enabled, Import 는 값 전달(Pass Value)

권장 순서: 읽기 전용 `Z_MCP_SYNTAX_CHECK`, `Z_MCP_WHERE_USED` 먼저 → 검증 후 쓰기 FM.
쓰기 FM(UPDATE/ACTIVATE/DELETE)은 **sy-uname 이 만든 객체만** 허용한다(공용 서버 보호).

### Z_MCP_SYNTAX_CHECK
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Export | `EV_OK` | `CHAR1` |
| Export | `EV_MESSAGE` | `STRING` |
| Export | `EV_LINE` | `I` |
| Export | `EV_WORD` | `STRING` |
| Tables | `IT_SOURCE` | `ABAPTXT255` |
| Exceptions | `NOT_ALLOWED` | |

### Z_MCP_WHERE_USED
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Tables | `ET_USAGES` | `ABAPTXT255` |
| Exceptions | `NOT_ALLOWED` | |

### Z_MCP_UPDATE_SOURCE
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Import | `IV_TRANSPORT` | `TRKORR` |
| Export | `EV_OK` | `CHAR1` |
| Export | `EV_MESSAGE` | `STRING` |
| Tables | `IT_SOURCE` | `ABAPTXT255` |
| Exceptions | `NOT_ALLOWED` | |

### Z_MCP_ACTIVATE
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Export | `EV_OK` | `CHAR1` |
| Export | `EV_MESSAGE` | `STRING` |
| Exceptions | `NOT_ALLOWED` | |

### Z_MCP_CREATE_OBJECT
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Import | `IV_PACKAGE` | `DEVCLASS` |
| Import | `IV_DESCRIPTION` | `STRING` |
| Import | `IV_TRANSPORT` | `TRKORR` |
| Export | `EV_OK` | `CHAR1` |
| Export | `EV_MESSAGE` | `STRING` |
| Exceptions | `NOT_ALLOWED` | |

### Z_MCP_DELETE_OBJECT
| 구분 | 이름 | 유형 지정 |
|---|---|---|
| Import | `IV_TYPE` | `CHAR4` |
| Import | `IV_NAME` | `CHAR40` |
| Import | `IV_TRANSPORT` | `TRKORR` |
| Export | `EV_OK` | `CHAR1` |
| Export | `EV_MESSAGE` | `STRING` |
| Exceptions | `NOT_ALLOWED` | |

## 단계 3 등록 (SE37) — 한국 급여 결과 조회 (Remote-Enabled, Pass Value)

### Z_MCP_GET_PAYROLL_RESULT
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | `IV_PERNR` | `PERNR_D` | 값 전달 (사번) |
| Import | `IV_INPER` | `CHAR6` | 선택, 값 전달 (예: 202609) |
| Import | `IV_PAYTY` | `PAYTY` | 선택, 값 전달 (공백: 정기, B: 상여 등 비정기) |
| Import | `IV_BONDT` | `BONDT` | 선택, 값 전달 (비정기 지급일 YYYYMMDD) |
| Import | `IV_SEQNR` | `NUMC5` | 선택, 값 전달 (급여 순번 직접 지정) |
| Export | `EV_OK` | `CHAR1` | 성공 여부 (X) |
| Export | `EV_MESSAGE` | `STRING` | 메시지 |
| Export | `EV_SEQNR` | `NUMC5` | 급여 결과 순번 |
| Export | `EV_FPPER` | `CHAR6` | 귀속연월 |
| Export | `EV_INPER` | `CHAR6` | 지급연월 |
| Export | `EV_PAYTY` | `PAYTY` | 급여 유형 |
| Export | `EV_PAYID` | `PAYID` | 비정기 식별자 |
| Export | `EV_BONDT` | `BONDT` | 비정기 지급일 |
| Export | `EV_PAYDT` | `DATUM` | 실제 지급일 |
| Export | `EV_OCRSN` | `CHAR4` | 비정기 사유 |
| Tables | `ET_RT` | `PC207` | SAP 표준 급여 결과(RT) 라인 구조 |
| Tables | `ET_DIRECTORY` | `PC261` | 사원의 전체 급여 실행 이력 (RGDIR) |
| Exceptions | `NOT_ALLOWED` | | |

## 단계 4 등록 (SE37) — EC-ECP 마스터 데이터 복제 로그 조회 (Remote-Enabled, Pass Value)

### Z_MCP_GET_REPLICATION_LOG
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | `IV_PERNR` | `PERNR_D` | 선택, 값 전달 (사번 필터) |
| Import | `IV_EXT_ID` | `STRING` | 선택, 값 전달 (EC 외부 식별자 / User ID 필터) |
| Import | `IV_TRIGGER_REPL` | `CHAR1` | 선택, 값 전달 ('X': 복제 프로그램 즉시 실행 후 결과 조회) |
| Import | `IV_CONFIG_ID` | `CHAR30` | 선택, 값 전달 (PTP Configuration ID, 미지정 시 Combined/기본값) |
| Import | `IV_DATE_FROM` | `DATUM` | 선택, 값 전달 (시작일자, 기본: 최근 7일) |
| Import | `IV_DATE_TO` | `DATUM` | 선택, 값 전달 (종료일자, 기본: 당일) |
| Import | `IV_MSGTY` | `CHAR1` | 선택, 값 전달 ('E': 에러, 'W': 경고이상, 공백: 전체) |
| Import | `IV_SUBOBJECT` | `BALSUBOBJ` | 선택, 값 전달 (공백: 전체, 예: EMPLOYEE_DATA) |
| Import | `IV_MAX` | `I` | 선택, 값 전달 (최대 건수, 기본: 100) |
| Export | `EV_OK` | `CHAR1` | 성공 여부 (X) |
| Export | `EV_MESSAGE` | `STRING` | 처리 메시지 |
| Export | `EV_TOTAL_LOGS` | `I` | 조회된 로그 건수 |
| Export | `EV_ERROR_COUNT` | `I` | 에러 메시지 건수 |
| Tables | `ET_HEADERS` | `BALHDR` | 복제 실행 단위 헤더 이력 (일자, 시각, 사번, 건수 등) |
| Tables | `ET_MESSAGES` | `BAPIRET2` | 상세 메시지/에러 원인 텍스트 목록 |
| Exceptions | `NOT_ALLOWED` | | |




## 단계 5 등록 (SE37) — 한국 급여 계산 실행 및 소급/오류/RT 진단 (Remote-Enabled, Pass Value)

### Z_MCP_RUN_PAYROLL
| 구분 | 이름 | 유형 지정 | 비고 |
|---|---|---|---|
| Import | IV_PERNR | PERNR_D | 선택, 값 전달 (대상 사번 - 미입력 시 급여영역 전체 실행) |
| Import | IV_INPER | INPER | 선택, 값 전달 (급여기간 YYYYMM) |
| Import | IV_SCHEMA | CHAR4 | 선택, 값 전달 (기본: 'KR00') |
| Import | IV_TEST | XFELD | 선택, 값 전달 ('X': 시뮬레이션, 공백: 실 급여 계산) |
| Import | IV_ABKRS | ABKRS | 선택, 값 전달 (미입력 시 IT0001 자동 판별) |
| Export | EV_OK | XFELD | 성공 여부 ('X' / ' ') |
| Export | EV_MESSAGE | STRING | 처리 요약 메시지 |
| Export | EV_SEQNR | NUMC5 | 계산된 급여 결과 순번 |
| Export | EV_FPPER | FPPER | 귀속기간 |
| Export | EV_INPER | INPER | 지급기간 |
| Export | EV_RETRO | XFELD | 소급 계산 발생 여부 ('X' / ' ') |
| Export | EV_RETRO_COUNT | INT4 | 소급된 과거 기간 수 |
| Export | EV_ERROR | XFELD | 계산 오류/Reject 발생 여부 ('X' / ' ') |
| Export | EV_LOG_COUNT | INT4 | 생성된 로그 라인 수 |
| Tables | ET_RT | PC207 | **실제 계산된 RT(Results Table) 임금유형/금액 결과** |
| Tables | ET_RETRO_PERIODS | PC261 | 소급 계산된 기간 목록 (RGDIR 구조) |
| Tables | ET_LOG | ABAPTXT255 | 실행 로그 전문 (거부/오류 라인 분석용) |
| Exceptions | NOT_ALLOWED | | |

> 2단계 FM 은 표준 FM(`RS_CORR_INSERT`, `RS_WORKING_OBJECTS_ACTIVATE`, `RPY_PROGRAM_INSERT`,
> `RS_DELETE_PROGRAM`)의 파라미터가 릴리스마다 다를 수 있다. 활성화 시 오류가 나면 알려주면 수정한다.
