# ChatGPT Share: SuccessFactors MCP 연결 가능성

## [1] USER

sap successfactors는 별도의 mcp 서버 설정을 통해 antigravity나 claude code 등의 ide 프로그램으로 개발/설정 등의 도움을 받을 수 있나?

---

## [2] ASSISTANT

**가능해. SAP SuccessFactors도 별도의 MCP 서버를 연결하면 Google Antigravity나 Claude Code에서 실제 시스템의 데이터를 조회하고, 설정을 분석하고, 일부 데이터를 변경하는 작업까지 AI의 도움을 받을 수 있어.**

특히 SAP SuccessFactors와 MCP를 연결한 실제 구현 사례도 확인됐어. 단순히 이론적으로 가능한 수준은 아니야.

다만 중요한 차이가 있어.

- **데이터 조회 및 분석\:** OData API를 이용하면 비교적 쉽게 구현 가능
- **데이터 생성 및 수정\:** API에서 지원하고 권한이 허용되는 범위에서 가능
- **SuccessFactors 설정 변경\:** 설정 항목별로 API 지원 여부가 달라서 일부만 가능
- **비즈니스 룰이나 화면 구성 등의 개발\:** AI가 설계·분석을 도와줄 수 있지만, 모든 작업을 IDE에서 직접 생성하거나 배포할 수 있는 것은 아님

즉, MCP를 연결한다고 SuccessFactors의 관리자 기능 전체가 자동으로 개방되는 것은 아니야.

## 1\. 실제로 사용할 수 있는 MCP 서버

**① **

SAP Community에 2026년 5월 26일 소개된 구현 사례야. SuccessFactors OData API를 MCP 서버로 연결하여 Claude에서 자연어로 데이터 조회가 가능하도록 만들었어.

직접 구축하거나 소스코드를 검토하고 싶은 경우

**② **

SuccessFactors 전용으로 제공되는 상용 MCP 솔루션이야. AI가 서버에 정의된 도구를 이용해 실제 데이터에 접근하도록 구성할 수 있어.

직접 MCP 서버를 개발하는 부담을 줄이고 싶은 경우

---

**③ **

이 사례는 특히 네 질문에 가까워. 여러 SuccessFactors 인스턴스 간 설정 비교, SAP HCM과의 데이터 비교, 데이터 업데이트, 급여 관련 보고서 작성 등에 MCP를 활용하는 방식이 소개되어 있어.

다만 SAP Community 게시글은 커뮤니티 구현 사례이지, 모든 기능이 SAP 공식 지원 범위라는 의미는 아니야.

## 2\. MCP 서버를 연결하면 어떤 구조로 동작할까?

**Antigravity / Claude Code**

AI가 질문을 해석하고 필요한 도구 호출

MCP 프로토콜

**SuccessFactors MCP 서버**

인증 · API 요청 · 결과 반환 · 작업 권한 제어

OData V2 / V4, REST API 등

**SAP SuccessFactors**

Employee Central · MDF · 기타 지원 모듈

예를 들어 Claude Code에 다음과 같이 요청할 수 있어.

> "현재 SuccessFactors 테스트 인스턴스에서 직원 조직정보와 코스트센터 관련 데이터를 조회하고, 특정 사원의 전보 이후 매핑에 문제가 있는지 분석해줘."

MCP 서버가 필요한 OData 엔티티를 조회하도록 구현되어 있다면, AI가 실제 데이터를 기반으로 비교 분석할 수 있어.

## 3\. 개발 및 설정 업무는 어디까지 가능할까?

| 작업 | MCP 활용 가능성 | 설명 |
|--------|--------|--------|
| 사원·조직·직무정보 조회 | 높음 | EC OData 엔티티 조회 |
| MDF 데이터 조회·수정 | 높음 | API 노출 및 권한 필요 |
| 인스턴스 간 설정값 비교 | 조건부 가능 | 설정이 API로 노출되어야 함 |
| Business Rule 분석 | 조건부 | 규칙 정의를 가져올 수 있어야 정확한 분석 가능 |
| Business Rule 신규 생성 | 제한적 | 관리자 화면 중심의 설정, 별도 지원 방식 검토 필요 |
| RBP 권한 설정 분석 | 제한적 | 관련 API 및 설정 접근 범위에 따라 다름 |
| EC → ECP 복제 오류 분석 | 조건부 가능 | 복제 로그, 매핑, ECP 데이터 등 별도 접근 필요 |
| 사용자 정의 확장 개발 | 가능 | BTP 등의 개발 환경과 결합 가능 |

SAP 공식 문서에서도 OData 지원 작업은 엔티티별로 다르다고 명시하고 있어. 또 MDF의 경우 API를 통한 데이터 변경이 가능하지만, UI 전용 `onInit` Rule은 OData 요청에서 실행되지 않아. 따라서 API 작업과 관리자 화면 작업을 동일하게 취급하면 안 돼. 

## 4\. 실제 연결을 위해 필요한 것

가장 현실적인 방법은 다음 순서야.

1. SuccessFactors 테스트 인스턴스의 API 서버 주소 확인
2. API 접근 계정과 RBP 권한 확보
3. OAuth 2.0 또는 OIDC 인증 구성
4. 기존 SF-MCP 서버 설치 또는 사용자 정의 MCP 서버 구축
5. Antigravity 또는 Claude Code에 해당 MCP 서버 등록
6. 우선 읽기 전용으로 연결을 테스트한 뒤 필요한 변경 기능만 허용

SAP는 API 인증에 OAuth 2.0과 OIDC를 지원하고 있으며, API 권한은 엔티티·행·필드 수준으로 제한할 수 있어. 

Antigravity는 공식적으로 사용자 정의 MCP 서버 연결을 지원해. 에서도 확인 가능해.

단, 실무 시스템의 사원·급여정보가 외부 AI 서비스로 전달될 수 있기 때문에 회사 보안 승인, 개인정보 처리 기준, 데이터 마스킹을 먼저 확인해야 해. 운영계에 AI가 직접 데이터를 수정하도록 하는 구성은 추천하지 않아.

---

## 5\. SAP HR 운영 업무에 적용한다면

지금처럼 SAP HR과 SuccessFactors를 함께 다루는 환경에서는 단순 사원정보 조회보다 **EC와 ECP 간 데이터 불일치 및 복제 오류 분석**에 활용하는 게 더 유용할 수 있어.

예를 들면 다음과 같은 작업이야.

- EC의 Job Information에 설정된 회사코드 및 코스트센터 확인
- EC와 ECP에 존재하는 조직정보 비교
- PTP 복제 시 매핑 누락 여부 조사
- 복제 오류 로그와 사원 마스터 데이터를 함께 분석
- SuccessFactors 인스턴스 간 MDF 설정 차이 검증

여기서 ECP 영역까지 자동 분석하려면 SuccessFactors MCP뿐 아니라 ECP 측 API나 로그 조회 기능도 연결해야 해.

**한 가지 확인하고 싶은 게 있어.**

네가 원하는 방향은 어느 쪽이야?

**① SuccessFactors 설정·개발 지원** — Business Rule, MDF, EC 설정 등을 AI가 직접 확인하고 변경하도록 구성

**② SAP HR 운영·오류 분석 지원** — EC/ECP 복제 오류, 사원정보 불일치, 매핑 문제 분석

**③ 둘 다** — SuccessFactors와 ECP를 연결한 AI 개발·운영 환경 구축

[선택한 방향으로 구축 방법 알아보기]

방향에 따라 필요한 MCP 서버 자체가 달라져. 특히 설정 개발이 목적이라면 단순 OData 조회용 MCP 서버만 설치하는 것은 부족할 수 있어.

---

## [3] USER

SuccessFactors와 ECP를 모두 MCP로 연결해서 개발, 설정, 운영 오류 분석을 지원하는 환경을 구축하는 방법을 구체적으로 알려줘.

---

## [4] ASSISTANT

# SAP SuccessFactors + ECP 통합 MCP 개발환경 구축 가이드

**목표: Google Antigravity 또는 Claude Code에서 SuccessFactors EC와 ECP를 동시에 연결해 개발, 설정 분석, 급여 운영 및 복제 오류 분석을 지원하는 환경 구축**

결론부터 말하면, **SuccessFactors용 MCP 서버와 ECP용 MCP 서버를 각각 구성한 뒤 하나의 AI IDE에 등록하는 방식**을 추천해.

SuccessFactors는 공개 API를 활용하고, ECP는 필요한 ABAP 기능을 API로 노출하는 구조가 가장 현실적이야.

다만 SAP 시스템의 버전, ECP 접근 권한, 회사 보안정책에 따라 구현 가능한 범위는 달라져.

## 1\. 추천하는 전체 시스템 구조

**Antigravity / Claude Code**

AI 에이전트 · 코드 분석 · 진단 결과 생성

MCP Tool 호출

**SF-MCP**

SuccessFactors API 연결

OAuth + OData

**SuccessFactors EC**

사원·조직·Job Information·MDF

**ECP-MCP**

ECP 전용 도구 연결

보호된 HTTP API

**SAP ECP**

PA0001 · 급여결과 · SLG1 · ABAP

**공통 보안 계층**

최소 권한 · 개인정보 마스킹 · 호출 감사 로그 · 변경 승인

권장 논리 구조. 두 MCP 서버는 각 SAP 시스템과 별도의 인증·권한 체계를 가진다.

이렇게 하면 AI가 두 시스템에 필요한 도구를 호출하고, 결과를 비교해 원인을 추론할 수 있어.

예를 들어 EC에는 코스트센터 `O401105`가 존재하지만 ECP에서는 회사코드가 맞지 않는 오류가 발생했다고 해보자.

AI에 다음과 같이 요청하는 거야.

> "이 사원의 EC Job Information과 ECP IT0001을 비교해서 회사코드, 코스트센터, 유효기간이 일치하는지 확인하고 KI100 오류의 원인을 분석해줘."

서버에 필요한 조회 기능이 구현되어 있다면, AI는 EC 정보 조회 → ECP 정보 조회 → 복제 로그 조회 → 데이터 불일치 분석을 이어서 수행할 수 있어.

**핵심은 AI에 SAP 전체 권한을 부여하는 게 아니라, 분석에 필요한 기능을 MCP Tool로 하나씩 제공하는 것**이야.

## 2\. 사전에 준비할 것

| 영역 | 필요한 준비 |
|--------|--------|
| 개발 PC | Python 또는 Node.js, Antigravity 또는 Claude Code |
| SuccessFactors | 테스트 인스턴스, API URL, API 사용자, OAuth 인증, RBP 권한 |
| ECP | 개발/테스트 시스템, HTTP 또는 RFC 연결 경로, 제한된 기술 사용자 |
| ABAP 개발 | SE80/SE37 또는 ADT, 필요한 경우 OData 서비스 생성 권한 |
| 네트워크 | SAP API 접근, VPN 또는 승인된 네트워크 경로 |
| 보안 | 개인정보 처리 승인, 읽기 전용 권한, 감사 로그 |

SuccessFactors 공식 문서에 따르면 OData API 접근에는 OAuth 클라이언트 등록 및 관련 권한 구성이 필요해. 

ECP가 외부에서 직접 접근할 수 없는 구조라면 BTP Connectivity와 SAP Cloud Connector를 검토할 수 있어. Cloud Connector는 허가된 RFC 및 HTTP(S) 연결을 지원하지만, MCP 서버 자체나 AI 접근 권한을 자동으로 제공하는 제품은 아니야. 

---

## 3\. 1단계 — SuccessFactors MCP 서버 구축

SuccessFactors부터 연결하는 게 좋아. ABAP 개발 없이도 API를 통해 조회 가능 여부를 확인할 수 있기 때문이야.

### ① SuccessFactors API 클라이언트 등록

SuccessFactors 관리자 화면에서 다음 경로로 이동해.

`Admin Center → API Center → OAuth Configuration for OData`

여기에서 OAuth Client Application을 등록하고 필요한 API 사용자를 연결해.

환경에 따라 메뉴는 `Manage OAuth2 Client Applications` 검색을 통해 접근할 수도 있어.

공식 안내: 

### ② API 메타데이터 확인

인증이 준비되면 다음 API를 사용해 실제 접근 가능한 엔티티 구조를 확인할 수 있어.



```http
GET https://<SF_API_HOST>/odata/v2/$metadata
```



여기서 다음 정보를 파악할 수 있어.

- EntitySet과 필드 구조
- 필드 타입 및 탐색 관계
- 공개된 API 작업
- 사용자 정의 MDF 객체의 API 노출 여부

API에 엔티티가 정의되어 있다고 해서 모든 필드에 접근할 수 있는 것은 아니야. 실제 호출은 RBP 권한 검사를 받게 돼. 

### ③ MCP에서 제공할 도구 설계

처음부터 모든 OData 엔티티를 노출하지 말고 아래처럼 기능을 제한해서 시작하는 게 좋아.

| MCP Tool 이름 예시 | 기능 |
|--------|--------|
| `sf_get_employee` | 특정 사원 기본정보 조회 |
| `sf_get_job_info` | 발령·회사코드·조직정보 조회 |
| `sf_get_mdf_object` | 허용된 MDF 객체 조회 |
| `sf_get_entity_metadata` | 엔티티 필드 및 타입 조회 |
| `sf_compare_configuration` | 허용된 설정 항목 간 차이 비교 |

이 이름들은 SAP에서 제공하는 표준 Tool이 아니라 **우리가 MCP 서버에 구현할 사용자 정의 기능 이름**이야.

`sf_compare_configuration` 같은 기능은 비교 대상 설정 데이터 자체를 API나 승인된 설정 내보내기로 가져올 수 있어야 동작해.

---

## 4\. 2단계 — ECP MCP 서버 구축

이 부분이 전체 구축에서 가장 중요하고 난이도도 높아.

ECP는 ABAP 기반이라서 SuccessFactors처럼 사원정보, 급여결과, 설정 및 로그 전체를 외부에서 일괄적으로 조회할 수 있는 범용 API가 준비되어 있다고 가정하면 안 돼.

따라서 **ECP 내부 ABAP 조회 기능을 만들고 이를 안전한 API로 노출하는 방식**을 권장해.

### ① ECP에서 제공할 기능 결정

**사원 마스터 분석**

IT0000, IT0001, IT0003 등 필요한 인포타입 조회. 사번 및 기준일을 받아 EC 정보와 비교.

---

**급여결과 분석**

RGDIR, RT, CRT 등 필요한 급여결과를 표준 급여 읽기 인터페이스로 조회하고 차이 분석. 국가별 클러스터 구조와 권한 검증 필요.

---

**오류 및 로그 분석**

SLG1 Application Log, 복제 처리 상태, 필요 시 SOAP 처리 로그를 승인된 조회 기능으로 제공.

---

**ABAP 개발 지원**

허용된 Z 프로그램·클래스·함수의 소스 및 인터페이스를 조회하고 개선 코드 생성. 배포와 활성화는 별도 승인.

### ② ABAP API 구성

예를 들어 사원번호와 기준일을 전달하면 ECP의 IT0001 조직정보를 반환하는 조회 서비스를 만드는 거야.

예시 인터페이스는 다음과 같아.



```http
GET /api/ecp/employees/20250488/org-assignment?date=2026-10-29
```



예상 응답 형태는 다음과 같아.



```json
{
  "pernr": "20250488",
  "begda": "2026-01-01",
  "endda": "9999-12-31",
  "bukrs": "AA00",
  "werks": "1000",
  "kostl": "O401105"
}
```



예시 데이터이며 실제 시스템의 조회 결과가 아님. URL도 구축할 사용자 정의 API 형식이야.

ECP가 RAP 서비스를 지원하는 ABAP 버전이라면 CDS View와 Service Definition/Binding으로 OData API를 노출할 수 있어. 그렇지 않다면 시스템에서 지원하는 Gateway OData 또는 제한된 RFC 래퍼 등을 검토해야 해. 

### ③ ECP 복제 로그 조회 기능

EC에서 ECP로 넘어가는 복제 오류를 분석하려면 로그를 함께 제공하는 게 중요해.

관련 표준 기능은 다음과 같아.

| 기능 | T-code |
|--------|--------|
| 복제 실행 | `HRSFEC_PTP_EE_REPL` |
| Application Log | `SLG1` |
| Web Service 오류/메시지 확인 | `SRTUTIL` |
| 백그라운드 잡 확인 | `SM37` |

이들은 ECP의 복제 방식에 따라 해당하는 기능이고, 모든 T-code가 그대로 MCP에서 호출되는 것은 아니야. 예를 들어 PTP 복제에서는 `SLG1`의 `HRSFEC` 관련 로그와 `SRTUTIL`을 활용할 수 있어. 

MCP 서버에는 임의 T-code 실행 기능을 주기보다는, 특정 사원과 기간에 해당하는 오류 로그를 반환하는 전용 기능을 구현하는 편이 안전해.

## 5\. 3단계 — MCP 서버를 실제 IDE에 연결

여기부터는 **두 개의 MCP 서버가 준비되어 있고, 각각 `/mcp` 엔드포인트를 제공한다고 가정**할게.

예시 주소\:

- SF-MCP: `https://sf-mcp.company.example/mcp`
- ECP-MCP: `https://ecp-mcp.company.example/mcp`

이 주소들은 실제 서비스 주소가 아니라 구축 후 부여할 주소야. 서버가 실행되지 않는 상태에서 설정 파일만 추가한다고 연결되지는 않아.

**① Google Antigravity**

Antigravity IDE에서 Agent 패널의 `… → MCP Servers → Manage MCP Servers → View raw config`로 이동해.

`mcp_config.json` 파일에 아래 내용을 추가하면 돼. 



```json

{
  "mcpServers": {
    "successfactors": {
      "serverUrl": "https://sf-mcp.company.example/mcp"
    },
    "ecp": {
      "serverUrl": "https://ecp-mcp.company.example/mcp"
    }
  }
}
  
```



인증은 각 MCP 서버에서 지원하는 OAuth 방식 또는 승인된 인증 프록시를 통해 구성해야 해. 위 예시는 연결 주소만 나타낸 거야.

---

**② Claude Code**

Claude Code에서는 터미널에서 서버를 등록할 수 있어.



```bash

claude mcp add --transport http successfactors https://sf-mcp.company.example/mcp

claude mcp add --transport http ecp https://ecp-mcp.company.example/mcp

claude mcp list
  
```



등록 후 Claude Code에서 `/mcp`를 실행해 연결 상태와 인증 여부를 확인하면 돼. 

공식 문서: 

두 IDE 중 하나만 선택할 필요는 없어. 동일한 원격 MCP 서버를 두 IDE에서 각각 등록해 사용할 수 있어.

## 6\. 4단계 — Python으로 MCP 서버 직접 구현하기

처음부터 원격 서버를 배포하지 말고, **개발 PC에서 읽기 전용으로 동작하는 최소 MCP 서버**를 만들어 테스트하는 걸 추천해.

우선 SuccessFactors API 연결부터 시작할 수 있어.

아래 코드는 `FastMCP` 기반의 최소 예제야. 이미 발급된 OAuth Access Token을 이용한다는 전제로 작성했어.

### 폴더 구조



```text
sap-ai-mcp/
├── sf_mcp.py
├── ecp_mcp.py
├── .env
└── requirements.txt
```



### 패키지 설치



```bash
pip install "mcp[cli]" httpx python-dotenv
```



### SuccessFactors MCP 코드

```python

import os
import httpx
from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP

load_dotenv()

mcp = FastMCP("successfactors")

SF_URL = os.environ["SF_API_URL"].rstrip("/")
SF_TOKEN = os.environ["SF_ACCESS_TOKEN"]

@mcp.tool()
async def sf_get_job_info(
    user_id: str,
    top: int = 10
) -> dict:
    """허용된 사용자 ID의 EC Job Information 조회."""

    if not user_id or not 1 <= top <= 20:
        raise ValueError("Invalid input")

    url = f"{SF_URL}/odata/v2/EmpJob"

    # OData 문자열 리터럴 이스케이프
    safe_id = user_id.replace("'", "''")

    params = {
        "$filter": f"userId eq '{safe_id}'",
        "$select":
            "userId,startDate,endDate,company,costCenter",
        "$top": top,
        "$format": "json"
    }

    async with httpx.AsyncClient(
        timeout=20.0
    ) as client:
        response = await client.get(
            url,
            params=params,
            headers={
                "Authorization": f"Bearer {SF_TOKEN}",
                "Accept": "application/json"
            }
        )

        response.raise_for_status()
        return response.json()

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

테스트용 최소 구현. 실제 환경에서는 토큰 자동 갱신, 페이징, 재시도 제한, 필드 마스킹, 출력 크기 제한과 오류 처리 보강이 필요해. `EmpJob`의 실제 사용 가능 필드는 해당 인스턴스의 메타데이터로 확인해야 해.

`.env`에는 다음 항목을 설정해.



```dotenv
SF_API_URL=https://<YOUR_SF_API_HOST>
SF_ACCESS_TOKEN=<ACCESS_TOKEN>
```



OAuth Token은 사전에 SAP 공식 절차에 따라 발급해야 해. `.env`는 Git에 업로드하지 않고, 장기 운영 환경에서는 Secret Manager 등으로 분리해야 해.

### ECP MCP 코드

ECP도 같은 구조를 적용할 수 있어. 단, **ECP에는 앞서 만든 사용자 정의 조회 API가 실제로 존재해야 해.**

```python

import os
import httpx
from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP

load_dotenv()
mcp = FastMCP("ecp")

ECP_URL = os.environ["ECP_API_URL"].rstrip("/")
ECP_TOKEN = os.environ["ECP_ACCESS_TOKEN"]

@mcp.tool()
async def ecp_get_org_assignment(
    pernr: str,
    date: str
) -> dict:
    """ECP의 사원 조직정보 조회."""

    if not pernr.isdigit() or len(pernr) > 12:
        raise ValueError("Invalid personnel number")

    from datetime import date as Date
    Date.fromisoformat(date)

    async with httpx.AsyncClient(
        timeout=20.0
    ) as client:
        response = await client.get(
            f"{ECP_URL}/employees/{pernr}/org-assignment",
            params={"date": date},
            headers={
                "Authorization": f"Bearer {ECP_TOKEN}"
            }
        )

        response.raise_for_status()
        return response.json()

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

여기서 `ECP_API_URL`은 ABAP Gateway 또는 별도 API Gateway가 제공하는 사용자 정의 서비스 기본 경로야. ECP OData V2 서비스나 RAP V4 서비스를 그대로 사용한다면 실제 URL·파라미터·응답 형식에 맞게 호출 코드를 수정해야 해.

### 로컬 MCP 서버 등록 예시

Windows에서 `C:\sap-ai-mcp`에 코드를 저장하고 Python 가상환경을 만들었다면 Antigravity 설정은 다음과 같이 구성할 수 있어.



```json

{
  "mcpServers": {
    "successfactors": {
      "command": "C:\\sap-ai-mcp\\.venv\\Scripts\\python.exe",
      "args": ["C:\\sap-ai-mcp\\sf_mcp.py"]
    },
    "ecp": {
      "command": "C:\\sap-ai-mcp\\.venv\\Scripts\\python.exe",
      "args": ["C:\\sap-ai-mcp\\ecp_mcp.py"]
    }
  }
}
```



이제 AI에게 `sf_get_job_info`와 `ecp_get_org_assignment`를 각각 실행하도록 지시할 수 있어.

다만 이 단계까지 구현된 기능은 **조회 Tool 두 개뿐**이야. 통합 분석을 완성하려면 사번 매핑 및 오류 로그 조회 Tool을 추가해야 해.

---

## 7\. 5단계 — 실제 SAP HR 운영에 맞춘 MCP 기능 확장

여기부터가 제대로 활용할 수 있는 단계야.

네가 수행하는 HR 운영 업무를 기준으로 개발 우선순위를 잡으면 다음과 같아.

**1순위: EC ↔ ECP 사원정보 및 복제 오류 비교**

`sf_get_job_info`, `ecp_get_org_assignment`, `ecp_get_replication_log`, `ecp_get_employee_mapping`

EC 사번과 ECP 사번이 다른 경우도 있으므로, 먼저 매핑을 확인하고 유효기간별 조직정보를 비교하도록 구현.

---

**2순위: 급여결과 및 소급계산 분석**

`ecp_get_payroll_directory`, `ecp_get_payroll_rt`, `ecp_get_payroll_crt`

RGDIR의 결과번호와 상태를 기준으로 급여결과를 읽고, 전월·당월 또는 소급 전후 임금유형별 차이를 비교하도록 구성.

---

**3순위: ABAP 소스 및 설정 분석**

`ecp_get_abap_source`, `ecp_get_function_interface`, `sf_get_mdf_metadata`

허용된 Z 개발 객체의 코드를 읽고, 변경 전후 비교 및 수정안 생성. 설정 변경은 별도 승인 절차로 분리.

### 실제 오류 분석 시나리오

예를 들어 EC에서 전보를 처리한 직원이 ECP로 복제되는 과정에서 `KI100` 오류가 발생했다고 가정해보자.

AI에 입력하는 요청

> "2026년 10월 전보 대상 사원의 EC와 ECP 조직정보를 비교하고, KI100 오류가 발생한 원인을 분석해줘. 시스템 데이터는 수정하지 마."

---

1. **EC 정보 조회**
   
   전보일, 회사코드, 코스트센터, Job Information 확인
2. **EC-ECP 사번 매핑 확인**
   
   대상 직원의 External ID, ECP PERNR, 유효기간 매핑
3. **ECP 조직정보 및 오류 로그 조회**
   
   IT0001, 해당 날짜의 코스트센터 지정, SLG1 메시지 확인
4. **불일치 분석 및 조치안 작성**
   
   원천 데이터, 매핑, 유효기간, CO 마스터의 회사코드 귀속 확인 항목 제시

---

**AI가 작성하는 결과 예시**

"EC의 발령정보와 ECP의 조직정보에 회사코드 차이가 있습니다. KI100 메시지에 나타난 코스트센터의 회사코드 귀속 여부를 확인해야 합니다. 코스트센터 마스터와 복제 매핑을 대조한 후 수정 대상을 결정하는 것이 적절합니다."

이는 분석 흐름을 보여주는 가상 사례야. 코스트센터 마스터까지 조회할 Tool이 없다면 AI가 귀속관계를 확정할 수는 없어.

이 방식의 장점은 화면을 하나씩 열어서 비교하는 시간을 줄일 수 있다는 거야. 특히 여러 테이블과 로그를 함께 봐야 하는 문제에 유용해.

## 8\. 설정·개발까지 자동화하려면 추가로 필요한 것

현재까지 만든 조회 기능만으로는 SuccessFactors의 Business Rule을 신규 생성하거나 ECP의 Z 프로그램을 수정·활성화할 수 없어.

각 작업별 추가 수단이 필요해.

| 목표 | 추가로 필요한 수단 |
|--------|--------|
| MDF 설정 비교 | 해당 객체의 API 메타데이터 또는 설정 내보내기 |
| Business Rule 작성 지원 | 규칙 정의를 전달하거나 접근 가능한 설정 자료 확보 |
| EC 설정 반영 | 해당 설정에 대한 공식 지원 API 또는 관리자 화면 |
| ABAP 코드 수정 | ADT 기반 개발 워크플로 및 적절한 권한 |
| ECP 설정 비교 | 허용된 IMG 설정 데이터 추출 및 비교 서비스 |
| CTS 배포 | 개발자 검토, 전송 요청 승인 및 배포 프로세스 |

여기서 주의해야 할 건 **AI가 코드를 작성할 수 있다는 것과 SAP 시스템에 직접 반영할 수 있다는 것은 별개의 문제**라는 점이야.

초기에는 AI가 수정 제안과 ABAP 코드를 생성하고 사람이 검토해 반영하는 구조로 시작하는 편이 안전해.

## 9\. 운영계 보안 설계

급여를 다루는 환경이라면 이 부분은 선택사항이 아니야.

**조회 전용 MCP** (1차 구축)

사원 조직정보, 제한된 급여정보, 오류 로그, 개발 객체 메타데이터 조회. 회사가 승인한 데이터만 전달하고 개인정보는 최소화.

---

**변경 제안 MCP** (2차 구축)

코드 패치, 설정 변경안, 테스트 시나리오 생성. 실제 SAP 데이터는 변경하지 않음.

---

**변경 실행 MCP** (별도 승인 필요)

검증된 설정 변경만 개발/테스트 시스템에서 실행. 실행 전 승인, 변경 내역 기록, 실패 시 복구 절차 적용.

최소한 다음 원칙은 지키는 걸 추천해.

- 운영계에서 AI가 임의 SQL, RFC, ABAP 프로그램을 실행하지 못하게 제한
- 급여 원본 데이터 및 주민등록번호·계좌정보 등의 외부 모델 전송 금지 또는 강력한 최소화
- 서버 측에서 사번 범위, 결과 건수, API 호출 및 접근 가능 데이터 검증
- 프롬프트 내용만으로 SAP 권한 검사를 대체하지 않기
- 변경 실행과 개발 시스템 배포는 별도 승인

특히 Cloud Connector가 있다고 해서 외부 AI IDE에서 ECP로 직접 접근해도 된다는 의미는 아니므로, 회사 승인 네트워크와 인증 프록시를 거쳐야 해.

---

## 10\. 권장 구축 순서

**구축 체크리스트**  /  완료

## 참고할 공식 기술 문서

- 
- 
- 
- 
- 

---

## 실제 구축 전에 확인할 사항

위 설계는 구현 가능한 기본 구조지만, ECP에 대한 연결 방식은 시스템 환경에 따라 달라져.

특히 아래 세 가지를 확인해야 실제 회사 시스템에 맞는 아키텍처를 확정할 수 있어.

1\. ECP 시스템은 어떤 형태야?

SAP SuccessFactors Employee Central Payroll

별도 SAP HCM / Payroll ABAP 시스템

정확히 모르겠음

---

2\. 현재 ECP에 어떻게 접근하고 있어?

SAP GUI로 프로그램 실행 및 개발

SAP GUI + Eclipse ADT

API 접근 및 설정 권한도 있음

---

3\. MCP를 어느 시스템에 연결하려고 해?

개발계 또는 테스트계

운영계

개발/테스트계와 운영계 모두

[내 환경에 맞는 상세 구축 가이드 보기]

이 세 가지가 결정되면 **별도 서버를 만들어야 하는지, ECP에 어떤 ABAP API를 생성해야 하는지, IDE에는 어떤 설정을 넣어야 하는지**까지 구체적으로 좁힐 수 있어.

---

## [5] USER

우리 환경은 ECP 유형: SAP SuccessFactors Employee Central Payroll, 현재 접근 방식: SAP GUI만 사용, 연결 대상: 둘 다야. 이 환경에 맞춰 MCP 서버의 실제 구축 순서와 필요한 SAP 설정, ABAP API 개발 방법을 구체적으로 설명해줘.

---

## [6] ASSISTANT

# SAP SuccessFactors EC + ECP MCP 실전 구축 가이드

(현재 환경에 맞춘 구축안)

네 환경은 **SAP SuccessFactors Employee Central Payroll(ECP)을 사용하고, ABAP 개발은 SAP GUI에서만 수행하며, 개발·테스트계와 운영계를 모두 연결하려는 상황**이야.

이 조건에서는 Eclipse ADT나 RAP를 새로 도입하지 않아도 돼. 기존 SAP GUI의 `SE11`, `SE37`, `SEGW`, `SE80`을 활용해 ECP에 조회 API를 만들고, 외부 Python MCP 서버에서 호출하도록 구성할 수 있어.

다만 **SAP GUI 접속이 된다는 사실만으로 외부 프로그램에서 ECP API에 접근할 수 있는 것은 아니야.** ECP의 HTTPS 인바운드 연결은 별도로 구성해야 하고, SAP가 관리하는 클라우드 환경이므로 연결 방식과 서비스 노출 가능 범위를 Basis·보안 담당자와 확인해야 해.

SAP 공식 ECP 연결 문서는 외부 시스템에서 ECP로 접근하는 HTTPS/OData 방식과 RFC 방식을 모두 안내하고 있으며, HTTPS 인바운드에는 클라이언트 인증서를 권장하고 있어. 

## 1\. 최종 추천 구조

**Antigravity / Claude Code**

AI가 MCP Tool을 통해 필요한 데이터 조회 및 분석

**Python MCP 서버**

Tool 정의 · 입력값 검사 · 결과 마스킹 · 감사 로그

**SF Connector**

OAuth / OData

**ECP Connector**

인증서 / OData

**SuccessFactors EC**

개발/테스트 · 운영

EmpJob, MDF, 조직정보

**SAP ECP**

개발/테스트 · 운영

Gateway OData → ABAP 조회 로직

첫 버전에서는 MCP 서버를 하나로 만드는 게 관리하기 쉬워. 내부에서 EC용 Tool과 ECP용 Tool을 분리하면 돼. 이후 서버를 나눌 필요가 생기면 독립시킬 수 있어.

개발·테스트계와 운영계는 인증정보, 호출 대상 URL, 데이터 접근 권한을 각각 분리해야 해.

## 2\. 실제 구축 순서

| 순서 | 작업 | 담당 |
|--------|--------|--------|
| 1 | ECP 시스템 버전 및 Gateway 사용 가능 여부 확인 | 너 + Basis |
| 2 | ECP 외부 HTTPS API 접근 경로·인증 구성 | Basis·보안 |
| 3 | SuccessFactors OAuth 클라이언트 및 RBP 구성 | SF 관리자 |
| 4 | ECP 조회용 DDIC 구조, ABAP 로직 생성 | 너 |
| 5 | SEGW OData 서비스 생성 및 테스트 | 너 + Basis |
| 6 | Python MCP 서버 작성 | 너 |
| 7 | Antigravity / Claude Code MCP 등록 | 너 |
| 8 | 운영계 읽기 전용 연결·보안 검증 | Basis·보안 |
| 9 | 급여결과·복제로그·ABAP 분석 기능 추가 | 너 |

**추천 첫 구현 기능은 `특정 사번 + 기준일 → ECP IT0001 조직정보 조회`야.**

이 기능이 완성되면 EC의 `EmpJob` 조회와 연결해 회사코드, 인사영역, 코스트센터 등의 불일치를 분석할 수 있어.

---

# 3\. ECP 시스템에서 먼저 확인할 사항

SAP GUI로 개발할 수 있으니, 아래 트랜잭션부터 확인해.

| T-code | 확인 사항 |
|--------|--------|
| `System → Status` | SAP\_BASIS 및 SAP\_GWFND 컴포넌트 버전 |
| `SEGW` | Gateway Service Builder 실행 가능 여부 |
| `SE37` | 함수 모듈 생성 권한 |
| `SE11` | DDIC 구조 생성 권한 |
| `SICF` | `/sap/opu/odata` 경로 존재 및 서비스 활성화 상태 |
| `/IWFND/MAINT_SERVICE` | Gateway 서비스 등록 및 관리 권한 |
| `/IWFND/GW_CLIENT` | Gateway 서비스 테스트 가능 여부 |
| `PFCG` | 기술 사용자 역할 및 권한 설정 |

`SEGW`를 실행할 수 있다면 OData V2 서비스 개발 경로를 검토할 수 있어. SAP 공식 문서에서도 SEGW를 이용한 Runtime Artifact 생성과 Gateway 서비스 등록 절차를 안내하고 있어. 

주의할 점은 `SEGW` 실행 가능과 외부 API 공개 가능은 다르다는 거야. 전자는 ABAP 개발 기능이고, 후자는 HTTPS 네트워크·인증·서비스 활성화 문제야.

# 4\. SAP GUI에서 ECP 조회 API 개발하기

먼저 다음 개발 객체를 만들자.

| 객체 | 이름 예시 | 목적 |
|--------|--------|--------|
| Structure | `ZSHR_MCP_ORG` | API 반환 데이터 구조 |
| Function Module | `ZHR_MCP_GET_ORG` | IT0001 조직정보 조회 |
| SEGW Project | `ZHR_MCP` | OData 서비스 프로젝트 |
| Entity Type | `EmployeeOrg` | 사원 조직정보 모델 |
| Entity Set | `EmployeeOrgSet` | 사원정보 조회 API |
| Service | `ZHR_MCP_SRV` | 외부에서 호출할 OData 서비스 |

모든 이름은 예시라서 회사 네이밍 규칙에 맞춰 바꾸면 돼.

## 4-1. SE11에서 Structure 만들기

`SE11 → Data Type → ZSHR_MCP_ORG → Create`

다음 필드를 정의해.

| 필드 | 타입 | 의미 |
|--------|--------|--------|
| `PERNR` | PERNR\_D | 사원번호 |
| `BEGDA` | BEGDA | 시작일 |
| `ENDDA` | ENDDA | 종료일 |
| `BUKRS` | BUKRS | 회사코드 |
| `WERKS` | PERSA | 인사영역 |
| `BTRTL` | BTRTL | 인사하위영역 |
| `KOSTL` | KOSTL | 코스트센터 |
| `ORGEH` | ORGEH | 조직단위 |
| `STELL` | STELL | 직무 |

생성 후 활성화해.

## 4-2. SE37에서 Function Module 만들기

`SE37 → ZHR_MCP_GET_ORG → Create`

Function Group은 기존 Z 그룹을 사용하거나 새로 만들면 돼.

Import 파라미터\:



```abap
IV_PERNR TYPE PERNR_D
IV_DATE  TYPE SY-DATUM
```



Export 파라미터\:



```abap
ES_ORG TYPE ZSHR_MCP_ORG
```



Exception\:



```text
NO_DATA
NO_AUTHORITY
```



처리 로직은 다음과 같이 구성할 수 있어.



```abap

FUNCTION zhr_mcp_get_org.
*"--------------------------------------------------
*" IMPORTING
*"   IV_PERNR TYPE PERNR_D
*"   IV_DATE  TYPE SY-DATUM
*" EXPORTING
*"   ES_ORG   TYPE ZSHR_MCP_ORG
*" EXCEPTIONS
*"   NO_DATA
*"   NO_AUTHORITY
*"--------------------------------------------------

  DATA: lt_p0001 TYPE STANDARD TABLE OF p0001,
        ls_p0001 TYPE p0001.

  CLEAR es_org.

* 1. HR 마스터 조회 권한 검증
*    실제 구현 시 회사의 P_ORGIN,
*    P_ORGINCON 및 구조권한 체계에 맞게
*    권한검사 로직을 먼저 실행해야 함.
*    권한 없으면 RAISE no_authority.

* 2. IT0001 조회
  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      pernr     = iv_pernr
      infty     = '0001'
      begda     = iv_date
      endda     = iv_date
    TABLES
      infty_tab = lt_p0001
    EXCEPTIONS
      OTHERS    = 1.

  IF sy-subrc <> 0 OR lt_p0001 IS INITIAL.
    RAISE no_data.
  ENDIF.

  READ TABLE lt_p0001
       INTO ls_p0001
       INDEX 1.

  IF sy-subrc <> 0.
    RAISE no_data.
  ENDIF.

* 3. 반환 데이터 구성
  MOVE-CORRESPONDING ls_p0001 TO es_org.

ENDFUNCTION.
```



이 코드는 조회 및 매핑 구조를 보여주는 개발용 골격이야. 권한검사 부분은 아직 구현되지 않았으므로 그대로 외부에 노출하면 안 돼. 실제 배포 전 회사의 HR 권한 로직과 예외 처리를 완성해야 해.

여기서 중요한 점이 있어.

**`HR_READ_INFOTYPE`를 호출했다고 해서 API 사용자에 대한 HR 권한 검증이 자동으로 모두 해결된다고 가정하면 안 돼.**

HR 마스터 권한은 `P_ORGIN`, `P_ORGINCON` 등 시스템의 실제 권한 구성에 맞게 검사해야 해. SAP 문서에서도 이 권한 객체들이 인포타입 조회와 처리 범위를 제어한다고 명시하고 있어. 

또한 이 함수는 최초에는 일반 Function Module로 만들어도 돼. 이번 설계에서는 SEGW의 DPC Extension Class가 같은 시스템 내부에서 호출하기 때문이야. 외부에서 RFC 직접 호출하는 구조를 선택할 때만 별도로 Remote-Enabled 설정을 검토하면 돼.

### SE37에서 단위 테스트

Function Module을 저장 및 활성화한 뒤 `F8`을 눌러서 테스트해.



```text
IV_PERNR = 테스트 사원번호
IV_DATE  = 20261029
```



반환되는 `ES_ORG`에 기대한 회사코드, 코스트센터, 유효기간이 들어오는지 확인해.

이 단계가 실패한다면 MCP가 아니라 ABAP 조회 로직부터 수정해야 해.

## 4-3. SEGW로 OData V2 서비스 만들기

이제 SAP GUI에서 `SEGW`를 실행해.

1. 프로젝트 `ZHR_MCP` 생성
2. `Data Model → Entity Types`에서 `EmployeeOrg` 생성
3. SE11에서 만든 `ZSHR_MCP_ORG` 구조를 참조하여 필드 가져오기
4. 조회 식별용 키 구성. 기준일에 따라 결과가 달라지므로 `Pernr`와 `KeyDate`를 입력 키로 설계하거나 Function Import 방식 검토
5. `Entity Sets`에 `EmployeeOrgSet` 생성
6. `Generate Runtime Objects` 실행

여기서 설계상 중요한 부분은 **기준일을 어떻게 전달할 것인가**야.

`EmployeeOrg` 구조가 사원번호와 결과 유효기간만 가지고 있다면 별도 조회 키 `KeyDate`를 모델에 추가해야 해. `KeyDate`는 조회 조건이지 IT0001 데이터 자체는 아니므로, 생성할 OData 엔티티에는 그 차이를 반영해.

### DPC Extension에서 조회 함수 호출

런타임 객체를 생성하면 일반적으로 다음과 같은 클래스가 생성돼.



```text
ZCL_ZHR_MCP_MPC
ZCL_ZHR_MCP_MPC_EXT

ZCL_ZHR_MCP_DPC
ZCL_ZHR_MCP_DPC_EXT
```



실제 생성 이름은 프로젝트 설정에 따라 달라질 수 있어.

`SE24` 또는 `SE80`에서 DPC Extension Class를 열고 `EMPLOYEEORGSET_GET_ENTITY` 메서드를 재정의하면 돼.

로직의 핵심 구조는 다음과 같아.



```abap
" 1. OData 요청 Key 조회
"    Pernr, KeyDate

" 2. 키 값 및 날짜 유효성 검증

" 3. ECP 조직정보 조회
CALL FUNCTION 'ZHR_MCP_GET_ORG'
  EXPORTING
    iv_pernr = lv_pernr
    iv_date  = lv_date
  IMPORTING
    es_org   = ls_org
  EXCEPTIONS
    no_data      = 1
    no_authority = 2
    OTHERS       = 3.

" 4. 결과 변환 및 er_entity 매핑
" 5. 예외를 적절한 OData 오류로 변환
```



위 코드는 메서드 전체가 아닌 핵심 호출 부분이야. 실제 DPC 메서드에서는 `IT_KEY_TAB` 또는 요청 컨텍스트에서 키를 추출하고, 생성된 엔티티 타입으로 데이터를 옮겨야 해.

`NO_DATA`는 404 성격의 오류, `NO_AUTHORITY`는 접근 거부 오류로 구분해 처리하는 게 좋아. 단순히 `sy-subrc`가 실패했다고 전부 빈 결과로 반환하면 AI가 데이터 누락과 권한 오류를 구별하지 못해.

## 4-4. OData 서비스 등록 및 실행

`/IWFND/MAINT_SERVICE`로 이동해.

1. `Add Service` 선택
2. 해당 Backend System Alias 선택
3. `ZHR_MCP_SRV` 검색
4. 서비스 등록
5. 관련 SICF 서비스 및 인증 설정 확인
6. `/IWFND/GW_CLIENT`에서 실행 테스트

Gateway가 허용된 경우 테스트할 대표 경로는 다음과 같아.



```http
GET /sap/opu/odata/sap/ZHR_MCP_SRV/$metadata
```



이 요청이 성공하면 서비스의 엔티티와 필드 정의를 확인할 수 있어.

다음은 요청 형식을 설명하는 예시야.



```http
GET /sap/opu/odata/sap/ZHR_MCP_SRV/EmployeeOrgSet(Pernr='20250488',KeyDate='2026-10-29T00:00:00')
```



실제 키 이름과 날짜 리터럴 표기법은 생성된 EDM 메타데이터에 맞춰 조정해야 해.

Gateway 등록 및 테스트 방식은 SAP 공식 절차에서도 `/IWFND/MAINT_SERVICE`와 `/IWFND/GW_CLIENT`를 사용하고 있어. 

**이 단계까지 성공하면 ECP 내부 OData 조회 기능은 만들어진 거야.** 다만 외부 PC에서 접속하려면 다음의 네트워크·인증 설정이 추가로 필요해.

---

# 5\. ECP 외부 연결 설정 — Basis 담당 작업

ECP가 SAP에서 호스팅하는 클라우드 시스템이므로 사내 일반 SAP ERP 서버처럼 임의로 포트를 열면 안 돼.

이번 환경에서는 우선 **ECP 공식 HTTPS 인바운드 경로 + 클라이언트 인증서 인증**을 검토하는 게 좋아.

SAP의 ECP Connectivity 문서도 HTTPS 기반 Web Service/OData 연결에서 클라이언트 인증서 사용을 권장하고 있어. 

### Basis에 요청할 작업

| 항목 | 요청 내용 |
|--------|--------|
| 서비스 확인 | ZHR\_MCP\_SRV 서비스 외부 접근 지원 여부 |
| HTTPS URL | 개발·테스트 및 운영 ECP의 공식 API 엔드포인트 |
| 인증 | Client Certificate 기반 인바운드 인증 |
| 인증서 매핑 | 호출 인증서를 전용 ECP 기술 사용자에 매핑 |
| 권한 | 해당 OData 서비스 및 승인된 HR 데이터 조회만 허용 |
| 통신 확인 | 외부 MCP 실행 환경에서 HTTPS 호출 테스트 |
| 운영계 제한 | GET 조회만 허용하고 변경 기능 비활성화 |

`SM59`는 주로 ECP에서 외부 대상으로 나가는 연결을 정의할 때 사용하므로, 이번처럼 외부 MCP 서버에서 ECP로 들어오는 API 요청을 설정하기 위해 무조건 SM59부터 생성하는 것은 아니야.

또한 **SAP Cloud Connector 설치는 필수가 아니야.** ECP의 공식 HTTPS 인바운드 경로를 사용할 수 있다면 직접 연결할 수 있어. 반대로 회사 정책상 BTP를 경유해야 한다면 BTP Connectivity와 Destination을 추가하는 구조로 바꿔야 해.

## 6\. SuccessFactors EC 연결 설정

ECP OData와 별개로 SF의 인증을 구성해야 해.

### SuccessFactors 관리자 작업

`Admin Center → API Center → OAuth Configuration for OData`

이후 아래 작업을 진행해.

1. MCP용 OAuth 클라이언트 애플리케이션 등록
2. 테스트용 API 사용자 및 운영용 API 사용자 구분
3. `Manage Permission Roles`에서 API 조회에 필요한 RBP 설정
4. `EmpJob` 등의 대상 엔티티에 읽기 권한 부여
5. 사용자의 접근 대상 직원 범위 제한
6. OAuth Access Token 발급 및 API 테스트

SuccessFactors OAuth는 API 키를 등록했다고 곧바로 토큰이 발급되는 구조가 아니야. SAP의 OAuth 2.0 절차에 맞춰 서명된 SAML Assertion을 교환해 토큰을 받는 방식 등을 구성해야 해. 기존 인증 라이브러리 또는 사내 IdP를 활용하는 게 좋아. 

최초 연결 시험에 사용할 API 예시는 다음과 같아.



```http
GET https://<SF-API-HOST>/odata/v2/EmpJob
    ?$select=userId,startDate,company,costCenter
    &$top=1
```



개발용 인스턴스의 `$metadata`에서 실제 필드 이름과 지원되는 쿼리 구문을 확인하고 실행해.

# 7\. Python MCP 서버 구현

앞서 ECP와 SF의 OData API가 실제로 동작하는 것까지 확인했다면, MCP 서버를 작성하면 돼.

추천 개발 환경은 다음과 같아.



```text
sap-hr-mcp/
│
├── server.py
├── connectors/
│   ├── successfactors.py
│   └── ecp.py
│
├── security/
│   ├── authorization.py
│   └── masking.py
│
├── config/
│   ├── dev.env
│   └── prod.env
│
└── requirements.txt
```



인증서, OAuth 개인키, 비밀번호는 프로젝트 폴더나 Git 저장소에 직접 넣지 않고 안전한 비밀정보 저장소에서 읽도록 해.

다음은 외부 HTTPS 호출 로직이 준비됐을 때 MCP에 등록할 도구 예시야.

```python

from mcp.server.fastmcp import FastMCP

from connectors.successfactors import get_job_info
from connectors.ecp import get_org_assignment

mcp = FastMCP("sap-hr-mcp")

@mcp.tool()
async def sf_employee_job(
    user_id: str,
    key_date: str,
    environment: str = "DEV"
) -> dict:
    """SuccessFactors EC의 조직정보 조회."""
    return await get_job_info(
        user_id=user_id,
        key_date=key_date,
        environment=environment
    )

@mcp.tool()
async def ecp_employee_org(
    pernr: str,
    key_date: str,
    environment: str = "DEV"
) -> dict:
    """ECP의 IT0001 조직정보 조회."""
    return await get_org_assignment(
        pernr=pernr,
        key_date=key_date,
        environment=environment
    )

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

이 파일은 MCP Tool 등록 구조를 보여주는 예시야. `connectors`의 실제 API 호출 코드, 인증서 인증, 사번 매핑, 접근 권한 검사 등은 추가 구현해야 실행할 수 있어.

`environment`는 사용자가 마음대로 URL을 입력하는 방식이 아니라, 서버 내부에서 사전 승인된 `DEV`, `QAS`, `PRD` 설정 중 하나만 선택하도록 만들어야 해. 특히 운영계는 별도 사용자·권한·실행 승인을 적용하는 게 안전해.

## 8\. Claude Code와 Antigravity 등록

우선 로컬 MCP 서버를 실행하는 방식을 사용해보자.

### Claude Code



```bash
claude mcp add sap-hr -- python C:/sap-hr-mcp/server.py
```



실제 Python 실행 경로가 가상환경에 있다면 해당 경로로 바꿔줘.

### Antigravity

MCP 설정 파일에 다음 내용을 추가해.



```json
{
  "mcpServers": {
    "sap-hr": {
      "command": "python",
      "args": [
        "C:\\sap-hr-mcp\\server.py"
      ]
    }
  }
}
```



이후 IDE에서 MCP 서버를 활성화하고 Tool 목록에 `sf_employee_job`, `ecp_employee_org`가 표시되는지 확인하면 돼.

이 두 Tool이 실제 API를 호출할 수 있는 상태가 되면 AI를 이용한 조직정보 비교 작업을 시작할 수 있어.

---

# 9\. 급여·복제 오류 및 ABAP 개발 분석으로 확장하기

처음 구축한 조직정보 조회 API를 기반으로 다음 기능을 추가하는 순서를 추천해.

| 순위 | 신규 MCP Tool | ECP 개발 대상 |
|--------|--------|--------|
| 1 | `ecp_get_replication_log` | SLG1 Application Log 조회 래퍼 |
| 2 | `ecp_get_pernr_mapping` | EC-ECP 사원번호 매핑 조회 |
| 3 | `ecp_get_payroll_directory` | RGDIR 조회 |
| 4 | `ecp_get_payroll_rt` | 국가별 급여 클러스터의 RT 조회 |
| 5 | `ecp_compare_payroll` | 급여결과별 임금유형 차이 계산 |
| 6 | `ecp_get_abap_source` | 허용된 Z 객체의 소스 조회 |

급여결과 조회 기능을 개발할 때는 RT·CRT를 데이터베이스에서 임의로 읽는 구조보다 국가별 표준 클러스터 읽기 기능을 사용하는 편이 좋아. 한국 ECP라면 RGDIR에서 결과번호와 유효 상태를 확인한 뒤 해당 국가의 급여결과 구조를 이용하도록 설계해야 해.

또한 `ecp_get_abap_source`는 읽을 수 있는 객체 이름을 Z 패키지 또는 허용 목록으로 제한해야 해. 운영계에서 임의 테이블 조회나 임의 ABAP 실행 기능은 제공하지 않는 것을 권장해.

## 10\. 개발계와 운영계 분리 방식

**개발·테스트 환경**

조회 API 개발, MCP 기능 시험, 코드 개선안 작성, 테스트 데이터 비교까지 수행.

변경 기능은 별도 승인된 개발용 Tool로만 허용.

---

**운영 환경**

사원정보 및 오류로그의 읽기 전용 조회만 허용. 급여 데이터는 업무상 필요한 항목으로 제한하고 마스킹 적용.

모든 MCP 호출에 사용자, 호출 시각, 도구, 조회 대상과 결과 상태를 감사 로그로 남김.

ECP 권한 역할은 개발계에서 설계한 다음 테스트·운영계로 통제된 전송 절차를 통해 반영해야 해. SAP도 운영계에서 `SAP_ALL` 사용을 피하고 역할을 통제된 방식으로 전송하도록 안내해. 

---

## 11\. 지금 가장 먼저 해야 할 일

현 단계에서 Python이나 MCP 설정부터 작성하는 것보다, **ECP가 외부에서 사용자 정의 OData 서비스를 제공할 수 있는 환경인지 확인하는 것**이 먼저야.

다음 문구를 Basis 담당자에게 전달하면 돼.

{"fallbackMarkdown":"안녕하세요.\n\nSAP SuccessFactors EC 및 ECP의 데이터 조회와 오류 분석을 위한 외부 연동 환경을 검토하고 있습니다.\n\nECP 내에서 ABAP으로 개발한 조회 기능을 OData API로 제공하고, 외부 MCP 서버에서 HTTPS 방식으로 호출하는 구성을 고려하고 있습니다.\n\n이에 다음 사항 확인 부탁드립니다.\n\n1. 현재 ECP 시스템의 SEGW 및 SAP Gateway OData V2 서비스 개발·사용 가능 여부\n2. 개발·테스트계와 운영계의 외부 HTTPS API 호출 가능 여부 및 접속 URL\n3. 외부 시스템 접근을 위한 클라이언트 인증서 인증 구성 가능 여부\n4. 고객 개발 OData 서비스의 외부 노출 및 기술 사용자 권한 설정 가능 여부\n5. 해당 연동 구성이 SAP ECP 운영 정책 및 보안 기준상 허용되는지 여부\n\n초기에는 사원 조직정보 조회 등 읽기 전용 기능부터 개발하여 테스트할 예정입니다.\n\n확인 부탁드립니다.\n\n감사합니다.","reference":{"type":"client_defined_widget"},"referenceKey":"63821","sharedWritingBlock":{"kind":"writing","content":"안녕하세요.\n\nSAP SuccessFactors EC 및 ECP의 데이터 조회와 오류 분석을 위한 외부 연동 환경을 검토하고 있습니다.\n\nECP 내에서 ABAP으로 개발한 조회 기능을 OData API로 제공하고, 외부 MCP 서버에서 HTTPS 방식으로 호출하는 구성을 고려하고 있습니다.\n\n이에 다음 사항 확인 부탁드립니다.\n\n1. 현재 ECP 시스템의 SEGW 및 SAP Gateway OData V2 서비스 개발·사용 가능 여부\n2. 개발·테스트계와 운영계의 외부 HTTPS API 호출 가능 여부 및 접속 URL\n3. 외부 시스템 접근을 위한 클라이언트 인증서 인증 구성 가능 여부\n4. 고객 개발 OData 서비스의 외부 노출 및 기술 사용자 권한 설정 가능 여부\n5. 해당 연동 구성이 SAP ECP 운영 정책 및 보안 기준상 허용되는지 여부\n\n초기에는 사원 조직정보 조회 등 읽기 전용 기능부터 개발하여 테스트할 예정입니다.\n\n확인 부탁드립니다.\n\n감사합니다.","index":0,"variant":"email","id":"63821","subject":"SAP ECP 외부 API 연동 가능 여부 및 Gateway 설정 확인 요청"},"showLoginRequiredCard":false}

**정리하면**, 네 환경에서 내가 가장 추천하는 구축 방식은 다음과 같아.

**SAP GUI에서 SE37로 ECP 조회 로직 개발 → SEGW에서 OData 서비스 생성 → ECP 공식 HTTPS 인바운드 연결 → Python MCP 서버 구현 → Antigravity/Claude Code에서 EC·ECP 데이터 비교.**

이 방식이라면 기존 ABAP 개발 경험을 그대로 활용할 수 있고, 향후 급여결과·소급·복제 오류 분석으로 확장할 수 있어.

다만 최종적으로 MCP를 통한 SuccessFactors 설정 자동 변경이나 ECP 코드 배포까지 구현하려면, 단순 조회 API 외에 별도 개발 인터페이스와 변경 승인 체계가 필요해. 조회 연동이 성공한 뒤 그 부분을 분리해 구축하는 게 적절해.

---

원하시면 다음을 도와드릴 수 있습니다.

- 계속: KI100 오류 사례 분석 요청
- 계속: ECP 복제 로그 조회 기능 구현 안내
- 계속: 복제 오류 대응 자동화 시나리오 작성

---

