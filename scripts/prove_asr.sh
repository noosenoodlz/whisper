#!/usr/bin/env bash
# Balamb Garden look-only ASR smoke: transcribe tests/jfk.flac with a small model.
# Does not fake a pass. Missing ffmpeg/torch/weights → non-zero exit with a clear note.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUDIO="${ROOT}/tests/jfk.flac"
MODEL="${WHISPER_MODEL:-tiny.en}"

fail() {
  echo "prove_asr: FAIL: $*" >&2
  echo "prove_asr: see BALAMB.md (prerequisites). This script does not invent a pass." >&2
  exit 1
}

if [[ ! -f "${AUDIO}" ]]; then
  fail "missing fixture ${AUDIO}"
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  fail "ffmpeg not on PATH (install ffmpeg)"
fi

if ! command -v python3 >/dev/null 2>&1; then
  fail "python3 not on PATH"
fi

export PYTHONPATH="${ROOT}${PYTHONPATH:+:${PYTHONPATH}}"

python3 - "${MODEL}" "${AUDIO}" <<'PY'
import importlib.util
import sys

model_name, audio_path = sys.argv[1], sys.argv[2]

missing = [m for m in ("torch", "numpy", "tiktoken", "numba", "tqdm", "more_itertools") if importlib.util.find_spec(m) is None]
if missing:
    print(
        "prove_asr: FAIL: missing Python packages: "
        + ", ".join(missing)
        + "\nprove_asr: install with: pip install -r requirements.txt\n"
        "prove_asr: see BALAMB.md (prerequisites). This script does not invent a pass.",
        file=sys.stderr,
    )
    sys.exit(1)

import whisper

print(f"prove_asr: loading model {model_name!r} (first run downloads weights)", file=sys.stderr)
model = whisper.load_model(model_name)
print(f"prove_asr: transcribing {audio_path}", file=sys.stderr)
result = model.transcribe(audio_path, language="en", temperature=0.0)
text = (result.get("text") or "").strip()
if not text:
    print("prove_asr: FAIL: empty transcription", file=sys.stderr)
    sys.exit(1)
print(text)
PY
