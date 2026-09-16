# Balamb Garden — Whisper (look-only ASR limb)

This fork is the **estate working copy** of [openai/whisper](https://github.com/openai/whisper). Stock OpenAI ASR stays stock. Estate purpose lives here, not in the upstream tree.

## Owner

**Irvine / Balamb Garden look-only intelligence.**

## Purpose

Local **ASR limb**: audio → clean text for the book.

Speech-to-text ears only. Not a trading or market tool. No market fire.

## Locks

- **Look-only.** Transcribe. Do not act on markets, do not emit orders, do not wire this limb to execution.
- **No merge to `main` without Architect cut.** Work stays on a branch and a PR until Architect reviews and cuts.
- **No DigitalOcean / DNS without Architect.** No new infra. No DO droplets, records, or DNS changes from this limb.
- **No thaw of other repos.** Do not touch Portal, Shell, ParadoxIA.AI, Slave, Eternal, or Second-Me from this work.

## Upstream

- **Upstream:** [openai/whisper](https://github.com/openai/whisper)
- **This fork:** [noosenoodlz/whisper](https://github.com/noosenoodlz/whisper) — estate working copy
- Prefer upstream for stock Whisper code. Keep estate files (`BALAMB.md`, `scripts/prove_asr.sh`, this README note) on the working branch.

To refresh this branch from upstream (never onto `main` without Architect):

```bash
git fetch https://github.com/openai/whisper.git main
git merge FETCH_HEAD
```

## Prove the limb (smoke transcription)

`scripts/prove_asr.sh` transcribes the repo’s existing `tests/jfk.flac` with a small/fast English model (`tiny.en` by default) and prints the text.

### Run

From the repository root:

```bash
bash scripts/prove_asr.sh
```

Optional: `WHISPER_MODEL=base.en bash scripts/prove_asr.sh`

### Prerequisites

The script does **not** fake a pass. It checks these and exits non-zero if they are missing:

| Need | Why |
|------|-----|
| `ffmpeg` | Whisper loads audio through ffmpeg |
| Python 3.8+ with this tree on `PYTHONPATH` | Local package, not a published wheel |
| `torch`, `numpy`, `tiktoken`, `numba`, `tqdm`, `more-itertools` | Whisper runtime (`pip install -r requirements.txt` or `pip install .`) |
| Network (first run) | Weights download from `openaipublic.azureedge.net` into `~/.cache/whisper/` |

`tiny.en` is ~75 MB. CPU is enough; GPU is optional.

Expected gist of `tests/jfk.flac` (JFK inaugural excerpt): *“And so, my fellow Americans…”*

### Example (after deps are installed)

```text
$ bash scripts/prove_asr.sh
# ... model load ...
And so my fellow Americans ask not what your country can do for you ask what you can do for your country.
```
