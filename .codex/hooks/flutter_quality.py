#!/usr/bin/env python3
import hashlib
import json
import subprocess
from pathlib import Path


def run(command: list[str], root: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )


def working_tree_fingerprint(root: Path) -> str:
    digest = hashlib.sha256()
    for command in (
        ["git", "status", "--porcelain=v1", "-z"],
        ["git", "diff", "--binary", "--no-ext-diff"],
    ):
        result = subprocess.run(command, cwd=root, stdout=subprocess.PIPE, check=False)
        digest.update(result.stdout)

    untracked = subprocess.run(
        ["git", "ls-files", "--others", "--exclude-standard", "-z"],
        cwd=root,
        stdout=subprocess.PIPE,
        check=False,
    ).stdout.split(b"\0")
    for relative_bytes in untracked:
        if not relative_bytes:
            continue
        relative = relative_bytes.decode("utf-8", errors="surrogateescape")
        path = root / relative
        digest.update(relative_bytes)
        if path.is_file():
            digest.update(path.read_bytes())
    return digest.hexdigest()


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
pinned_bin = root / "flutter" / "bin"
dart = str(pinned_bin / "dart") if (pinned_bin / "dart").is_file() else "dart"
flutter = str(pinned_bin / "flutter") if (pinned_bin / "flutter").is_file() else "flutter"

before = working_tree_fingerprint(root)
state_result = run(["git", "rev-parse", "--git-path", "codex-flutter-quality"], root)
state_path = Path(state_result.stdout.strip())
if not state_path.is_absolute():
    state_path = root / state_path
if state_path.is_file() and state_path.read_text().strip() == before:
    print("{}")
    raise SystemExit(0)

checks = [
    ("dart fix --apply", [dart, "fix", "--apply"]),
    ("dart format .", [dart, "format", "."]),
    ("flutter analyze", [flutter, "analyze"]),
]
failures: list[str] = []
for label, command in checks:
    result = run(command, root)
    if result.returncode != 0:
        output = result.stdout.strip()
        if len(output) > 3000:
            output = output[-3000:]
        failures.append(f"{label} failed:\n{output}")

after = working_tree_fingerprint(root)
if failures:
    reason = (
        "The mandatory Flutter quality pass failed. Fix these problems, then "
        "finish again so the checks rerun:\n\n" + "\n\n".join(failures)
    )
    print(json.dumps({"decision": "block", "reason": reason}))
else:
    state_path.write_text(after + "\n")

if failures:
    pass
elif before != after:
    print(json.dumps({
        "decision": "block",
        "reason": (
            "The mandatory quality pass applied Dart fixes or formatting. "
            "Review the resulting changes and include them in the task before finishing."
        ),
    }))
else:
    print("{}")
