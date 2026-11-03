# Workspace 폴더에서 실행: 우클릭 > "PowerShell에서 실행" 또는
#   cd $env:USERPROFILE\Desktop\Workspace ; .\push_to_github.ps1
# 사전 조건: git 설치, GitHub에 noeyodmik/workspace 저장소 생성(Private)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$minGitPath = "$env:LOCALAPPDATA\Programs\MinGit\cmd"
if ((Test-Path $minGitPath) -and ($env:PATH -notlike "*$minGitPath*")) {
    $env:PATH = "$minGitPath;$env:PATH"
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git이 설치되어 있지 않습니다. https://git-scm.com 에서 설치 후 다시 실행하세요."
}

if (-not (Test-Path ".git")) { git init -b main }
git config core.quotepath false

$userName = git config user.name
if (-not $userName) {
    git config user.name "noeyodmik"
}
$userEmail = git config user.email
if (-not $userEmail) {
    git config user.email "noeyodmik@users.noreply.github.com"
}

$remote = git remote 2>$null
if ($remote -notcontains "origin") {
    git remote add origin https://github.com/noeyodmik/workspace.git
}

git add -A

# 1) .env 가 올라가려 하면 즉시 중단
$staged = git diff --cached --name-only
if ($staged -contains ".env") {
    git reset | Out-Null
    throw ".env 가 업로드 대상에 포함되었습니다. .gitignore 를 확인하세요."
}

# 2) 비밀값처럼 보이는 줄 검사 (내용은 출력하지 않고 위치만 표시)
$pattern = '(?i)(passwd|password|secret|token|api[_-]?key)\s*[=:]\s*["'']?[^\s"''\)]{4,}'
$hits = @()
foreach ($rawFile in $staged) {
    $f = $rawFile.Trim('"')
    if (Test-Path -LiteralPath $f) {
        $m = Select-String -LiteralPath $f -Pattern $pattern -ErrorAction SilentlyContinue
        if ($m) { $hits += $m | ForEach-Object { "$($_.Path):$($_.LineNumber)" } }
    }
}
if ($hits.Count -gt 0) {
    Write-Host "`n비밀값 의심 위치 ($($hits.Count)건):" -ForegroundColor Yellow
    $hits | Select-Object -First 50 | ForEach-Object { Write-Host "  $_" }
    $ans = Read-Host "`n직접 확인했고 계속 진행할까요? (y/N)"
    if ($ans -ne "y") { git reset | Out-Null; Write-Host "중단했습니다. 해당 파일을 수정하거나 .gitignore 에 추가하세요."; exit 1 }
}

# 3) 커밋 & 푸시
git commit -m "Sync workspace $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push -u origin main
Write-Host "`n완료: https://github.com/noeyodmik/workspace" -ForegroundColor Green
