#!/usr/bin/env python3
import json
import re
import subprocess
import sys
from pathlib import Path

payload = json.load(sys.stdin)
tool_input = payload.get("tool_input", {})
command = tool_input.get("command") or tool_input.get("cmd") or ""
git_push = re.compile(r"(?:^|[;&|]\s*|\s)git(?:\s+-C\s+\S+)*\s+push(?:\s|$)")
if not git_push.search(command):
    print("{}")
    raise SystemExit(0)

root_result = subprocess.run(
    ["git", "rev-parse", "--show-toplevel"],
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL,
    check=False,
)
if root_result.returncode != 0:
    print("{}")
    raise SystemExit(0)

root = Path(root_result.stdout.strip())
pinned_flutter = root / "flutter" / "bin" / "flutter"
flutter = str(pinned_flutter) if pinned_flutter.is_file() else "flutter"
result = subprocess.run(
    [flutter, "test"],
    cwd=root,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
if result.returncode == 0:
    print("{}")
else:
    output = result.stdout.strip()
    if len(output) > 4000:
        output = output[-4000:]
    reason = "git push blocked because flutter test failed:\n\n" + output
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
