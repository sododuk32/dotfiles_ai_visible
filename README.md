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
