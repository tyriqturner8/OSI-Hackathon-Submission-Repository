# Prompt to paste into the new Claude session

Open Claude Code (desktop app, Code tab) with **this folder** as the project folder, set the permission mode to
**Manual**, and paste:

---

We are at the Proto iXRD Mini in the Vlachos lab and want you to run a residual-stress measurement end to end and
analyze the data, while we record the screen for a demo. Read CLAUDE.md in this folder first and follow its procedure;
it is the authority over the other documents. Also skim reference/session_2026-10-22/SESSION_LOG.md.

Conditions: sample GRX 3, direction Short, NICKEL (Mn_Ka) 311, 18 kV / 1.00 mA, 2 mm aperture, 35 s per exposure,
11 beta tilts with a maximum of ±30°. Choose the 7- or 15-minute warm-up from the last X-ray use as CLAUDE.md describes.

First run setup.ps1 and tell us what the pre-flight shows. When we type "ready", start the screen recording, launch
XrdWin, put XrdWin on the left and this chat on the right, and go step by step. Read back the settings before every
X-ray or motion step and wait for our word for that step. We turn the key, press X-Ray Enable, focus the sample and
answer any X-ray or fitting-error prompt. At the end, generate the analysis report and compare with the 15 Oct result
(−126.43 ± 74.29 MPa). Do not ask us to approve tool calls; the folder's settings allow them.

---

Words the operator types during the run (CLAUDE.md §3): `ready`, `enabled`, `x-rays off`, `focused` (+ safe max β),
`go profile`, `angles ok`, `go stress run`, `analyze`, `stop` / `pause`, `stop recording`, `home`, `close`.
