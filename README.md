# Claude Code 개발환경 dotfiles

PC, 노트북 어디서든 동일한 Claude Code 개발환경을 한 번에 세팅합니다.

## 포함 도구

| 도구 | 역할 |
|---|---|
| `claude-code-kanban` | 세션/태스크 칸반 보드 |
| `ccusage` | 세션·프로젝트·일별 비용 CLI |
| `ccusage-graphs` | 토큰/비용 HTML 대시보드 |
| `hooks/logger.py` | 툴 호출 패턴 로컬 기록 |

## 새 PC/노트북 세팅 (5분)

### 사전 준비
- [Node.js LTS](https://nodejs.org/) 설치
- [Python 3.8+](https://www.python.org/) 설치
- [Git](https://git-scm.com/) 설치

### 설치
```powershell
git clone https://github.com/<본인계정>/dotfiles
cd dotfiles
./setup.ps1
```

끝.

---

## 일상 사용법

### 칸반 실행
```powershell
npx claude-code-kanban --open
```
브라우저에서 세션별 칸반 + 컨텍스트 윈도우 사용량 확인

### 비용 확인
```powershell
ccusage daily      # 일별
ccusage session    # 세션별
ccusage monthly    # 월별
```

### 그래프 대시보드
```powershell
cd ~/claude-dashboard
./refresh.ps1 -Open   # 데이터 갱신 후 브라우저 자동 오픈
```

---

## 구조

```
dotfiles/
├── setup.ps1                    # 설치 스크립트
├── .gitignore
├── .claude/
│   ├── settings.json            # Claude Code Hooks 설정
│   └── hooks/
│       └── logger.py            # 툴 호출 패턴 로거
└── tools/
    └── ccusage-graphs/
        ├── index.html           # 대시보드 HTML
        ├── refresh.ps1          # 데이터 갱신 스크립트
        └── data/                # ← .gitignore됨 (개인 데이터)
```

---

## 터미널 환경 — Windows Terminal

### 설치 확인
Windows 11은 기본 내장. 없으면:
```powershell
winget install Microsoft.WindowsTerminal
```
시작 메뉴에서 **"Terminal"** 검색 → PowerShell로 열리면 정상.

### 창 분할

단축키가 버전마다 달라서 **커맨드 팔레트**가 가장 확실:

```
Ctrl+Shift+P  →  "split" 입력
```

| 항목 | 동작 |
|---|---|
| Split pane right | 좌우 분할 |
| Split pane down | 상하 분할 |
| Duplicate pane | 현재 창 복제 |

분할 후 창 이동: `Alt+방향키`  
분할 창 닫기: `Ctrl+Shift+W`

### 추천 레이아웃

Claude Code 작업 시:
```
┌──────────────────────┬─────────────────────┐
│ Claude Code 작업     │ kanban 대시보드      │
│ (메인 터미널)        │ npx claude-code-     │
│                      │ kanban --open        │
├──────────────────────┴─────────────────────┤
│ ccusage daily / 로그 확인                  │
└────────────────────────────────────────────┘
```

### 탭 관리

| 단축키 | 동작 |
|---|---|
| `Ctrl+Shift+T` | 새 탭 |
| `Ctrl+Tab` | 다음 탭 |
| `Ctrl+Shift+Tab` | 이전 탭 |
| 탭 우클릭 | 탭 이름 변경 |

---

## 업데이트

환경이 바뀌면 dotfiles 수정 후:
```powershell
git add .
git commit -m "update: 설정 변경 내용"
git push
```

다른 기기에서:
```powershell
cd dotfiles
git pull
./setup.ps1
```
