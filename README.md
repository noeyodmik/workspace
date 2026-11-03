# workspace

SAP/ABAP 작업 환경(Antigravity 기준)을 GitHub에 보관해 다른 PC에서 이어서 작업하기 위한 저장소입니다. **Private 저장소로 유지하세요.**

## 구성
- `sap-mcp/` : SAP 연동 MCP 서버(Python)
- `abap/zmcp/` : SAP 쪽에 올리는 Z 함수모듈 소스
- `.vscode/mcp.json`, `claude_mcp_servers_snippet.json` : MCP 서버 설정
- `GEMINI.md` : Antigravity 작업 지침
- `.env.example` : 필요한 환경변수 목록 (실제 값은 `.env`에, 저장소에는 올리지 않음)

## 새 PC에서 이어서 작업하기
1. `git clone https://github.com/noeyodmik/workspace.git` (최초 1회 GitHub 로그인)
2. 가상환경 생성 및 패키지 설치
   ```
   python -m venv .venv
   .venv\Scripts\activate
   pip install -r sap-mcp\requirements.txt
   ```
3. `.env.example` 을 `.env` 로 복사하고 접속 정보를 직접 입력
4. SAP NetWeaver RFC SDK(`nwrfc750P_...`)는 SAP에서 직접 받아 설치 (저장소에 포함되지 않음)
5. Antigravity의 MCP 설정에서 `sap-mcp` 서버 경로를 새 PC의 경로로 수정

## 작업 후 올리기
`.\push_to_github.ps1` 실행 (비밀값 검사 후 커밋/푸시)
