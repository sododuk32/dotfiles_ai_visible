# ============================================================
# Claude Code 개발환경 자동 설치 스크립트 (Windows)
# 새 PC/노트북에서: git clone 후 ./setup.ps1 한 번만 실행
# ============================================================

param(
    [switch]$SkipNode,
    [switch]$SkipTools,
    [switch]$SkipHooks
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host "`n>>> $msg" -ForegroundColor Cyan
}

function Write-OK($msg) {
    Write-Host "  [OK] $msg" -ForegroundColor Green
}

function Write-Warn($msg) {
    Write-Host "  [!!] $msg" -ForegroundColor Yellow
}

# ── 0. 관리자 권한 확인 ──────────────────────────────────────
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warn "관리자 권한 없음. 일부 설치가 실패할 수 있습니다."
}

# ── 1. Node.js 확인 ──────────────────────────────────────────
Write-Step "Node.js 확인"
if (-not $SkipNode) {
    try {
        $nodeVer = node --version 2>$null
        Write-OK "Node.js 이미 설치됨: $nodeVer"
    } catch {
        Write-Warn "Node.js 없음. winget으로 설치 중..."
        winget install OpenJS.NodeJS.LTS --silent
        Write-OK "Node.js 설치 완료. 터미널 재시작 필요할 수 있음"
    }
}

# ── 2. Claude Code CLI 도구 설치 ────────────────────────────
Write-Step "Claude Code 메트릭 도구 설치"
if (-not $SkipTools) {
    $tools = @(
        @{ name = "ccusage"; pkg = "ccusage" }
    )
    foreach ($tool in $tools) {
        try {
            $ver = npm list -g $tool.pkg --depth=0 2>$null
            if ($ver -match $tool.pkg) {
                Write-OK "$($tool.name) 이미 설치됨"
            } else {
                npm install -g $tool.pkg --silent
                Write-OK "$($tool.name) 설치 완료"
            }
        } catch {
            Write-Warn "$($tool.name) 설치 실패: $_"
        }
    }
}

# ── 3. Claude 설정 디렉토리 생성 ────────────────────────────
Write-Step "Claude 설정 디렉토리 구성"
$claudeDir = "$env:USERPROFILE\.claude"
$hooksDir  = "$claudeDir\hooks"

New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
New-Item -ItemType Directory -Force -Path $hooksDir  | Out-Null
Write-OK "$claudeDir 준비 완료"

# ── 4. Claude Hooks 설치 ────────────────────────────────────
Write-Step "Claude Code Hooks 설정"
if (-not $SkipHooks) {
    $dotfilesRoot = $PSScriptRoot

    # logger.py 복사
    $loggerSrc = Join-Path $dotfilesRoot ".claude\hooks\logger.py"
    $loggerDst = Join-Path $claudeDir "hooks\logger.py"
    if (Test-Path $loggerSrc) {
        Copy-Item $loggerSrc $loggerDst -Force
        Write-OK "logger.py 복사 완료"
    }

    # settings.json 복사 (기존 파일 백업 후 덮어쓰기)
    $settingsSrc = Join-Path $dotfilesRoot ".claude\settings.json"
    $settingsDst = Join-Path $claudeDir "settings.json"
    if (Test-Path $settingsDst) {
        Copy-Item $settingsDst "$settingsDst.bak" -Force
        Write-Warn "기존 settings.json 백업: settings.json.bak"
    }
    if (Test-Path $settingsSrc) {
        Copy-Item $settingsSrc $settingsDst -Force
        Write-OK "settings.json 적용 완료"
    }
}

# ── 5. ccusage-graphs 대시보드 설치 ─────────────────────────
Write-Step "ccusage-graphs 대시보드 설치"
$dashboardSrc = Join-Path $PSScriptRoot "tools\ccusage-graphs"
$dashboardDst = "$env:USERPROFILE\claude-dashboard"

if (Test-Path $dashboardSrc) {
    Copy-Item $dashboardSrc $dashboardDst -Recurse -Force
    Write-OK "대시보드 설치: $dashboardDst"
} else {
    Write-Warn "tools\ccusage-graphs 폴더 없음. 건너뜀"
}

# ── 6. 완료 안내 ─────────────────────────────────────────────
Write-Host "`n============================================" -ForegroundColor Magenta
Write-Host " 설치 완료! 사용법:" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  칸반 실행:          " -NoNewline; Write-Host "npx claude-code-kanban --open" -ForegroundColor Yellow
Write-Host "  비용 확인 (일별):   " -NoNewline; Write-Host "ccusage daily" -ForegroundColor Yellow
Write-Host "  비용 확인 (세션):   " -NoNewline; Write-Host "ccusage session" -ForegroundColor Yellow
Write-Host "  비용 확인 (프로젝트):" -NoNewline; Write-Host "ccusage --project" -ForegroundColor Yellow
Write-Host "  그래프 대시보드:    " -NoNewline; Write-Host "cd ~/claude-dashboard && ./refresh.ps1" -ForegroundColor Yellow
Write-Host ""
