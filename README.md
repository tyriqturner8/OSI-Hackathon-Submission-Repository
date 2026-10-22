# iXRD Mini – Claude operator package (22 Oct 2026)

This folder lets a new Claude session run the iXRD Mini residual-stress measurement the same way it was run on
22 Oct 2026: launching XrdWin, Initialize, warm-up, test profile with focus check, stress run, analysis report, and screen
recording, with the lab operator at the instrument.

## How to use it

1. Copy or keep this folder at `C:\Users\PROTO\Documents\Vlachos lab\iXRDmini\iXRDmini_claude_package_2026-10-22`.
   Any other location also works because all tools find their files relative to the folder.
2. In the Claude desktop app (Code tab), start a new session with **this folder** as the project folder.
   Claude loads `CLAUDE.md` automatically, and `.claude/settings.local.json` lets it use PowerShell without asking each time.
3. Set the session's permission mode to **Manual (default)**. Auto mode blocks the X-ray steps.
4. Paste the prompt from `START_PROMPT.md`.
5. At the instrument: controller on, detector USB plugged in, sample mounted, aperture fitted, key off until Claude asks.

## What the operator still does by hand

X-ray key, green X-Ray Enable button, focusing with the pointer and the pendant Teach button, aperture,
emergency stop, and confirming the amber X-Ray On beacon is dark at the end. Claude never answers X-ray,
interlock or fitting-error prompts for you.

## Contents

- `CLAUDE.md`: the procedure, rules and GUI-automation facts (Claude reads this first)
- `START_PROMPT.md`: the prompt to paste
- `setup.ps1`: creates the short path `C:\Users\PROTO\xrd` (= this folder; tools under `xrd\tools`) and runs a read-only pre-flight check. If another copy of the package already owns that path, it stops; use `setup.ps1 -Force` to point it at this copy.
- `tools\`: GUI driver `xw.ps1`, screen recorder, focus check, analysis report generator, file readers
- `reference\`: demo run-sheet, 22 Oct session log, the 15 Oct GRX 3 report, XrdWin dialog map, runbook, earlier findings
- `run\`, `recording\`, `results\`: outputs land here

## Status

Verified live on 22 Oct: launch, login, Initialize, 7- and 15-minute warm-up, test profile, focus check,
screen recording and window layout. The 11-tilt stress run has not yet been executed under Claude control. Its steps in
`CLAUDE.md` are planned from XrdWin's dialog resources and tell Claude to verify each dialog before clicking.
Both test profiles on 22 Oct showed the peaks about 14 channels off-centre, so refocus the sample before the next run.
