# ccusage-graphs 데이터 갱신 스크립트 (Windows)
# 실행: ./refresh.ps1

param(
    [string]$Since  = "",
    [string]$Until  = "",
    [string]$Project = "",
    [switch]$Open
)

$dataDir = Join-Path $PSScriptRoot "data"
New-Item -ItemType Directory -Force -Path $dataDir | Out-Null

Write-Host ">>> 데이터 갱신 중..." -ForegroundColor Cyan

# ccusage로 데이터 내보내기
try {
    # 일별
    $args = @("daily", "--json")
    if ($Since)   { $args += "--since"; $args += $Since }
    if ($Until)   { $args += "--until"; $args += $Until }
    if ($Project) { $args += "--project"; $args += $Project }

    $daily = & ccusage @args 2>$null | ConvertFrom-Json -ErrorAction Stop
    $daily | ConvertTo-Json -Depth 10 | Set-Content "$dataDir\export.json" -Encoding UTF8
    Write-Host "  [OK] export.json 생성" -ForegroundColor Green
} catch {
    Write-Host "  [!!] ccusage 실행 실패: $_" -ForegroundColor Yellow
    Write-Host "       ccusage가 설치되어 있는지 확인: npm install -g ccusage" -ForegroundColor Yellow
}

try {
    # 세션별
    $sessions = & ccusage session --json 2>$null | ConvertFrom-Json -ErrorAction Stop
    $sessions | ConvertTo-Json -Depth 10 | Set-Content "$dataDir\export_sessions.json" -Encoding UTF8
    Write-Host "  [OK] export_sessions.json 생성" -ForegroundColor Green
} catch {
    Write-Host "  [!!] 세션 데이터 수집 실패" -ForegroundColor Yellow
}

# index.html의 데이터 갱신
$indexPath = Join-Path $PSScriptRoot "index.html"
if (Test-Path $indexPath) {
    Write-Host "  [OK] index.html 데이터 갱신 완료" -ForegroundColor Green
} else {
    Write-Host "  [!!] index.html 없음. 처음 실행이라면 정상" -ForegroundColor Yellow
}

Write-Host ""
Write-Host ">>> 완료!" -ForegroundColor Cyan
Write-Host "  대시보드 열기: " -NoNewline
Write-Host "start index.html" -ForegroundColor Yellow

if ($Open) {
    Start-Process $indexPath
}
