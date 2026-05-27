#!/usr/bin/env python3
"""
Claude Code 훅 로거
- 툴 호출 패턴, 세션 정보를 JSONL로 기록
- 모호한 지시 패턴 분석용 (반복 호출, 세션 길이 등)
"""

import sys
import json
import os
from datetime import datetime

LOG_FILE = os.path.expanduser("~/.claude/hooks/prompt_log.jsonl")


def log(event_type: str, data: dict):
    entry = {
        "ts":    datetime.now().isoformat(),
        "event": event_type,
        "data":  data,
    }
    os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")


def read_stdin() -> dict:
    try:
        raw = sys.stdin.read()
        return json.loads(raw) if raw.strip() else {}
    except Exception:
        return {}


def main():
    event_type = sys.argv[1] if len(sys.argv) > 1 else "unknown"
    data = read_stdin()

    if event_type == "post_tool":
        log("tool_use", {
            "session_id":    data.get("session_id"),
            "tool":          data.get("tool_name"),
            "input_summary": str(data.get("tool_input", ""))[:300],
            "is_error":      data.get("is_error", False),
        })

    elif event_type == "pre_bash":
        # Bash 명령 실행 전 기록 → 반복 실행 패턴 감지용
        log("bash_pre", {
            "session_id": data.get("session_id"),
            "command":    str(data.get("tool_input", {}).get("command", ""))[:300],
        })

    elif event_type == "stop":
        log("session_stop", {
            "session_id":  data.get("session_id"),
            "stop_reason": data.get("stop_reason"),
        })

    else:
        log(event_type, data)


if __name__ == "__main__":
    main()
