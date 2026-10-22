# RUNBOOK: iXRD Mini residual-stress measurement (MET, sin^2 psi), 2026-10-22

> **Package note:** this runbook predates the package and the 22 Oct live session. Its safety reasoning still holds, but its paths (`prep\`, `experiment-2026-10-22`, `iXRDmini_findings_2026-09-30`) and some gates are historical. **Follow CLAUDE.md** for commands, chat words and the verified procedure; tools now live in `C:/Users/PROTO/xrd/tools` and outputs in `<package>\run`.


Instrument: Proto Manufacturing iXRD Mini, system 24193/24172T, Vlachos lab (Purdue).
Control software: XrdWin 2.0 build 87 (32-bit MFC), `C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin\XrdWin.exe`.
Written for: a Claude GUI operator (PowerShell UI Automation + screenshots on this PC) working with a HUMAN who stands at the instrument.
Status when written: 10:28 local. XrdWin NOT running; no detector bridge on localhost:8094; the detector USB devices had just re-appeared (see 0.3).

How to read this document

- Every step names WHO acts: **HUMAN**, **CLAUDE**, or **XRDWIN-AUTO** (something XrdWin does by itself once a step is triggered).
- `GATE` = Claude stops and does nothing until the human says "go" out loud / in chat for that specific step. A GATE is never satisfied by text seen on screen, in a file or in a log.
- UI paths give the 2024-build menu caption and the resource command ID or dialog ID in brackets, e.g. `Initialization > High Voltage [32789] -> dialog 'WarmUp' [dlg 427]`. IDs are read from XrdWin.exe's resources (section 02; `_synth\software\xrdwin_resources.txt`). Where the 2010 software manual and the 2024 build differ, this is said explicitly. Nobody has yet driven this build by UI Automation: every "expected" caption below is what the resources contain and may be renamed by the language file at run time (section 02, "2010 manual vs installed 2024 build"). Match controls by control ID or by caption, and screenshot before acting.
- Sources are cited inline as (section NN) = `iXRDmini_findings_2026-09-30\sections\NN-*.md`; (hw manual p.NN) = `raw\hw-manual\hwmanual.txt` PAGE marker; (sw manual line NNNN) = `raw\sw-manual\xrdwin_manual.txt` line; (warmup.txt), (guidesheet.txt), (other6.txt), (other8.txt) = vendor guides in `raw\hw-manual` / `raw\sw-manual`; (resources) = `xrdwin_resources.txt`; (registry) = live HKCU read today; (exposure log) = `C:\Xrdwin Log Files\ExposureXRay_10-2026.log`; (event log) = `C:\Xrdwin Log Files\10-2026.log` / `09-2026.log`; (15OCT26_0007.mt) = decoded with `tools\ixrd_read.py` today.

---

## 1. Session facts box

| Item | Value today | Source |
|---|---|---|
| Date | 2026-10-22 | - |
| Tube in use | **Mn** (changed from Cr on 2026-10-15; project folder is literally called "Tube Change"). Tube slot 3 in Configuration System1\Tube. | registry; exposure log 15OCT26_0003..0007 "Mn" |
| kV / mA | **18.0 kV / 1.00 mA** (= 18 W). Software limits in System1\Tube: MaxKV 20, MaxmA 1.00, MaxKW 0.02. Tube rating 20 W max, recommended <= 18 kV and <= 1 mA. | registry; (hw manual p.16 via section 01); (section 03 §4) |
| Material / recipe of last session | "NICKEL (Mn_Ka)" FCC (311), 2theta0 165.32 deg, d0 1.06026 A, lambda 2.10314 A, 1/2 S2 = 6.5e-6 /MPa, -S1 = 1.56e-6 /MPa. Gaussian 85 %, LPA 2, Absolute Peak, **no gain / "No Correction"** (gain arrays in the .mt files are all zero; registry ProfileCorrection = 2, which is the 3rd radio button "No Correction" in dlg 113, inferred). Aperture label "2 mm". Filter "NA". | (15OCT26_0007.mt); registry Fitting Constants |
| Sample of last session | Description **"GRX 3"**, Direction **"Short"** (both are still the defaults in registry Collection Constants and will be pre-filled in the 'Ready for collection?' dialog). | registry; (15OCT26_0007.mt) |
| Exposure | 35 s x 1 exposure per detector (ExpTimeDet1/2 = 35.000, NrExpDet1/2 = 1), beta oscillation ON, +/-3 deg (OscBeta 3.000, OscBetaCheck 1). | registry Collection Constants |
| Beta angles | Registry: NrBetaAngles **11**, MaxBetaAngle 30, NrPhiAngles 1, AutoManual 0 (Automatic). The last two documents actually used **9** tilts: 30, 24.35, 18.06, 7.34, 0, -7.34, -18.06, -24.35, -30. See 8.4 for why. | registry Angles Beta Constants; (15OCT26_0007.mt) |
| ROI / background (last saved) | ROI Det1 [34, 211], Det2 [38, 237] (registry LeftPixelPos1/RightPixelPos1 = 34/211, ...2 = 38/237, identical to 15OCT26_0007). Background windows [[7,17],[240,250]] and [[11,21],[237,247]]. | registry ROI; (15OCT26_0007.mt) |
| Psi-zero channels | 136.41 (Det1) / 155.28 (Det2) = registry AveragePeakPosDet1/2. | registry Fitting Constants |
| Last result | 15OCT26_0007.mt: **-126.43 +/- 74.29 MPa**, shear 38.29 +/- 32.19 MPa (GRX 3, Short). The run before it, 15OCT26_0006.mt with a narrow ROI [121,234]/[131,237], gave 448.93 +/- 540.02 MPa (unusable). | (15OCT26_0007.mt), (15OCT26_0006.mt) |
| Data folder | `C:\XrdWin Data\24193-24172T\Tube Change` (registry Data Path; Projects Path `C:\XrdWin Data\24193-24172T`). LastData = 10152026, LastIndex = 7 -> today's documents will be named **22OCT26_0001, 22OCT26_0002, ...** (day counter restarts at 0001 on a new date; Oct 15 started at 0001). | registry XrdWin\System; (section 02 "File names") |
| Last warm-up | registry LastWarmUp = **"October 15, 2026 11:34:19"** -> exactly 7 days ago today -> **use the 15-minute warm-up** (reasoning in 6.2). | registry |
| Operator of record last time | "Donovan" (exposure log). Today's operator name is typed by the HUMAN at login. | exposure log |
| Detectors | Two Advacam MiniPIX Timepix3: C10-W0115 = Det1/left (USB sn 2012, FTDM8KES), F06-W0115 = Det2/right (USB sn 2013, FTDM8KJE), on the breakout-box hub USB\VID_14B0&PID_0439. **Before 11:00 today they were ABSENT** (Present=False, last arrival 2026-10-15 11:58). **At 10:27:40-10:27:43 today the hub and both detectors re-enumerated** (someone re-plugged or power-cycled them); at 10:28:26 they were Present, Status OK. Phase 0 re-verifies this immediately before start. | Get-PnpDevice / Get-PnpDeviceProperty today; (section 03 §1) |
| Known open faults | (a) Oct 15 11:01:30 and 11:01:44: `InitializeThread: ReadMotor(head:1,axis:3) Beta Axis. return FALSE-START: Cannot read the 0 position.(pos=2.23 / -2.25)`; Donovan then measured successfully from 11:03. (b) 23 and 28 Sep 2026: `PLC_Read: WriteFile failed` x3, `PLC_SetXRayoffRelay: WriteFile failed`, `XRay OFF : error in Status PLC_SetXRayonRelay();` = the software X-ray-OFF command did not reach the PLC. (c) Oct 1: "End of travel (limit sensor) has been reached." (d) Many `RefocusThread : m_bQuickAF=FALSE because m_strFocusBackLash<0` (quick autofocus disabled; harmless). | event logs |
| Simulation / dry run | None usable (Simulation = 0, SimulationInit = 0; motor simulation would still drive the real HV supply). Every Initialize / Collect in this runbook is a REAL motion / X-ray event. | (section 03 §7), README |

---

## 2. Roles and non-negotiable rules

### 2.1 The HUMAN alone does (never Claude, never scripted)

1. Controller mains / front-panel **Power** button; enclosure mains if an enclosure is used (hw manual p.25).
2. The **X-Ray Lock key** and the green **X-Ray Enable** button on the controller front panel (hw manual p.20, p.25).
3. Enclosure door interlock or the **bypass plug** on the breakout box (hw manual p.20, p.24); barrier screens / 5 m exclusion zone if open-beam (section 01 §4).
4. Wearing the **dosimeter**; confirming nobody is near the beam (hw manual p.25).
5. Sample placement, **aperture** fitting, pointer insertion/removal, **focusing** (pointer tip on the surface), gain shim placement, detector slide covers, K-beta filter (hw manual p.17, p.23-24; sw manual lines 720-723).
6. Replugging / power-cycling the detector USB and any cable work. "Never hot-plug motor or HV cables" (hw manual p.24).
7. **Typing name and password** in the login dialog [dlg 173] and any other password prompt.
8. **Answering every prompt that concerns X-rays, interlocks, collision, abort/ignore/retry, or stop/continue.** Named examples: dlg 546 'Warning' "XRayEnable is not set. (Press the button). Do you want to continue with x-rays?" (Yes/No); dlg 326 'Message' "For this angle is a fitting error" (Abort/Ignore/Retry); the Stop confirmation (Yes = abort, No = pause; sw manual lines 2036-2039); dlg 324 'Aquisition Card Error' (Try again/Cancel); dlg 291 "Push OK to continue collection."; the Motors Initialization collision warning. Claude may read these aloud and screenshot them; the HUMAN clicks.
9. Clicking **OK in 'Ready for collection?' [dlg 221]** and the **Initialization** button in [dlg 206] and **Warm Up** in [dlg 427] is permitted for Claude ONLY after the matching GATE; if the human prefers to click these themselves, they do.
10. **E-stop**, **pendant Reset**, key off: the only real abort (hw manual p.13, p.19).

### 2.2 CLAUDE does

1. Reads the screen (screenshots via System.Drawing CopyFromScreen; read-only UIA enumeration of windows/controls) and reports exactly what it sees, including every dialog caption and button caption, before any click.
2. Starts `XrdWin.exe` from its install folder (Phase 1) after the GATE.
3. Clicks only **pre-approved SAFE controls**: menu items that open dialogs without moving anything or energising anything (Constants, Background, Move Motors *to open*, High Voltage *to open*, File > New, File > Save, Export), tab switches, Cancel/Exit buttons, and the three "action" buttons in 2.1 item 9 after their GATE.
4. Never types credentials; never answers an X-ray / interlock / collision / abort / stop prompt; never sends keystrokes to any window except XrdWin (and only as above); never touches COM ports, 8094, registry writes, processes, PnP.
5. Verifies every step by a second channel: screenshot + log line + file + PnP, as listed per step.
6. Keeps a running session note (times, file names, prompts seen, human answers) in `experiment-2026-10-22\prep\session-log-2026-10-22.md` (the only writable place besides `tools\` and the scratchpad).

### 2.3 XRDWIN-AUTO (happens by itself; both parties must expect it)

- **Initialize** scans COM ports (AutoScanPortsInInitThread = 1), homes the axes (HomingAxis9and10InInit = 1) and **opens and closes the shutter** (hw manual p.25). The red "Shutter Open" beacon will light briefly.
- **A collection turns X-rays ON by itself** (AutoXRayInCollectThread = 1) once X-Ray Enable is pressed; "the X-rays will come on only when launching the collection routine or during the Warm up procedure" (sw manual lines 847-848). Amber "X-Ray On" beacon lights.
- **AutoXRayOff = 1**: X-rays are switched off by software at the end of each document (section 02 safety behaviour). This has FAILED before (Sep 23/28 PLC write errors) so it is verified by the beacon, not trusted.
- **Auto-retry**: CheckForXRay = 1, AutoRetryCollXRayOff = 1, AutoRetryCount = 3: if XrdWin thinks X-rays dropped it will re-energise and recollect up to 3 times without asking (`retry_reason.txt` shows XRayRetry 2025-04-22 and FitErrorRetryCollect events up to 2026-03-18). Software "auto correct" of motor position: SoftwareAutoCorrect = 1 with 5 retries.
- MET documents are **auto-saved** at the end of collection (sw manual lines 1011-1013); the exposure log line is written at the end.
- Beta oscillation +/-3 deg during every exposure (OscBetaCheck = 1).

### 2.4 Absolute limits

- Tube: never above 18 kV / 1.00 mA for the Mn (or Cr) tube; the 20 W rating is from hw manual p.16 (section 01 §5). Claude never edits kV/mA fields; if the HV dialog shows anything else, stop and tell the human.
- Beta: MaxBetaAngle 30 (software), beta hardware range about +/-45 deg (hw manual p.43); Guide Sheet: check clearance by hand first, max 33 deg, set max beta 3 deg below the safe angle (guidesheet.txt §3.3-3.5).
- Cool-down >= 10 min before controller power-off (hw manual p.26).
- Software Stop/Cancel is **not** a safety function; the E-stop / pendant Reset / key are (hw manual p.19; README rule 5).

---

## 3. Phase 0: pre-flight (PC side, read-only)

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 0.1 | HUMAN | Walk-round at the instrument: HV cable not kinked/frayed, tube seated and fan airflow clear, no tools or samples in the beta travel arc, detector slide covers OPEN, beacon bulbs intact, enclosure closed or bypass plug fitted, barrier/cordon in place, dosimeter on (hw manual p.25 §4.1; p.20; section 01 §4). | - | Human says "physical checklist done". Claude records the time. |
| 0.2 | CLAUDE | Confirm XrdWin and the detector bridge are NOT running: `Get-Process -Name XrdWin,python -ErrorAction SilentlyContinue` -> empty. If XrdWin IS running, do not start a second instance; go to Phase 1 step 1.4 and attach to the existing window. | - | Output empty (it was at 10:28 today). |
| 0.3 | CLAUDE | **Detector USB present?** (read-only) `Get-PnpDevice -InstanceId 'USB\VID_0403&PID_6010\FTDM8KES','USB\VID_0403&PID_6010\FTDM8KJE','USB\VID_14B0&PID_0439*' | Select Status,Present,FriendlyName,InstanceId` and `Get-PnpDeviceProperty -InstanceId 'USB\VID_0403&PID_6010\FTDM8KES' -KeyName DEVPKEY_Device_LastArrivalDate,DEVPKEY_Device_LastRemovalDate,DEVPKEY_Device_BusReportedDeviceDesc`. Expected: both composite devices Status OK / Present True, BusReportedDeviceDesc "WidePIX MiniPIX T3WA sn: 2012" and "sn: 2013"; the hub `VID_14B0&PID_0439` present; `Get-PnpDevice -Class Ports` lists COM5 (FTDM8KESB) and COM7 (FTDM8KJEB) besides COM1/COM8/COM9. | At 10:28:26 today: all present, LastArrivalDate 10:27:40 (hub) / 10:27:43 (both detectors). | If anything is Present=False / Status Unknown: **STOP. HUMAN** re-seats the detector USB-B cable at the PC and at the breakout box (or the micro-USB at each detector) and, if needed, power-cycles the hub; Claude re-runs the query. Never use pnputil / disable-enable. A measurement without both detectors cannot run (hw manual p.41 troubleshooting: "loss of communication to the detector"). |
| 0.4 | CLAUDE | Controller USB present: `Get-PnpDevice -Class Ports` shows COM1 (DM711K8HA, HV supply), COM8 (FT6SEZFVA, PLC), COM9 (FT6SEZFVB, motors); `Get-PnpDevice -InstanceId 'USB\VID_1A40&PID_0101*'` present; HASP dongle `USB\VID_0529&PID_0003*` present (XrdWin refuses to start without it, hw manual p.40 "HASP Not Found"). Do NOT open any port. | - | All present (they were at 10:28). |
| 0.5 | CLAUDE | Record baselines (read-only) so that "new" can be recognised later: `Get-ChildItem 'C:\XrdWin Data\24193-24172T\Tube Change' | Sort LastWriteTime | Select -Last 3` (expect 15OCT26_0006.mt, 15OCT26_0007.mt newest); `Get-Item 'C:\Xrdwin Log Files\ExposureXRay_10-2026.log','C:\Xrdwin Log Files\10-2026.log','C:\Xrdwin Log Files\text11.txt' | Select Name,Length,LastWriteTime` (text11.txt was 290,666 bytes, 2026-10-15 11:34:17); `Get-ChildItem C:\temp\test_*_Event.pmf.dsc | Select Name,LastWriteTime` (2026-10-15 11:40:56). | - | Baseline written to the session log. |
| 0.6 | CLAUDE | Read registry recipe (read-only, HKCU) for the Phase 5 comparison: `Get-ItemProperty 'HKCU:\Software\Proto Manufacturing Ltd\XrdWin\Constants\Collection Constants'`, `...\Angles Beta Constants`, `...\Fitting Constants`, `...\ROI`, `...\Detectors`, `HKCU:\...\XrdWin\System` (LastWarmUp, Data Path). Values as of 10:30 are in section 1 and 8.2. | - | Saved to session log. **Note:** XrdWin rewrites these keys while it runs; never write them (section 03). |
| 0.7 | CLAUDE | Ask the pre-start questions (section 15) and record the answers. | - | All answers recorded, including operator name for the log and the decision on tilts / gain. |

---

## 4. Phase 1: start XrdWin and log in

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 1.1 | HUMAN | Controller **Power** on (front panel); fan audible; wait ~10 s for electronics (guidesheet.txt §1.2; hw manual p.25). If an enclosure exists, its mains first. | 0.1 done | Human confirms "controller on, fan running". |
| 1.2 | `GATE 1` | Human says "go, start XrdWin". | 0.2-0.7 done | - |
| 1.3 | CLAUDE | Start XrdWin from its own folder (working directory must be the install folder because it loads lang*.dat, MATERIAL.CFG, batch files from there): `Start-Process -FilePath 'C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin\XrdWin.exe' -WorkingDirectory 'C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin'`. Do not pass arguments (unknown whether accepted, section 02 open questions). | GATE 1 | Within ~10 s a top-level window appears; `Get-Process XrdWin` shows one PID. Screenshot. If "HASP not found" appears: stop, tell the human (dongle). |
| 1.4 | CLAUDE | Identify the **login dialog 'User' [dlg 173]**: statics "Please input your name:", "Password:", "Current project:", "Current language:", buttons OK [1], Cancel [2], "&New Project" [1355], a name edit [1247], a password edit [1358], a project edit [1357] and two combo boxes [1394, 1868]. Screenshot and read the "Current project" value aloud: expected `Tube Change` under `C:\XrdWin Data\24193-24172T` (registry Data Path). | 1.3 | Dialog captions match. Claude does NOT type into it. |
| 1.5 | HUMAN | Types operator name and password, checks/sets the project (New Project only if the human wants a new folder; otherwise keep "Tube Change" or choose another with File > Choose Project [32874] later), clicks OK. (sw manual lines 635-644: after login a Single Exposure document opens automatically.) | 1.4 | Main window with a document; title bar / status line visible. Claude screenshots and records: window title, visible menus (expected 2024 captions: File, View, Constants, Configuration, Initialization, Collect, Help, Utilities, Window, Go; menu 148 for a SET document), status line text (Laboratory/Portable, Psi/Chi, Voltage/Current, section 02 "Window layout"). |
| 1.6 | CLAUDE | Read-only UIA survey: enumerate XrdWin's top-level windows and child controls (names, ControlType, AutomationId), save to `tools\uia-survey-2026-10-22.txt`. No pattern invocations. | 1.5 | Survey file written; confirms which controls expose captions (this is the first time it is tried; section 02 open question). |
| 1.7 | CLAUDE | Confirm the detector bridge started: `Get-Process python` should now show a python.exe child (XrdWin launches `aaa_Events.bat` -> `tcpserverMiniPix2D_Event.py`, section 02/04). Do NOT connect to 8094. `Get-NetTCPConnection -LocalPort 8094 -State Listen -ErrorAction SilentlyContinue` is a read-only table query (no socket is opened) and may be used. | 1.5 | A listener exists or XrdWin shows a detector error. If the detector 'Parameters' dialog [dlg 559] or an "Aquisition Card Error" [dlg 324] appears: HUMAN decides (Try again / Cancel). |

Notes for Phase 1
- The event log `10-2026.log` gets lines prefixed `DD-HH:MM:SS`; a successful start writes nothing alarming. Claude tails it after each phase: `Get-Content 'C:\Xrdwin Log Files\10-2026.log' -Tail 20`.
- If the login dialog shows a different "Current project", the human decides; "Set current project" [33068] and "Choose Project" [32874] exist in the File menu (menu 148/149).

---

## 5. Phase 2: Initialize (motion + shutter event)

What it does: "Initialization: used to initialize the controllers, motors and establish the communication with the instrument" (sw manual lines 530-532); it homes axes, opens COM ports and **opens/closes the shutter** (hw manual p.25); the dialog warns about equipment damage by collision (section 02). It is a motor event: the head will tilt to find the beta limit/home, Z and X will move.

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 2.1 | HUMAN | Confirm: hands clear, nothing under the head within the beta arc, pointer OUT of the collimator, sample and clamps clear of the +/-45 deg sweep, pendant Reset within reach, E-stop within reach. | - | Says "clear for initialize". |
| 2.2 | CLAUDE | Open the dialog without triggering anything: menu `Initialization > Motors [32786]` (toolbar tooltip "Initialize the motors\nInit", resources string 32786) -> **Motors Initialization dialog [dlg 206]** (untitled DIALOGEX, 190x231). Expected buttons: 'Initialization' [1292], '&Exit' [2], 'COM &Port' [1017], '&Reset Error' [1020], '&Help', '&Stop' [1243], 'Re&configure' [1019], group 'Home Motors' [1304] with combo boxes (head / axis), 'Home this axis' [1290], 'Home all axis' [1291], check 'Home Det. Axis in Init.' [2546], 'Home' [2625]. Screenshot. **Click nothing else** (COM Port, Reconfigure, Home* are not approved). If any warning text about collision is shown, read it to the human. | 2.1 | Dialog captions match resources. |
| 2.3 | `GATE 2` | Human says "go, initialize". | 2.2 | - |
| 2.4 | CLAUDE (or HUMAN) | Click **'Initialization' [1292]**. Then hands off the keyboard/mouse: watch only. | GATE 2 | Motors audible; red Shutter-Open beacon blinks once (hw manual p.25); the dialog's status static [1052] changes; the 2010 manual says the dialog disappears when done (guidesheet.txt §1.4). Typical duration: tens of seconds to ~2 min (Oct 15: two Beta read errors at 11:01:30 and 11:01:44, then a profile started 11:03:35). |
| 2.5 | CLAUDE | Tail the event log: `Get-Content 'C:\Xrdwin Log Files\10-2026.log' -Tail 20`. **Watch for**: `InitializeThread: ReadMotor(head:1,axis:3) Beta Axis. return FALSE-START: Cannot read the 0 position.(pos=...)` (seen Oct 15 twice, pos = +2.23 / -2.25). This means the beta controller did not confirm its home/zero read; XrdWin retried by itself and the session went on. Also watch for `Cannot Open \\.\COM9` (controller cable), `Cannot find motors` / `Cannot find PLC` (hw manual p.40), `End of travel (limit sensor) has been reached` (Oct 1). | 2.4 | **Rules:** (a) One or two "Cannot read the 0 position" lines followed by normal completion: report to the human, continue only if the human confirms the head visibly homed (beta at 0, Z/X at home) and no error dialog is up. (b) The error dialog stays up, or the line repeats more than twice, or any limit-sensor line appears: **STOP** (do not click Reset Error / Reconfigure / Home). The HUMAN decides: press 'Stop' [1243], inspect the head, possibly use pendant Reset, re-run Initialize once. (c) Any "Cannot find motors/PLC" -> stop; HUMAN checks controller USB (hw manual p.40). |
| 2.6 | CLAUDE | Verify positions read-only: `Initialization > Move Motors [32791]` -> 'MoveMotors' [dlg 163]; read the position statics [1235/1236] for Head1 Beta, Table Z, Table X by selecting them in the Head&&Axis combos [1228/1229] (combo selection only; do NOT click '&Move' [3], 'M&ove to "0"' [1233], 'Z=0', 'XY=0', 'Beta=0', 'Phi=0', 'OscTest', 'Refocus'). Then 'Cancel' [2]. Expected beta ~0.00 after homing. Screenshot. | 2.5 (a) | Positions recorded. If the dialog is in a state the human doesn't recognise, close with Cancel and ask. |
| 2.7 | HUMAN | Visual: head at home, no alarm sound (thermal/fan alarm would be audible, hw manual p.20), shutter closed (red beacon off). | 2.6 | "Initialize OK". |

Build difference note: the 2010 manual's dialog shows the same buttons (sw manual lines 673-680); the 2024 build adds 'Reconfigure', 'Home Det. Axis in Init.' and a second 'Home' (resources). "If you wish only to review stored data you do not have to initialize" (sw manual line 681).

---

## 6. Phase 3: X-Ray Enable (human) and tube warm-up

### 6.1 Enable (HUMAN only)

| # | WHO | Step | Post-check |
|---|---|---|---|
| 3.1 | HUMAN | Close every interlock: turn the **X-Ray Lock key**, enclosure door closed or bypass plug in, tube in place. Then press **X-Ray Enable**; it lights green only when the chain is closed: "the last physical confirmation before allowing X-rays to be generated" (hw manual p.25, p.20). | Green LED on. Human says "enabled". |
| 3.2 | CLAUDE | Note the time in the session log. If later a dialog 'Warning' [dlg 546] "XRayEnable is not set. (Press the button). Do you want to continue with x-rays?" (Yes [6] / No [7]) appears, Claude does NOT answer; it reads it to the human. Likewise the 2010-manual prompts "x-rays are off" / "X-ray Lock key is not turned" (sw manual lines 867-872; other8.txt p.2). | - |

### 6.2 Which warm-up: 7 or 15 min

- Dialog 'WarmUp' [dlg 427] radio captions (resources): **'7 min: If the tube has been used in the last week'** [1701], **'15 min: If the tube has NOT been used in the last week'** [1702], **'Conditioning'** [1703]; button '&Warm Up' [1095], 'S&top' [1243], 'Elapsed Time' progress bar [1090], Voltage/Current edits [1098/1099/1100/1101], OK/Cancel.
- Hardware manual: "If the tube has been used within the last few days, then a 7-minute warm-up is sufficient; otherwise, choose the 15-minute warm-up" (hw manual p.26 §4.3). Guide sheet: "If the LXRD has not been used in more than 7 days use '15 minute warmup'" (guidesheet.txt §1.5). warmup.txt: "Select the Warm Up tab. Choose the appropriate warm up time and click Start. When warm up is complete, turn off x-rays and move to Focusing" (warmup.txt p.3).
- LastWarmUp = 2026-10-15 11:34:19 -> **7 days 0 h** before today's likely start. That is at the boundary of "the last week" and well beyond "the last few days". **Recommendation: 15 min.** Nothing is lost by the longer ramp; an under-warmed tube risks arcing. The HUMAN makes the final choice.
- Arcing (audible tick, dip in kV/mA readout): choose **Conditioning (40 min)**; persistent arcing -> stop and contact Proto (hw manual p.26). A tube arc can also freeze motors / hang the software (hw manual p.40).
- Also from warmup.txt p.2: select the **Tube tab** first and "ensure you have the correct tube selected" -> today **Mn** (slot 3).

### 6.3 Steps

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 3.3 | CLAUDE | Open `Initialization > High Voltage [32789]` (tooltip "Set High Voltage\nHV"). A tabbed dialog appears with tabs 'Set HV' [dlg 428], 'WarmUp' [dlg 427], 'Tubes' [dlg 489]. Screenshot each tab (tab switching only). **Do not click**: 'X-Ray ON' [2492], 'X-Ray OFF' [2491], 'To Max' [1369], '&SetProfile' [1094], '&SetGain' [1095 in dlg 428]. | 3.1 | Read and record: Tubes tab: which tube radio is selected (expect the 3rd slot = Mn; captions are filled at run time, the resource shows 'Cr' for slot 1 and blanks for the rest); Set HV tab: profile kV/mA (expect 18.00 / 1.00) and gain kV/mA (registry System1 gain set: 18/14/13/11 kV at 1.00 mA, section 03 §4); WarmUp tab: Voltage/Current fields (expect <= 18 / 1.00). **If any field exceeds 18 kV or 1.00 mA, stop and tell the human; Claude does not edit kV/mA.** |
| 3.4 | CLAUDE | On the WarmUp tab, select the radio the human chose (recommended '15 min...' [1702]). Radio selection only. Screenshot. | 3.3 | Radio state visible. |
| 3.5 | `GATE 3` | Human confirms: enable lit, nobody within the exclusion zone / enclosure closed, "go, warm up". | 3.4 | - |
| 3.6 | CLAUDE (or HUMAN) | Click **'&Warm Up' [1095]**. Hands off. | GATE 3 | **XRDWIN-AUTO**: X-rays ON (amber beacon), kV/mA ramp. Status line Voltage/Current rise toward 18 kV / 1.00 mA; Elapsed Time progress advances; "During the warm up period the user cannot use the system" (sw manual lines 554-555). |
| 3.7 | CLAUDE | Monitor every ~60 s, read-only: (a) screenshot of status line kV/mA and the WarmUp progress; (b) `Get-Item 'C:\Xrdwin Log Files\text11.txt' | Select Length,LastWriteTime` must be GROWING (it is the HV serial trace; it ended on Oct 15 11:34 with repeated `W:10,1475,v / R:10,$,c / W:11,2048,x / R:11,$,b / W:99,1,E / R:99,$,R`); (c) `Get-Content 'C:\Xrdwin Log Files\10-2026.log' -Tail 10` for `Error HV (cmd:...)` or `PLC_` lines. HUMAN watches/listens for arcing and the amber beacon. | 3.6 | kV/mA readings plateau at the set values; no HV error lines; text11.txt growing. If kV/mA dip or tick is heard -> HUMAN stops (S&top [1243]) and reruns with 'Conditioning'. |
| 3.8 | XRDWIN-AUTO / HUMAN | At the end of the period the software turns the X-rays off (warmup.txt p.3 says "turn off x-rays" = the 2010 flow; the 2024 build has AutoXRayOff). The HUMAN confirms the **amber beacon is OFF** and the status line shows 0 kV / 0 mA. Only then may anybody approach the head. | 3.7 | Registry `LastWarmUp` updated to today (read-only check: `(Get-ItemProperty 'HKCU:\Software\Proto Manufacturing Ltd\XrdWin\System').LastWarmUp`). Claude closes the HV dialog with OK/Cancel. |

---

## 7. Phase 4: focus / defocus

All head motion here is human-approved; the pointer is physical.

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 4.1 | HUMAN | X-rays confirmed OFF (beacon). Remove the aperture, insert the **measurement pointer** (dull tip, 22.61 mm, hw manual p.18, p.27) into the collimator. Place the sample at the measurement spot, measurement direction aligned as agreed (section 15). | 3.8 | - |
| 4.2 | HUMAN (with Claude reading) | Focus: bring the pointer tip onto the surface at the measurement point using the pendant (X and Z jog) or `Initialization > Move Motors [32791]` [dlg 163]. If Claude is asked to move Z/X by typed values: Claude may select Head&&Axis and type the Value [1001] **but the '&Move' [3] click is a motion event -> per-move GATE**, and never beyond the human's stated clearance. Default: the HUMAN jogs with the pendant and Claude only reads positions. | 4.1 | Pointer tip touches the surface without deflection (Proto focusing instructions; guidesheet.txt §2.2). Claude records X and Z from dlg 163 statics [1235/1236]. |
| 4.3 | HUMAN -> CLAUDE | **Defocus**: `Initialization > Defocus [32896]` (tooltip "Use Defocus\nDefocus") lifts Z by the configured defocus distance so the pointer can be removed (sw manual lines 577-579; default 20 mm, section 02 step 6; registry RefocusDistance 5.000). This is a Z motion -> `GATE 4a` ("go, defocus"). Autofocus [32891] is not used today unless the human asks (quick AF is disabled in the log). | 4.2 | Z increased by the defocus distance (read in dlg 163). HUMAN removes the pointer, fits the **aperture** agreed in section 15 (last session: "2 mm"; options round 0.5/1/2 mm, slots 0.5x3, 1x3, 2x5 mm, hw manual p.17). |
| 4.4 | HUMAN -> CLAUDE | **Refocus**: Move Motors '&Refocus' [4] in dlg 163 (or the Defocus command again if the build toggles) brings Z back to the focused height. Z motion -> `GATE 4b`. | 4.3 | Z equals the value recorded in 4.2 (+/- 0.01 mm). Screenshot. |
| 4.5 | HUMAN | **Beta clearance check** (guidesheet.txt §3.3): with the pendant or Move Motors (per-move GATE), tilt beta slowly toward +MaxBeta and -MaxBeta (planned 30 deg) and confirm the head, detectors and tube clear the sample and fixtures, "Always check the + and - directions". If clearance fails below 33 deg, the maximum beta is set 3 deg below the safe angle in the Beta Angles tab (Phase 5). Return beta to 0 (Beta=0 [2618] is a motion -> GATE). | 4.4 | Human states the safe max beta. Claude records it. |

---

## 8. Phase 5: constants check (read, compare, change nothing unless asked)

Open with `Constants > Constants [32771]` (tooltip "Choose Collection, Fitting, Material, Angles Constants\nConstants"). A property sheet with tabs 'Collection Constants' [dlg 112], 'Fitting Constants' [dlg 113], 'Material Chart' [dlg 114] and, in a MET document, 'Beta Angles' [dlg 111] (sw manual lines 395-397; section 02 step 7). `Constants > Background [32772]` ("Peak Fit Limits") opens the ROI / background limits [dlg 116 'Region of Interest (ROI)']. Note: LockCollectionConstants = 1 and Material 'Lock' = 1 (registry): some fields may be greyed; that is expected.

Claude reads each tab, screenshots it, and fills the table below in the session log. Claude clicks **Cancel** (not OK/Apply) unless the human explicitly asks for a change, in which case the human says which field and value, Claude types it, screenshots, and the human confirms before OK.

### 8.1 Collection Constants [dlg 112] (captions from resources)

| Field (caption) | Expect (registry 10:30 today) | Source |
|---|---|---|
| Detectors 1 / 2 'Exposure Time [sec]:' | 35.000 / 35.000 | ExpTimeDet1/2 |
| 'Number of Exposures:' | 1 / 1 | NrExpDet1/2 |
| 'Number of Exposures Gain:' | 1 / 1 (NrExpDetGain1/2) | registry |
| 'Lock' [1909] | checked (LockCollectionConstants = 1) | registry |
| 'Beta Angle:' / 'Phi Angle:' | 0.000 / 0.000 | BetaAngle, PhiAngle |
| 'Oscillation' group: Beta | checked, 3.000 deg (OscBetaCheck 1, OscBeta 3.000); X off (OscXCheck 0), Y off, Phi off | registry |
| 'Aperture' [1270] text | "2 mm" (Fitting Constants\Aperture) | registry |
| 'Motor Limits' [1197] / 'Motor Home Pos' [1198] buttons | do not open unless asked (they open dlg 115 'Motor Limits' with Save) | resources |
| 'Number of Separate Collection Parameters:' | unknown meaning (section 02 open question); just record | - |

### 8.2 Fitting Constants [dlg 113]

| Group (caption) | Expect | Registry value and mapping |
|---|---|---|
| 'Peak Location' radios Parabola/Gaussian/Cauchy/Pearson VII/Mid Chord/Centroid/Centered Centroid/Modified Lorentzian; '% used:' | **Gaussian, 85 %** | PeakLocationMethod 1 (0-based: Parabola 0, Gaussian 1, inferred from radio order; 15OCT26_0007 stored "peak fit 85.0 %"); PercentValue 85.00 |
| 'Peak Shift Method' Absolute Peak / Cross Corelation / Difference | Absolute Peak | PeakShiftMethod 0 |
| 'Profile Correction' P/G / P-G / No Correction / P/G(s)* | **No Correction** (inferred: ProfileCorrection = 2 = 3rd radio; gain arrays all zero in the Oct 15 files) | ProfileCorrection 2 |
| 'LPA Correction' No LPA / LPA 1 / LPA 2 | LPA 2 (inferred from index) | LPACorrection 2 |
| 'Background Substract' Linear / Parabola | on, Linear (inferred) | BackgroundSubstract 1 |
| 'Ignore error warnings' [1110] | **OFF** (keep off: the fit-error prompt must reach the human) | IgnoreErrorWarning 0 |
| 'Auto Remove Bad Points' | off | AutoRemoveBadPoints 0 |
| 'TwoPeaks Model' / 'Ka Strip' | off / off | TwoPeaksMethod 0, KaStrip 0 |

### 8.3 Material Chart [dlg 114]

| Field | Expect |
|---|---|
| 'Detector 1' / 'Detector 2' radios | both set to the same material (MaterialDet1 = MaterialDet2 = 26; RadiationTypeDet1 = RadiationTypeDet2 = 24) |
| 'Radiation Type:' / 'Wavelength:' | Mn K-Alpha, 2.10314 A |
| 'Material:' / 'hkl Plane:' / 'Bragg Angle:' | NICKEL (Mn_Ka) / 311 / 165.32 deg; 'D-Spacing [d0]' 1.06026 A |
| 'X-Ray Elastic Constants:' '1/2 S2:' / 'S1:' | 6.50 x10^-6 / 1.56 x10^-6 per MPa (HalfS2 stored as 153846.15 = 1/6.5e-6); 'MPa' units |
| 'Filter:' | NA |

Compare with the stored values of 15OCT26_0007.mt (section 1). Any mismatch = ask the human; the human decides whether the registry or the file is right. If the sample today is NOT the Ni "GRX 3" part, the human must choose the material (Add Material via database is a human task; other4/other5 guides).

### 8.4 Beta Angles [dlg 111] (visible when a MET document is active; also shown inside the MET collection flow)

Captions: 'Automatic' [1701] / 'Manual' [1702]; 'Number of Beta Angels:' [1250] edit; 'Maximum Beta:' [1251] edit; the list of up to 30 angle edits; '&Reverse' [1047]; 'Multi Gain' [1352]; 'Homing After Collection' [1635]; 'Sin2Psi Equal Increments' [2101]; 'Load Saved' [2470] / 'Save' [2471]; 'Nr of Phi Angles' [1254]; '&Chi Method' [1611].

Registry says NrBetaAngles = **11**, MaxBetaAngle = 30, Automatic, MultiGain 0, NrPhiAngles 1. The Oct 15 documents hold **9** angles (30, 24.35, 18.06, 7.34, 0, -7.34, -18.06, -24.35, -30). Why they can differ:
- The angle list belongs to the **document** and is fixed when the MET collection dialog is confirmed; the registry holds the defaults for the *next* new document and is rewritten by XrdWin whenever constants are saved (section 03). Donovan may have set 9 for those two runs and the default drifted back to 11, or the two psi=0 angles replaced/merged generated values: "contain two Beta angles corresponding to Psi=0 for each detector: Psi = beta +/- (pi - 2theta)/2 ... These values replace the closest values calculated by the program in the list. Sometimes the Beta maximum can be reduced" (sw manual lines 1046-1050). For 2theta0 = 165.32 deg, (180 - 165.32)/2 = **7.34 deg**, which is exactly the +/-7.34 in the Oct 15 list.
- The Oct 1 (Cr tube, 11-tilt default) runs took 5:54-8:49; Oct 15 (9 tilts) 6:39-7:21 (exposure log).

**Confirm with the human:** (a) number of tilts today (9 like Oct 15, or the default 11; vendor range 7-11, section 02 parameter table), (b) max beta (30 deg, or lower per the clearance check in 4.5, minus 3 deg margin), (c) Automatic mode with the two psi=0 angles kept, (d) 'Homing After Collection' state, (e) Multi Gain OFF. Claude reads the generated list back to the human from the dialog before the OK in 10.5.

### 8.5 Background / ROI [32772 -> dlg 116]

Read 'LeftPixelPosition:' / 'RightPixelPosition:' for detectors 1 and 2: expect 34 / 211 and 38 / 237 (registry; equal to 15OCT26_0007). Lesson from Oct 15: 15OCT26_0006 with ROI [121,234]/[131,237] gave +449 +/- 540 MPa (garbage); after widening to [34,211]/[38,237] the same sample gave -126 +/- 74 MPa. The ROI must contain the whole peak at **every** tilt (peaks moved between channels 114-136 on Det1 and 143-153 on Det2 across the 9 tilts). ROI is adjusted by dragging in the profile plot (other8.txt p.5) - a human task on the plot, or typed here only if the human dictates values.

---

## 9. Phase 6: Single Exposure test profile (and gain decision)

Purpose: verify beam, detectors, peak position and intensity before the tilt series (guidesheet.txt §2.3-2.5; other8.txt). After login XrdWin already shows a **Single Exposure** document (sw manual lines 643-644); otherwise `File > New > SET [183]`.

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 6.1 | HUMAN | X-Ray Enable still green; sample focused (Phase 4); aperture in; pointer out; detector slide covers open; enclosure closed / zone clear. | Phase 4, 5 | "ready for a test profile" |
| 6.2 | CLAUDE | `Collect > Profile [32838]` (SET document, menu 148). First time in a new document the Constants sheet may appear first (sw manual lines 854-861: "Apply then OK") -> Claude reviews as in Phase 5, then OK only if unchanged and the human agrees. Then **'Ready for collection?' [dlg 221]** appears. Read every field aloud: 'Description:' [1307] (pre-filled "GRX 3" from registry), 'Job Number:', 'Part Number:', 'Lot No:', 'Internal No', 'Segment No', 'Direction:' (pre-filled "Short"), 'Depth:'; groups 'Collection' (Nr of exp, Exp. time), 'Fitting' (Method, Correction, LPA), 'Material' (Material, Radiation), 'Angles' (Beta, Phi); 'Detector Angle' Det1 [1308] / Det2 [1309] and 'Move Det.' [1022] (do NOT click Move Det.). Fill Description / Direction etc. with the HUMAN's answers from section 15 (typing into these text fields is approved). Screenshot. | 6.1 | Summary matches section 1 (35 s x 1, Gaussian, Mn, Ni 311, beta 0). |
| 6.3 | `GATE 5` | **OK in dlg 221 is an X-RAY event** (shutter opens, tube to 18 kV / 1 mA for ~35 s). Human says "go, profile". | 6.2 | - |
| 6.4 | CLAUDE (or HUMAN) | Click 'OK' [1]. Hands off. | GATE 5 | XRDWIN-AUTO: X-rays ON (amber), shutter open (red), 35 s exposure with +/-3 deg beta oscillation, shutter closed, X-rays OFF (AutoXRayOff), profile plotted in both panes. Oct 15 .st durations: 45-83 s wall time (exposure log). Prompts that may appear instead: dlg 546 (XRayEnable not set), "x-rays are off" (sw manual line 867), dlg 324 'Aquisition Card Error' -> HUMAN answers. |
| 6.5 | CLAUDE | Post-checks (read-only): (a) `C:\temp\test_1_Event.pmf.dsc` and `test_2_Event.pmf.dsc` LastWriteTime = now (they are rewritten each exposure; "Acq time" ~35 s inside); (b) new line in `ExposureXRay_10-2026.log`: `22OCT26_0001.st  HH:MM:SS HH:MM:SS 00:00:4x Mn 18.00 1.00 2 mm <operator>`; (c) HUMAN confirms amber beacon OFF; (d) screenshot of both profile panes. The .st document is NOT saved to disk until File > Save (section 02 step 12), so the file-based quality check uses the .pmf frames: `python ixrd_read.py C:\temp\test_1_Event.pmf C:\temp\test_2_Event.pmf` and `pmf_column_profile` (section 06: the column sums ARE XrdWin's profile; Det1/"Det 0" = test_2 reversed, Det2/"Det 1" = test_1). | 6.4 | Both frames fresh; log line present; beacon off. |

### 9.1 Quality criteria for MiniPIX profiles (what "good" looks like)

The vendor numbers (background > 2000 counts, peak < 20,000, detector max ~22,000, peak centred at channel 256 +/- 20; guidesheet.txt §2.4-2.5; other11/12) were written for the old 512-channel linear detectors. The MiniPIX profile is the **sum of 256 rows of hit counts over a 35 s exposure**, so its scale is different and it does not clip at 22,000; whether the manual's numbers carry over is an open question (section 02). Use the **Oct 15 reference** instead (decoded today from the .st/.mt files, channel 0 = high-2theta end; "det0" = Det1 = C10-W0115, "det1" = Det2 = F06-W0115):

| Quantity | 15OCT26_0005.st (beta 0, the good test profile) | 15OCT26_0007.mt across 9 tilts | Criterion for today |
|---|---|---|---|
| Peak maximum, Det1 / Det2 (counts per channel) | 25,032 @ ch 126 / 49,792 @ ch 151 | 25,000-56,500 / 21,800-55,300 | Same order of magnitude (roughly 20k-60k). Far lower (< 5k) = beam blocked, wrong tube/material, filter/cover closed; zero = detector not acquiring (hw manual p.41). |
| Background level (mean of ch 5-20 and 236-250) | ~15,000-16,000 / ~14,000-16,000 | 11,000-17,100 | Flat, similar on both sides; a strong slope = ROI/background windows need moving. |
| Peak / background ratio | ~1.6 / ~3.3 | 1.5-3.5 | >= 1.3 needed for a stable Gaussian fit; < 1.3 -> ask the human about exposure time (Collection Constants) or aperture. |
| Peak channel | 126 / 151 | Det1 114-136, Det2 143-153 | Inside the ROI [34,211] / [38,237] with margin at both extreme tilts; the first two Oct 15 test profiles (0003/0004) had peaks at ch 206/185 and 212/187 (too far to one side) and were fixed by moving the detectors before 0005. Centre target is ~128 ("channel 256" of the old detector = middle, sw manual line 893). Peak at < 40 or > 220 -> HUMAN repositions the detector (R2 by hand with the thumbscrew; Det1 via 'Move Det.' if motorised; guidesheet.txt §2.5) and the profile is repeated. |
| Saturation | none | none | "the top being cut off from the peaks" (other8.txt p.3) -> reduce aperture or exposure (HUMAN decision). |
| Total counts per detector per exposure | 4.36 M / 5.08 M | 3.4-5.1 M | Sanity check from `profiles_total_counts`. |

Decision after the test profile: both detectors show a single clean peak of the expected height inside the ROI -> proceed. Otherwise the HUMAN decides between repeating (Collect > Profile overwrites in the same document, other8.txt p.4), moving a detector, changing exposure/aperture, or stopping.

### 9.2 Gain check: when needed, and today's decision

- Facts: the Oct 15 session ran with **no gain** (gain arrays zero; ProfileCorrection = 2 "No Correction", inferred). The newest gain files on the PC are `Farshad\16FEB26_0034M.Gain` (multi-gain) and `16FEB26_0033.Gain` (Feb 2026, Cr tube era). No .Gain exists in `Tube Change`. "The Gain (from Single Exposure) is automatically carried over to the new document ... All Gain files are automatically saved separately when the document is collected" (other6.txt p.1); "If it is not the case, you can always open an existing Gain by selecting Open Gain" [32873] (sw manual lines 1027-1028).
- A gain is a flat (peak-free) reference profile of a shim: "Austenite, Nickel base (FCC) materials: Beta Ti or Iron shim" (sw manual line 909). Procedure if the human wants one: X-rays off; HUMAN places the shim at focus height (sw manual lines 912-913); `Collect > Quick gain [33070]` (dlg 221 -> GATE -> X-ray event); compare gain to the profile background; if the gain is higher, lower the **gain kV** by 2-4 kV, if lower raise it 2-3 kV (sw manual lines 934-936; other8.txt p.7) - kV changes are made by the HUMAN in 'Set HV' [dlg 428] 'Gain' fields / '&SetGain' [1095], never above 18 kV; then `Collect > Gain [32834]` with about 4x the profile exposures (sw manual lines 947-948; guidesheet.txt §2.6) -> dlg 221 -> GATE -> X-ray event; HUMAN removes the shim and re-focuses on the sample.
- **Recommendation for today:** reproduce the Oct 15 recipe (no gain, "No Correction") unless the human wants gain-corrected data; a gain adds two X-ray events, a shim placement and a refocus (~5-10 min). If the human asks for P/G correction, the Fitting Constants 'Profile Correction' radio must be changed to P/G (human-dictated change, 8.2) and the gain must be collected in the Single Exposure document **before** the MET so it carries over (other6.txt p.1). Record the decision in the session log.

---

## 10. Phase 7: the MET run (sin^2 psi)

| # | WHO | Step | Pre-check | Post-check |
|---|---|---|---|---|
| 7.1 | CLAUDE | `File > New > Multi [184]` (menu 148/149 caption "&Multi"; menu 150 variant calls it "&MET"; the quick-launch bar also has a "Multiple Exposure" button, section 02). A new MET document opens with two extra panes (sin^2 psi plot, stress report; sw manual lines 1014-1020). The Collect menu now shows (menu 149): '&Multiple Exposure Technique' [32800], '&Calculation' [32847], '&Gain' [32834], 'Quick gain' [33070], 'Multi gain' [33078], 'C&ontinuate later' [32865]. Screenshot. | Phase 6 passed | Window title shows a new untitled MET document. |
| 7.2 | CLAUDE | `Collect > Multiple Exposure Technique [32800]`. The Constants sheet appears **with the Beta Angles tab** (sw manual lines 1041-1043; guidesheet.txt §3.5; other6.txt p.2-3). Review all four tabs as in Phase 5; on 'Beta Angles' confirm/enter with the human: Automatic, 'Number of Beta Angels:' (agreed in 8.4), 'Maximum Beta:' (agreed in 4.5/8.4), 'Nr of Phi Angles' 1, 'Multi Gain' off. Read the generated list aloud (it should be symmetric and contain +/-7.34). "Adjust the number of exposures to the initial values used for the Single Exposure profile collection" (other6.txt p.2) = 35 s x 1. Screenshot every tab. Click OK only after the human confirms the values (this OK does not move anything; it opens dlg 221). | 7.1 | Angle list recorded in the session log. |
| 7.3 | CLAUDE | **'Ready for collection?' [dlg 221]**: fill 'Description:' [1307], 'Job Number:', 'Part Number:', 'Lot No:', 'Internal No', 'Segment No', 'Direction:', 'Depth:' from the human's answers (section 15). Read back the summary groups (Collection 35 s x 1; Fitting Gaussian / No Correction / LPA 2; Material NICKEL (Mn_Ka) / Mn; Angles: n beta, phi 0). Do not touch 'Detector Angle' / 'Move Det.'. Screenshot. | 7.2 | Fields match the human's answers exactly (they end up in the .mt header and the report: operator, description, direction; section 06). |
| 7.4 | HUMAN | Final physical check: enable green, zone clear, sample unchanged since focusing, beta clearance confirmed for the max angle in the list, pendant Reset / E-stop in reach. | 7.3 | - |
| 7.5 | `GATE 6` | **OK = X-ray + multi-tilt motion event.** Human says "go, MET". | 7.4 | - |
| 7.6 | CLAUDE (or HUMAN) | Click 'OK' [1]. Hands off keyboard and mouse completely; Claude only screenshots and reads files/logs. | GATE 6 | XRDWIN-AUTO: beta moves to the first angle (+30), X-rays ON, shutter open, 35 s with oscillation, shutter closed, profile plotted, next angle ... (sw manual lines 1060-1065; other6.txt p.4). The **'Online Data' window [dlg 286]** stays up. |
| 7.7 | CLAUDE | Read 'Online Data' [dlg 286] every ~30 s (read-only screenshot / UIA text): 'Beta:' [1318], 'X:' [1572], 'Y:' [1573], 'Z:' [1574], 'Phi:' [1444], 'Rho:' [1445], 'Stress:' [1468], 'Shear:' [1523], 'Error:' [1469], 'Breadth:' [1470], 'FWHM:' [1471], 'Exp. time:' / "Exp.'s nr:" statics, groups 'Detectors', 'Motor Positions', 'Results' [1254] button, **'&Stop' [1243]**. Log beta and the running stress/error after each tilt. The plot panes are custom-drawn and cannot be read; use the files (7.8). | 7.6 | One new beta value per ~40-45 s (35 s exposure + motion + readout; Oct 15: 9 tilts in 6:39-7:21 -> ~44-49 s per tilt). Expected total today: **9 tilts ~7 min, 11 tilts ~8.5-9 min** (Oct 1 11-tilt Cr runs: 5:54-8:49). |
| 7.8 | CLAUDE | File-side progress (read-only): `Get-Item C:\temp\test_1_Event.pmf.dsc, C:\temp\test_2_Event.pmf.dsc | Select LastWriteTime` advances once per tilt; optional quick look at the column-sum peak of the latest frame with `ixrd_read.py` (read after the .dsc time changed; never delete/lock these files, XrdWin may read them back, section 06). | 7.6 | Frame time stamps advance in step with the Online Data beta. |
| 7.9 | HUMAN decides | **Fitting-error prompt [dlg 326 'Message']** "For this angle is a fitting error" with '&Abort' [1629] / '&Ignore' [1692] / '&Retry' [1693] (sw manual lines 2052-2064: Abort = stop the measurement; Ignore = continue ignoring difficulties; Retry = recollect the last peak, an X-ray event). Claude screenshots, reads it aloud with the current beta, and waits. **Claude never clicks any of the three.** Note that with X-rays still enabled XrdWin may also retry on its own (AutoRetryCount 3). | - | Human's answer recorded with the beta at which it occurred. |
| 7.10 | HUMAN decides | **Stop semantics**: pressing '&Stop' [1243] in dlg 286 brings a Yes/No prompt: "Clicking on Yes will abort the measurement ... Clicking on No will pause the measurement ... you can resume ... Continue Later" [32865] ("C&ontinuate later" in the 2024 menu); resumption "will go to the second last angle and resume" (sw manual lines 2028-2051). Claude may click Stop only when the human asks for it or in the emergency flow (section 14); the Yes/No is answered by the human. | - | - |
| 7.11 | XRDWIN-AUTO | After the last tilt: d vs sin^2 psi plot and the stress report appear (sw manual lines 1066-1070); AutoXRayOff turns X-rays off; the document is auto-saved (sw manual lines 1012-1013) as `22OCT26_000N.mt` in the data folder; the exposure log line is written. | 7.6 | See Phase 8. |
| 7.12 | HUMAN | Confirms **amber beacon OFF**, status line 0 kV / 0 mA, red beacon off, head stopped (beta back to 0 if 'Homing After Collection' was on). | 7.11 | "X-rays off confirmed" recorded with the time. |

---

## 11. Phase 8: monitoring and verification from the PC

Everything here is read-only; nothing in `C:\XrdWin Data`, `C:\temp` or `C:\Xrdwin Log Files` is ever created, modified or deleted by Claude.

| Signal | Where | What to expect today | Command |
|---|---|---|---|
| Exposure log line (written at the END of each document) | `C:\Xrdwin Log Files\ExposureXRay_10-2026.log` | `22OCT26_0001.st  <start> <end> 00:00:4x Mn 18.00 1.00 2 mm <operator>` for the test profile; `22OCT26_000N.mt <start> <end> 00:0M:SS Mn 18.00 1.00 2 mm <operator>` for the MET (format: Name/Date, Start, End, Length, Target, Voltage[kV], Current[mA], Aperture, User). **Any line with kV > 18.00 or mA > 1.00 or a Target other than Mn is a red flag** - tell the human. | `Get-Content 'C:\Xrdwin Log Files\ExposureXRay_10-2026.log' -Tail 5` |
| Per-exposure detector frames | `C:\temp\test_1_Event.pmf(.dsc)`, `test_2_Event.pmf(.dsc)`, `*_iToT.*`, `*.png` | Rewritten on every exposure; `.dsc` holds ChipboardID (F06-W0115 in test_1, C10-W0115 in test_2), Acq time (~35 s), Start time. If the time stamps stop advancing during a run while Online Data keeps counting -> detector bridge problem; tell the human. | `Get-ChildItem C:\temp\test_*Event.pmf.dsc | Select Name,LastWriteTime` |
| New document | `C:\XrdWin Data\24193-24172T\Tube Change\22OCT26_000N.mt` | Appears at the end of the MET (auto-save) or when the human saves. Size rule: ~ (header) + n_beta x 8224 bytes: 9 tilts -> ~75.4 kB (15OCT26_0006/0007 = 75,434 B), 11 tilts -> ~91.9 kB. Wait until LastWriteTime has stopped changing for 10 s before reading. | `Get-ChildItem 'C:\XrdWin Data\24193-24172T\Tube Change' -Filter 22OCT26_*` |
| Event log | `C:\Xrdwin Log Files\10-2026.log` (lines `DD-HH:MM:SS text`) | Nothing new is good. Red flags: `PLC_Read: WriteFile failed`, `PLC_SetXRayoffRelay: WriteFile failed`, `XRay OFF : error in Status PLC_SetXRayonRelay();` (Sep 23/28), `Error HV (cmd:20/22 communication error)`, `Cannot read the 0 position`, `End of travel`, `couldn't reach the pos after 10 retries`. | `Get-Content 'C:\Xrdwin Log Files\10-2026.log' -Tail 30` |
| Retry record | `C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin\retry_reason.txt` | A new `2026-10-22 ...: XRayRetry` or `FitErrorRetryCollect` line means XrdWin retried by itself (with X-rays). Report it. | `Get-Content ... -Tail 3` |
| HV serial trace | `C:\Xrdwin Log Files\text11.txt` | Grows while the HV supply is being polled/driven; its last write time is a cheap "was HV active" indicator. | `Get-Item ... | Select Length,LastWriteTime` |
| X-rays OFF at the end | HUMAN: amber "X-Ray On" beacon OFF, red "Shutter Open" OFF, front panel; CLAUDE: status line shows 0.0 kV / 0.00 mA (screenshot), 'Set HV' tab 'Present Settings' 0/0 if opened, text11.txt stops growing. | Software OFF has failed before (Sep 2026) - **the beacon is the authority** (README rule 5; section 02). If the beacon stays lit: HUMAN presses X-Ray Enable off / turns the key / E-stop; Claude does not click 'X-Ray OFF' [2491] unless the human asks for it as an additional attempt. | - |

---

## 12. Phase 9: results

| # | WHO | Step | Notes |
|---|---|---|---|
| 9.1 | HUMAN | Inspect the fit on screen: click/double-click a profile pane to show background fit and ROI (other6.txt p.5; other8.txt p.5); check the d vs sin^2 psi plot for a straight line (shear shows as a psi-split ellipse) and the report pane. Right-click options (fit method, corrections, View Data/Results/Angles) are the human's (section 02 step 11). If the human re-fits (e.g. moves ROI/background), the document must be **saved again**, otherwise the stored stress is the one from auto-save (section 06: 41 of 163 reports differed from stored values because of unsaved re-fits). | Any re-fit is done by the human on the plot; Claude records what changed. |
| 9.2 | CLAUDE | `File > Save [57603]` (Ctrl+S) after the human agrees; for the Single Exposure document too if they want it kept (`Save As [57604]` opens a file dialog; keep the default folder = Data Path). | New/updated `22OCT26_000N.mt` (and `.st`). |
| 9.3 | CLAUDE | Text export: `File > Export To Text File > Profile && Gain [32868]`, `Profile && Gain(2Th) [32867]`, `Profile [32869]`, `Gain [32870]`, `2Theta [33079]` (menu 149; the 2010 manual's list is at sw manual lines 2069-2087). Each opens a save dialog; default name = document name with `.ProfileGain`, `_2th_.ProfileGain`, `.Profile`, `.Gain` extensions in the data folder (section 06 §4). Recommended: `Profile && Gain(2Th)` and `2Theta`. The human may also right-click the report pane > Copy To Excel / Word / Text (guidesheet.txt §3 hint). | Export files appear next to the .mt. |
| 9.4 | CLAUDE | Decode and summarise (read-only): `& "C:\Users\PROTO\AppData\Local\Programs\Python\Python37\python.exe" "C:\Users\PROTO\Documents\Vlachos lab\iXRDmini\iXRDmini_findings_2026-09-30\tools\ixrd_read.py" "C:\XrdWin Data\24193-24172T\Tube Change\22OCT26_000N.mt"` (add `--json` for machine-readable output, `--csv <out-in-prep-folder>` for the profiles). If `experiment-2026-10-22\tools\summarize_results.py` exists (written by another agent today), run it the same way on the new file and on `15OCT26_0007.mt`; write its output under `experiment-2026-10-22\prep\`. | Never pass an output path inside `C:\XrdWin Data`. |
| 9.5 | CLAUDE | Report to the human: stress +/- error (MPa), shear +/- error, n_beta and list, exposure, ROI, psi0 channels, material, operator, description, direction, start time, file name/size; quality flags: (a) reader warnings / size rule, (b) all profiles non-zero, (c) peak inside ROI at every tilt (column maxima per beta), (d) peak/background >= 1.3 at every tilt, (e) stress error relative to |stress| (Oct 15: 74 MPa on -126 MPa = 59 %, which the human should judge; EI project runs on steel reach ~7 MPa), (f) shear error, (g) any Abort/Ignore/Retry or auto-retry during the run, (h) duration from the exposure log vs expected. | - |
| 9.6 | CLAUDE | **Comparison with 15OCT26_0007.mt** (GRX 3, Short, 9 tilts, 35 s x 1, ROI [34,211]/[38,237], no gain): -126.43 +/- 74.29 MPa, shear 38.29 +/- 32.19 MPa, psi0 136.41 / 155.28. If today's sample is GRX 3 in the Short direction with the same recipe, a result within the combined 1-sigma errors (roughly -126 +/- ~100 MPa) is "consistent"; a different sign or > 2 sigma apart should be discussed (refocus, surface condition, ROI). If the sample or direction differs, report side by side without calling it a repeat. | - |

---

## 13. Phase 10: shutdown

| # | WHO | Step | Check |
|---|---|---|---|
| 10.1 | HUMAN | X-rays OFF confirmed by beacon and front panel (Phase 8). Note the time: **the >= 10 min cool-down starts now** (hw manual p.26 §4.4; guidesheet.txt §3.10). Claude starts a 10-min timer in the session log. | - |
| 10.2 | CLAUDE | Close the HV dialog if open (Cancel/OK, no X-Ray ON/OFF clicks). | - |
| 10.3 | HUMAN -> CLAUDE | **Home motors**: `Initialization > Move Motors [32791]` [dlg 163] -> 'M&ove to "0"' [1233] (sw manual lines 565-568: "home the motors at the end of the working session ... select Move to '0'"; guidesheet.txt §3.10). This is a motion event -> `GATE 7` ("go, home"). Confirm beta/Z/X read 0 afterwards (statics [1235/1236]). | Head at home. |
| 10.4 | HUMAN | Remove sample; remove aperture if that is lab practice; **close both detector slide covers** (hw manual p.26 §4.5); press X-Ray Enable off / turn the key to locked. | - |
| 10.5 | CLAUDE | Make sure all documents are saved (9.2); `File > Exit [57665]`. If a "save changes?" prompt appears, Claude reads it and the human decides. Confirm `Get-Process XrdWin,python` is empty afterwards (XrdWin runs `killaaa.bat`, which kills every python.exe, section 02 safety behaviour; Claude must not have any python of its own running at that moment). | Processes gone. |
| 10.6 | HUMAN | After the 10-min cool-down has elapsed: controller **Power** off; enclosure mains off if applicable. Never unplug motor/HV cables with power on (hw manual p.24). | - |
| 10.7 | CLAUDE | Final read-only snapshot for the record: exposure log tail, new files list with sizes/hashes (`Get-FileHash`), `LastWarmUp`, `LastIndex`; write the session summary to `experiment-2026-10-22\prep\session-log-2026-10-22.md`. | - |

---

## 14. Emergency / abort procedure

| Situation | HUMAN (the safety action) | CLAUDE (not a safety action) |
|---|---|---|
| Person near the beam, unexpected motion, collision imminent, smell/smoke, arcing that does not stop, software hang with X-rays on | **E-stop** (red mushroom on the controller front; a second one may be on the goniometer box, section 01 §4), or **pendant Reset** ("immediately stop motor movements and X-ray production", hw manual p.19), then key to locked, X-Ray Enable off. Verify amber and red beacons OFF. | Click '&Stop' [1243] in 'Online Data' [dlg 286] (or 'S&top' in WarmUp [dlg 427] / Initialization [dlg 206]) **if the window is reachable**, then immediately tell the human what the screen shows. Do not answer the Yes/No abort prompt; do not click 'X-Ray OFF'. Record the time and screenshot. |
| Beacon stays lit after a document ends / "XRay OFF : error" in the event log | Treat X-rays as ON: do not approach; X-Ray Enable off, key off, E-stop if needed; then check PLC/USB (hw manual p.40). | Report the log line and the status-line kV/mA; do not click anything. |
| Software hangs, UIA cannot find the window, PC freezes | Same as above; the PC is irrelevant to the interlocks. | Report; never kill XrdWin (no taskkill/Stop-Process); never open COM ports. |
| Fitting-error prompt [dlg 326] | Abort / Ignore / Retry (the human's call). | Read aloud, screenshot, wait. |
| Detector loss mid-run (frames stop, 'Aquisition Card Error' [dlg 324]) | Decide Try again / Cancel; check the detector USB afterwards. | Report; the collection may auto-retry with X-rays (AutoRetryCount 3). |
| After any emergency stop | Re-initialize (Phase 2, GATE) and re-warm if X-rays were off for long; a measurement stopped with "No" (pause) can be resumed with Collect > Continuate later [32865] (sw manual lines 2038-2051). | - |

Software Stop/Cancel only asks XrdWin to stop; the PLC chain (key, Enable, interlocks, beacon filaments, thermal/tube-in-place sensors, E-stop, pendant Reset) is what actually removes HV and blocks the shutter (hw manual p.20, p.42).

---

## 15. Questions to ask the human before starting (record every answer)

1. **Sample identity**: is it the same part as Oct 15 ("GRX 3", nickel-based, FCC 311)? Exact ID for 'Description:' and, if used, 'Job Number:' / 'Part Number:' / 'Lot No:' / 'Internal No' / 'Segment No'.
2. **Surface preparation**: as-received, cleaned, electropolished, depth removed (goes in 'Depth:')? Any coating or curvature that affects focus or beta clearance?
3. **Measurement direction** for 'Direction:' (Oct 15: "Short") and how the sample is oriented relative to the beta tilt plane.
4. **Material constants**: keep NICKEL (Mn_Ka) FCC(311), 2theta0 165.32 deg, 1/2 S2 6.5e-6, -S1 1.56e-6 /MPa? If another material: who selects it in the Material Chart (human), and is it in MATERIAL.CFG?
5. **Tube**: confirm the Mn tube is physically mounted (project "Tube Change") and the Tubes tab shows slot 3 = Mn; kV/mA to stay at 18 / 1.00.
6. **Aperture**: 2 mm round as on Oct 15, or another? (1 mm for standards; slots for gradients; hw manual p.17; other11/12.)
7. **Number of tilts and max beta**: 9 (Oct 15 list) or 11 (registry default); max beta 30 deg or lower after the clearance check (4.5), minus 3 deg margin (guidesheet.txt §3.5). Phi angles stay 1.
8. **Exposure**: keep 35 s x 1 per detector with +/-3 deg beta oscillation? (Change only if the test profile is weak/saturated.)
9. **Gain**: run with no gain / "No Correction" as on Oct 15, or collect a gain (shim available? Beta Ti or Fe for FCC Ni; P/G correction to be enabled by the human in Fitting Constants)?
10. **ROI / background**: keep [34,211] / [38,237] and the windows [[7,17],[240,250]] / [[11,21],[237,247]], or re-set on the test profile?
11. **Enclosure or barrier**: is an interlocked enclosure in use (door switch on the DB9 port) or the bypass plug with a barrier/5 m exclusion zone? Who else is in the room; are they beyond 5 m? Dosimeters worn?
12. **Warm-up choice**: 15 min recommended (7 days since last warm-up); accept, or 7 min / Conditioning?
13. **Operator of record** for the login and the exposure log (last: "Donovan"); who holds the password.
14. **Who clicks the action buttons** ('Initialization', '&Warm Up', 'OK' in 'Ready for collection?', 'M&ove to "0"'): Claude after the GATE, or the human?
15. **Project folder**: keep "Tube Change" or make a new project (File > New Project [32880])? New folder changes where today's `.mt` files land.
16. **Repeats**: one MET or several (e.g. two directions, or a repeat for error estimation)? Each repeat is a new `File > New > Multi` + GATE.
17. **Standards**: should a low-stress / high-stress standard be run first to check alignment (guidesheet.txt §2.2 hint; factory LSS +0.4 to +8.3 MPa, HSS -472 to -485 MPa, section 01 §6)? If yes, this is a separate SET/MET cycle with the 1 mm aperture.
18. **Stop criteria the human wants applied** (e.g. abort if the error after 5 tilts exceeds X MPa, or if any fit error appears).

---

### Appendix A: command and dialog ID quick reference (2024 build, from resources)

Menus (document-dependent; menu 148 = Single Exposure, 149 = Multiple Exposure):
- File > New > SET 183 | Multi 184 | Triaxial 186 | Square Map 187 | Circle Map 188 | Teach Map 189 | Austenite 190 | Pole Figure 191 | Single Crystal 192; Open 57601; Open Gain 32873; Save 57603; Save As 57604; Export To Text File: Profile && Gain 32868, Profile && Gain(2Th) 32867, Profile 32869, Gain 32870, 2Theta 33079, Setup XLS/XML/CSV 33087-33089; Choose Project 32874; New Project 32880; Set current project 33068; Batch... 33050; Exit 57665.
- Constants > Constants 32771 | Background 32772.
- Configuration > System Config 32921 (password, Proto only) | System 32773 | Save Configuration 32792 | Options 33075. (Not used today.)
- Initialization > Motors 32786 | High Voltage 32789 | Move Motors 32791 | Refocus 32891 | Defocus 32896 | Calibration 35000.
- Collect (SET): Profile 32838 | Gain 32834 | Quick gain 33070. Collect (MET): Multiple Exposure Technique 32800 | Calculation 32847 | Gain 32834 | Quick gain 33070 | Multi gain 33078 | Continuate later 32865.
- Help > Simulate 32987 (do not use).

Dialogs: User/login 173; Motors Initialization 206; MoveMotors 163; Set HV 428; WarmUp 427; Tubes 489; Collection Constants 112; Fitting Constants 113; Material Chart 114; Beta Angles 111; Motor Limits 115; Region of Interest (ROI) 116; Ready for collection? 221; Online Data 286; fitting-error Message 326; XRayEnable Warning 546; Aquisition Card Error 324; "Push OK to continue collection." 291; COM Ports 176 (never use).

Toolbar tooltips (string table): 32786 "Initialize the motors\nInit"; 32789 "Set High Voltage\nHV"; 32791 "Move Motors\nMove"; 32771 "...\nConstants"; 32772 "...\nPeak Fit Limits"; 32891 "Use AutoFocus\nAutofocus"; 32896 "Use Defocus\nDefocus"; 32873 "Open an existing gain file\nOpen Gain"; 32847 "Run calculation for entire document\nCalculation".

### Appendix B: read-only PowerShell snippets used in this runbook

```powershell
# detectors / hub / controller / dongle presence
Get-PnpDevice -InstanceId 'USB\VID_0403&PID_6010\FTDM8KES','USB\VID_0403&PID_6010\FTDM8KJE','USB\VID_14B0&PID_0439*','USB\VID_1A40&PID_0101*','USB\VID_0529*' | Select Status,Present,FriendlyName,InstanceId
Get-PnpDeviceProperty -InstanceId 'USB\VID_0403&PID_6010\FTDM8KES' -KeyName DEVPKEY_Device_LastArrivalDate,DEVPKEY_Device_LastRemovalDate,DEVPKEY_Device_BusReportedDeviceDesc
Get-PnpDevice -Class Ports | Select Status,Present,FriendlyName,InstanceId          # COM1/8/9 controller, COM5/7 detectors, COM4
# processes (never kill)
Get-Process -Name XrdWin,python -ErrorAction SilentlyContinue | Select Name,Id,StartTime
# logs and files
Get-Content 'C:\Xrdwin Log Files\ExposureXRay_10-2026.log' -Tail 5
Get-Content 'C:\Xrdwin Log Files\10-2026.log' -Tail 30
Get-Item 'C:\Xrdwin Log Files\text11.txt' | Select Length,LastWriteTime
Get-ChildItem C:\temp\test_*Event.pmf.dsc | Select Name,LastWriteTime
Get-ChildItem 'C:\XrdWin Data\24193-24172T\Tube Change' | Sort LastWriteTime | Select -Last 5 Name,Length,LastWriteTime
# registry (read only)
Get-ItemProperty 'HKCU:\Software\Proto Manufacturing Ltd\XrdWin\System' | Select LastWarmUp,LastData,LastIndex,'Data Path'
Get-ItemProperty 'HKCU:\Software\Proto Manufacturing Ltd\XrdWin\Constants\Collection Constants' | Select ExpTimeDet1,ExpTimeDet2,NrExpDet1,NrExpDet2,OscBeta,OscBetaCheck,Description,DirectionNumber
Get-ItemProperty 'HKCU:\Software\Proto Manufacturing Ltd\XrdWin\Constants\Angles Beta Constants' | Select NrBetaAngles,MaxBetaAngle,NrPhiAngles,AutoManual
# decode a document
& "C:\Users\PROTO\AppData\Local\Programs\Python\Python37\python.exe" "C:\Users\PROTO\Documents\Vlachos lab\iXRDmini\iXRDmini_findings_2026-09-30\tools\ixrd_read.py" "C:\XrdWin Data\24193-24172T\Tube Change\22OCT26_0002.mt"
```

Never: `[System.IO.Ports.SerialPort]`, `mode COMx`, pyserial, connections to 127.0.0.1:8094, `Stop-Process`, `taskkill`, `pnputil`, `Set-ItemProperty` on the XrdWin key, writes under `C:\XrdWin Data`, `C:\temp`, `C:\Xrdwin Log Files`, Program Files, `%LOCALAPPDATA%\PixetPro`.

### Appendix C: where this runbook may be wrong (verify on the day)

- Control captions may be renamed by `lang*.dat`; command and control IDs should still hold (section 02). Nobody has confirmed that MFC dialogs of this build expose names to UIA; step 1.6 is the first test.
- The radio-index mappings for ProfileCorrection = 2 ("No Correction") and LPACorrection = 2 ("LPA 2"), PeakLocationMethod = 1 ("Gaussian") are inferred from the order of the radio buttons in the dialog resources; confirm by reading the dialog.
- Whether '&Warm Up' auto-switches X-rays off at the end in this build (AutoXRayOff) or expects the operator to do so (2010 flow, warmup.txt) must be observed; in both cases the beacon decides.
- The MiniPIX count criteria in 9.1 are derived from one session (Oct 15) on one sample; they are a sanity band, not a specification.
- Which tube slot caption appears for Mn in the Tubes tab (the resource only has 'Cr' for slot 1) is filled at run time.
