---
name: ixrdmini-control-project
description: "Goal, status and hard-won GUI-automation facts for running the Proto iXRDmini XRD (Vlachos lab) through XrdWin from Claude"
metadata:
  node_type: memory
  type: project
  originSessionId: d74f552b-6d2c-4385-9e24-cec7541f7b90
  modified: 2026-10-22T15:01:29.083Z
---

Goal: Claude runs residual-stress measurements on the Proto iXRD Mini (XrdWin 2.0 build 87, two MiniPIX detectors) for the Vlachos lab. A live demo video is planned for Friday 2:30 pm at MMRL (docs in `D:\Re__Friday_2_30pm_demo_@_MMRL`: GRX 3 stress report of 15OCT26_0007.mt, ICoN PCL handwritten operating notes, Proto material-vs-target chart).

Status 2026-10-22: first live session. Detectors had dropped off USB (fixed by replug); XrdWin launched, login dialog needs NO password for user "Donovan" (just OK); Initialize (menu id 32786 -> dialog 'Motors Initialization', button id 1292) takes ~1 min and the dialog closes itself when done; High Voltage (32789) opens 'High voltage (Mn Tube)' property sheet (tabs Set Values / Warm Up / Tube; Warm Up page: radios 1701=7 min, 1702=15 min, 1703=Conditioning, Start=1095, Stop=1243). Pressing Start with the physical X-Ray Enable not pressed gives the prompt "XRayEnable is not set. (Press the button). Do you want to continue with x-rays?" (Yes/No/Cancel) — only the human may clear that by pressing the button. Current recipe = 15 Oct session: Nickel 311, Mn tube 18 kV / 1.00 mA, 35 s x1, 9 tilts to +/-30 deg, aperture 2 mm, sample "GRX 3".

Findings packages: `iXRDmini_findings_2026-09-30\` (README, sections 01-06, tools\ixrd_read.py) and `experiment-2026-10-22\` (prep\RUNBOOK.md, XRDWIN_DIALOGS.md + xrdwin_dialogs.json (all 391 dialogs with control IDs), BASELINE_15OCT26.md, tools\xw.ps1 GUI driver, watch_measurement.py, summarize_results.py). Junction `C:\Users\PROTO\ixrd` -> experiment tools folder, so commands are `C:/Users/PROTO/ixrd/xw.ps1 <action>` (actions: windows, dump, shot, status, cmd, click, pclick, clickid, settext, mouse, key, watch, launch, login).

**Why:** XrdWin is a 32-bit MFC app with no API; its controls appear to UI Automation only as "Pane" with no Invoke pattern, so the driver uses Win32 messages and real input.
**How to apply:** WM_COMMAND (0x111) posted to the main frame works for menu commands; BM_CLICK via SendMessage works for buttons, but use PostMessage ('pclick') for buttons whose handler blocks (Start warm-up, OK on 'Ready for collection?'); dialogs are OWNED windows, so enumerate with EnumWindows, not UIA root children; property-page controls are children of the page, not the sheet (GetDlgItem on the sheet fails -> click by hwnd). NEVER send messages that carry a pointer across processes (TCM_GETITEMRECT, WM_NOTIFY with NMHDR): that crashed XrdWin (COMCTL32 access violation, 2026-10-22 10:49). Switch tabs with a real mouse click on the tab header (SendInput) instead. Always re-run Initialize after XrdWin restarts. See [[claude-code-permissions-ixrd]] for the permission setup.
