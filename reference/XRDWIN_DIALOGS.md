# XrdWin 2.0 build 87 -- dialog / control-ID reference for GUI automation

Generated 2026-10-22 10:42 from the resource section of `C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin\XrdWin.exe` (8396800 bytes, read-only parse; nothing was executed). Cross-checked against `investigation-2026-09-30\_synth\software\xrdwin_resources.txt` and `_synth\binary\resources_xrdwin.txt` (see section 9). Prompt texts come from `raw\registry-config\xrdwin_exe_strings.txt` and `raw\pixet-detector\XrdWin.strings.txt`.

## 0. How to read this

* **Control ID** (decimal / hex) is what UI Automation exposes as `AutomationId` for these MFC dialogs. Standard IDs: IDOK=1, IDCANCEL=2, IDABORT=3, IDRETRY=4, IDIGNORE=5, IDYES=6, IDNO=7, ID_HELP=57670 (0xE146). `65535` is a static label without an ID (-1).
* **rect** = `[x, y, w, h]` in **dialog units** (font MS Sans Serif 8). Do not click by these numbers: read the live `BoundingRectangle` from UIA. Rough conversion: x*1.5, y*1.625 px at 96 DPI, then x1.25 for this 1536x864 / 125 % display.
* **style** is decoded from the template: push / default-push / check / radio / groupbox / edit / edit-readonly / edit-password / edit-number / combo-droplist / listbox / progress / icon / label. `(hidden)` = not WS_VISIBLE in the template (the code shows it only for some configurations). `(disabled)` = WS_DISABLED.
* Dialogs 111/112/113/114 (Constants) and 427/428/489 (High Voltage) are **property pages**. Their OK / Cancel / Apply buttons belong to the parent property sheet (IDOK=1, IDCANCEL=2, ID_APPLY_NOW=12321) and the tab strip is `AFX_IDC_TAB_CONTROL` = 12320. Switching tabs is SAFE; the sheet's OK commits all pages (CAUTION).
* **RISK**: `SAFE` = reading, Cancel/Exit/Close/Help, tab switching, read-only fields. `CAUTION` = changes a setting or starts something reversible with no motion and no X-rays. `DANGER` = motion, shutter, X-rays, homing, Initialize, Warm Up, X-Ray ON/OFF, OK on "Ready for collection?", Collect, Move, Home, Reset Error, Reconfigure, safety-option checkboxes, password fields and the Yes/No/Abort/Retry/Ignore buttons of safety prompts. A Claude GUI operator touches DANGER controls **never** on its own initiative; it reports the prompt and waits for the human at the instrument.
* Session rule that overrides everything here: today (2026-10-22) the operator is READ-ONLY. Nothing in this document is an instruction to click anything.

## 1. One-page SAFE control whitelist

Controls a GUI operator may read or activate without asking (reading is always allowed; "activate" means Cancel/Exit/Help/tab only).

| Dialog | ID | hex | Control | Why SAFE |
|---|---|---|---|---|
| 173 User | 1357 | 0x054D | (no text) (RO edit) | Read-only current project path. |
| 173 User | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 206   | 2 | 0x0002 | Exit  | Exit closes the dialog; does not stop a running thread. |
| 206   | 57670 | 0xE146 | Help  | closes the dialog / opens help; no hardware action |
| 427 WarmUp | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 427 WarmUp | 1090 | 0x0442 | Progress1  | progress display |
| 427 WarmUp | 1100 | 0x044C | (no text) (RO edit) | Read-only present kV. |
| 427 WarmUp | 1101 | 0x044D | (no text) (RO edit) | Read-only present mA. |
| 428 Set HV | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 428 Set HV | 1093 | 0x0445 | Progress3  | progress display |
| 489 Tubes | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 221 Ready for collection? | 2 | 0x0002 | Cancel  | Cancel: no collection starts. |
| 221 Ready for collection? | 1439 | 0x059F | (no text) (RO edit) | Read-only summary field: Nr of exposures (1). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1440 | 0x05A0 | (no text) (RO edit) | Read-only summary field: Exp. time per detector (35 s). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1126 | 0x0466 | (no text) (RO edit) | Read-only summary field: Material (e.g. NICKEL (Mn_Ka)). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1441 | 0x05A1 | (no text) (RO edit) | Read-only summary field: Radiation (Mn_Ka). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1318 | 0x0526 | (no text) (RO edit) | Read-only summary field: Beta angles summary. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1444 | 0x05A4 | (no text) (RO edit) | Read-only summary field: Phi angles summary. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1442 | 0x05A2 | (no text) (RO edit) | Read-only summary field: Fitting method. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1443 | 0x05A3 | (no text) (RO edit) | Read-only summary field: Profile correction. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 1009 | 0x03F1 | (no text) (RO edit) | Read-only summary field: LPA correction. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 221 Ready for collection? | 57670 | 0xE146 | Help  | closes the dialog / opens help; no hardware action |
| 286 Online Data | 1318 | 0x0526 | (no text) (RO edit) | Read-only live value: Beta position (deg). |
| 286 Online Data | 1572 | 0x0624 | (no text) (RO edit) | Read-only live value: X position. |
| 286 Online Data | 1573 | 0x0625 | (no text) (RO edit) | Read-only live value: Y position. |
| 286 Online Data | 1574 | 0x0626 | (no text) (RO edit) | Read-only live value: Z position. |
| 286 Online Data | 1444 | 0x05A4 | (no text) (RO edit) | Read-only live value: Phi position. |
| 286 Online Data | 1468 | 0x05BC | (no text) (RO edit) | Read-only live value: Stress (MPa/ksi) running result. |
| 286 Online Data | 1523 | 0x05F3 | (no text) (RO edit) | Read-only live value: Shear. |
| 286 Online Data | 1469 | 0x05BD | (no text) (RO edit) | Read-only live value: Stress error. |
| 286 Online Data | 1470 | 0x05BE | (no text) (RO edit) | Read-only live value: Breadth. |
| 286 Online Data | 1471 | 0x05BF | (no text) (RO edit) | Read-only live value: FWHM. |
| 286 Online Data | 1472 | 0x05C0 | (no text) (RO edit) | Read-only live value: Shear error. |
| 286 Online Data | 1445 | 0x05A5 | (no text) (RO edit) | Read-only live value: Rho position. |
| 112 Collection Constants | 2392 | 0x0958 | ?  | Help/info button. |
| 113 Fitting Constants | 1738 | 0x06CA | (no text) (RO edit) | Read-only file name. |
| 114 Material Chart | 1079 | 0x0437 | (no text) (RO edit) | Read-only wavelength (A). |
| 114 Material Chart | 1126 | 0x0466 | (no text) (RO edit) | Read-only material name. |
| 114 Material Chart | 1152 | 0x0480 | (no text) (RO edit) | Read-only symmetry (FCC). |
| 114 Material Chart | 1081 | 0x0439 | (no text) (RO edit) | Read-only hkl plane (311). |
| 163 MoveMotors | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 163 MoveMotors | 57670 | 0xE146 | Help  | closes the dialog / opens help; no hardware action |
| 335 User System Configuration | 2371 | 0x0943 | ?  | closes the dialog / opens help; no hardware action |
| 335 User System Configuration | 1018 | 0x03FA | ?  | Help "?" button. |
| 538 Options | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 559 Parameters | 2 | 0x0002 | Cancel  | closes the dialog / opens help; no hardware action |
| 491 Batch Processing | 1176 | 0x0498 | Stop  | Stops the offline batch calculation (no hardware involved). |
| 491 Batch Processing | 1 | 0x0001 | OK  | OK closes the dialog. |
| 491 Batch Processing | 1004 | 0x03EC | Progress1  | progress display |

Also SAFE everywhere: every `STATIC` label/icon, every `groupbox`, every `msctls_progress32`, the property-sheet tab strip (12320), menu **View > Toolbar / Status Bar**, **Help > Help Topics / About**, **File > Open... (57601)** (file dialog only), **Collect > Calculation (32847)** (recalculates from stored data), and reading any field with UIA `ValuePattern`/`Name`.

## 2. One-page DANGER control blacklist

Never activated by Claude. If one of these is the only way forward, stop and hand over to the human at the instrument.

| Dialog | ID | hex | Control | What it does |
|---|---|---|---|---|
| 173 User | 1358 | 0x054E |   [edit-password] | Password field. Policy: a Claude operator NEVER types a password; the human enters it. |
| 206   | 1292 | 0x050C | Initialization [default-push] | Starts InitializeThread: opens COM ports, resets and HOMES the motors (Beta/Z/X move to limit sensors), sets interlock, shutter check. Only on explicit human go-ahead with the person at the instrument. |
| 206   | 1020 | 0x03FC | Reset Error [push] | Reset Error: clears latched controller/PLC errors; may re-enable motion. |
| 206   | 1243 | 0x04DB | Stop [push] | Stop: aborts the running initialization thread. Abort decisions belong to the human. |
| 206   | 1019 | 0x03FB | Reconfigure [push (hidden)] | Reconfigure (hidden): rewrites the motor-controller configuration. |
| 206   | 2625 | 0x0A41 | Home [push] | Homes the axis selected in combo 1230 (or all axes if "Home all axis" is checked). Motion. |
| 427 WarmUp | 1095 | 0x0447 | Warm Up [push] | Warm Up: turns X-RAYS ON and ramps HV for 7/15 min (or Conditioning). WARNING string in the exe: "Safety Interlocks are bypassed for warm-up procedure and x-rays are being generated." |
| 427 WarmUp | 1243 | 0x04DB | Stop [push] | Stop: aborts the warm-up / commands HV off. X-rays-off must be confirmed at the beacon/front panel. |
| 428 Set HV | 1094 | 0x0446 | SetProfile [default-push] | SetProfile: sends the profile kV/mA to the Spellman supply (HV on). |
| 428 Set HV | 1369 | 0x0559 | To Max [check (hidden)] | To Max (hidden): ramp to maximum power. |
| 428 Set HV | 2491 | 0x09BB | X-Ray OFF [push] | X-Ray OFF: software X-ray-off command. It is the de-escalation control, but it has FAILED before ("PLC_SetXRayoffRelay: WriteFile failed"); the human confirms X-rays off at the beacon/front panel. |
| 428 Set HV | 2492 | 0x09BC | X-Ray ON [push] | X-Ray ON: turns X-rays on via PLC relay. Human only. |
| 428 Set HV | 1095 | 0x0447 | SetGain [default-push] | SetGain: sends the gain kV/mA to the supply (HV on). |
| 221 Ready for collection? | 1 | 0x0001 | OK [default-push] | OK STARTS THE COLLECTION: motors move to the beta tilts, shutter opens, X-RAYS ON (AutoXRayInCollectThread=1). Only the human presses it, at the instrument. |
| 221 Ready for collection? | 1022 | 0x03FE | Move Det. [check] | Move Det.: moves the detector axis to the Det1/Det2 angles when OK is pressed. |
| 286 Online Data | 1243 | 0x04DB | Stop [push] | Stop: interrupts the running collection; XrdWin then asks "abort (Yes) / pause (No)". Human decides. |
| 326 Message | 1629 | 0x065D | Abort [push] | Abort the measurement. Human answers. |
| 326 Message | 1692 | 0x069C | Ignore [push] | Ignore the fitting error and continue collecting (more X-ray exposures). Human answers. |
| 326 Message | 1693 | 0x069D | Retry [default-push] | Retry: re-collects this angle (X-rays on again). Human answers. |
| 546 Warning | 6 | 0x0006 | Yes [default-push] | Yes = continue with X-rays although the X-Ray Enable button is not pressed. NEVER pressed by Claude. |
| 546 Warning | 7 | 0x0007 | No [push] | No = do not continue. Safe outcome, but the prompt itself is an X-ray prompt: the human answers it. |
| 112 Collection Constants | 1197 | 0x04AD | Motor Limits [push] | Motor Limits: opens the software motor-limit editor; wrong limits allow collisions. |
| 112 Collection Constants | 1198 | 0x04AE | Motor Home Pos [push] | Motor Home Pos: edits home positions used by Initialize/Home. |
| 111 Beta Angles | 1017 | 0x03F9 | Fix Bad Osc [push (hidden)] | Fix Bad Osc (hidden): writes a new oscillation program to the motor controller. |
| 163 MoveMotors | 3 | 0x0003 | Move [default-push] | Move: moves the selected axis to the typed value. IDABORT id 3 is reused as the Move button. |
| 163 MoveMotors | 1233 | 0x04D1 | Move to "0" [push] | Move to "0": moves the selected axis to zero. |
| 163 MoveMotors | 1287 | 0x0507 | Stop [push] | Stop: sends StopMotors to the controller (interrupts motion). Human decision. |
| 163 MoveMotors | 4 | 0x0004 | Refocus [push (hidden)] | Refocus (hidden): Z motion (autofocus). |
| 163 MoveMotors | 1951 | 0x079F | OscTest [push] | OscTest: runs an oscillation test (motion). |
| 163 MoveMotors | 2616 | 0x0A38 | Z=0 [push] | Z=0: zeroes/moves the Z axis (prompt "X, Y motors are not at 0, do you wish to set the current position to zero?"). |
| 163 MoveMotors | 2617 | 0x0A39 | XY=0 [push] | XY=0: zeroes/moves X and Y. |
| 163 MoveMotors | 2618 | 0x0A3A | Beta=0 [push] | Beta=0: zeroes/moves Beta (prompt "Beta is not in zero. Do you want to move Beta to zero?"). |
| 163 MoveMotors | 2619 | 0x0A3B | Phi=0 [push] | Phi=0: zeroes/moves Phi. |
| 335 User System Configuration | 1569 | 0x0621 | Open Shutter [push] | Open Shutter: opens the X-ray shutter via PLC. |
| 335 User System Configuration | 1570 | 0x0622 | Close Shutter [push] | Close Shutter: PLC shutter command. |
| 335 User System Configuration | 1701 | 0x06A5 | Full System [radio] | Full System radio: changes the motor configuration ("The Full system must be enabled in order to change the motor configuration"). |
| 335 User System Configuration | 1702 | 0x06A6 | Beta  Z System [radio] | Beta  Z System radio: changes the motor configuration. |
| 335 User System Configuration | 1710 | 0x06AE | AutoXRayOff [check] | AutoXRayOff checkbox (ON today). Unchecking removes the automatic X-ray-off after collection. |
| 335 User System Configuration | 1884 | 0x075C | Axis UpsideDown [check] | Axis UpsideDown: inverts axis direction. |
| 335 User System Configuration | 2090 | 0x082A | Move Beta to '0' after SET, Austenite [check] | Move Beta to '0' after SET, Austenite: motion after collections. |
| 335 User System Configuration | 2315 | 0x090B | Write Controller [push] | Write Controller: writes motor-controller parameters. |
| 335 User System Configuration | 1711 | 0x06AF | XRayDisable [check] | XRayDisable checkbox: "Disable checking the ReadXRay, CloseShutter/OpenShutter". Safety-relevant. |
| 335 User System Configuration | 2548 | 0x09F4 | Disable Phi Limits [check] | Disable Phi Limits: removes software motion limits. |
| 335 User System Configuration | 2715 | 0x0A9B | Osc Prog [push] | Osc Prog: writes the oscillation program to the controller. |
| 335 User System Configuration | 2349 | 0x092D | Local [push] | Local: switches the HV supply to local mode (XrdWin loses control). |
| 335 User System Configuration | 2356 | 0x0934 | Remote [push] | Remote: switches the HV supply to remote mode. |
| 335 User System Configuration | 1712 | 0x06B0 | Standard Stages [radio] | Standard Stages radio: motor configuration. |
| 335 User System Configuration | 1713 | 0x06B1 | LargeStages [radio] | LargeStages radio: motor configuration. |
| 335 User System Configuration | 1024 | 0x0400 | DisablePhiMove SET,MET [check] | DisablePhiMove SET,MET: changes motion behaviour. |
| 538 Options | 2082 | 0x0822 | Check for X-Ray* [check] | Check for X-Ray* (CheckForXRay=1 today): disabling removes the X-ray state check before collecting. |
| 538 Options | 2500 | 0x09C4 | Init in CollectThread* [check] | Init in CollectThread*: XrdWin initializes (homes) by itself at collection start. |
| 538 Options | 2501 | 0x09C5 | AutoXray in CollectThread [check] | AutoXray in CollectThread (AutoXRayInCollectThread=1): X-rays switched on automatically inside a collection; "If the system wasn't initialized/warmed-up/set HV will do that before." |
| 538 Options | 1053 | 0x041D | Auto-Retry Coll XRay OFF [check] | Auto-Retry Coll XRay OFF (AutoRetryCollXRayOff=1): auto re-collect when X-rays were off. |
| 538 Options | 2843 | 0x0B1B | Use I5 Limit Sensor [check] | Use I5 Limit Sensor: limit-sensor wiring option. |
| 559 Parameters | 1031 | 0x0407 | ON [push] | ON: powers the detector USB hub via the COM device given in 1034 (hardware action, hub power). |
| 559 Parameters | 1032 | 0x0408 | OFF [push] | OFF: powers the detector hub off (hardware action). |

DANGER menu commands (main window, all document menus): Initialization > **Motors 32786**, **High Voltage 32789**, **Move Motors 32791**, **Refocus 32891**, **Defocus 32896**, **Calibration 35000**; Collect > **Profile 32838**, **Gain 32834**, **Quick gain 33070**, **Multi gain 33078**, **Multiple Exposure Technique 32800**, **Continuate later 32865**, every "Collect ..." / "... Method" entry (32799-32805, 33045, 33048), Austenite Setup/Calibration (32885/32886/32889/32962); the whole **Go** menu (32967-32983: Initialize, High Voltage, Autofocus, Defocus, Move Beta/Phi/X/Y/Z, New ...). Toolbar 128 buttons **Init (32786)**, **HV (32789)**, **Move (32791)**, **Defocus (32896)**, **Autofocus (32891)** are DANGER.

DANGER prompts (section 8): anything containing x-ray / XRayEnable / warm / shutter / door / interlock / limit / homed / move / continue / recollect / retry / abort / pause -> HUMAN answers.

## 3. Requested dialogs -- full control lists

### Dialog 173 -- "User" -- User login (shown at start-up)

DIALOGEX template, 12 controls, size 186x114 DLU, lang 1033, 1 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1247 | 0x04DF | EDIT | edit |   | 13,24,95,14 | **CAUTION** | Operator name (e.g. "Donovan"). Typing a name is harmless; it is written into the data files. |
| 1358 | 0x054E | EDIT | edit-password |   | 13,51,95,14 | **DANGER** | Password field. Policy: a Claude operator NEVER types a password; the human enters it. |
| 1 | 0x0001 | BUTTON | default-push | OK | 123,7,56,14 | **CAUTION** | Logs the operator in and opens the main frame. AutoInit=0 in the registry today, so no motion follows; with AutoInit=1 XrdWin would start Initialize (homing) by itself. |
| 1248 | 0x04E0 | STATIC | label | Please input your name: | 14,13,101,8 | **SAFE** |   |
| 1355 | 0x054B | BUTTON | push | New Project | 123,21,56,14 | **CAUTION** | Creates a new project folder under C:\XrdWin Data (file-system write). |
| 1357 | 0x054D | EDIT | edit-readonly |   | 13,78,166,14 | **SAFE** | Read-only current project path. |
| 1249 | 0x04E1 | STATIC | label | Current project: | 14,67,101,8 | **SAFE** |   |
| 1250 | 0x04E2 | STATIC | label | Current language: | 13,95,96,8 | **SAFE** |   |
| 1394 | 0x0572 | COMBOBOX | combo-droplist |   | 111,94,68,96 | **CAUTION** | Language selection (persisted). |
| 2 | 0x0002 | BUTTON | push | Cancel | 123,35,56,14 | **SAFE** |   |
| 1251 | 0x04E3 | STATIC | label | Password: | 14,40,101,8 | **SAFE** |   |
| 1868 | 0x074C | COMBOBOX | combo-droplist (hidden) |   | 123,52,56,87 | **CAUTION** |   |

### Dialog 206 -- " " -- Motors Initialization (Initialization > Motors, cmd 32786, toolbar "Init")

DIALOGEX template, 17 controls, size 190x231 DLU, lang 1033, 5 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1292 | 0x050C | BUTTON | default-push | Initialization | 19,89,84,14 | **DANGER** | Starts InitializeThread: opens COM ports, resets and HOMES the motors (Beta/Z/X move to limit sensors), sets interlock, shutter check. Only on explicit human go-ahead with the person at the instrument. |
| 2 | 0x0002 | BUTTON | push | Exit | 19,178,84,14 | **SAFE** | Exit closes the dialog; does not stop a running thread. |
| 1017 | 0x03F9 | BUTTON | push | COM Port | 19,104,84,14 | **CAUTION** | Opens the COM Ports dialog (176); changing a port breaks communication with motors/PLC/HV. |
| 1020 | 0x03FC | BUTTON | push | Reset Error | 19,119,84,14 | **DANGER** | Reset Error: clears latched controller/PLC errors; may re-enable motion. |
| 57670 | 0xE146 | BUTTON | push | Help | 19,193,84,14 | **SAFE** |   |
| 1243 | 0x04DB | BUTTON | push | Stop | 19,163,84,14 | **DANGER** | Stop: aborts the running initialization thread. Abort decisions belong to the human. |
| 1229 | 0x04CD | COMBOBOX | combo-droplist (hidden) |   | 121,132,49,93 | **CAUTION** |   |
| 1228 | 0x04CC | COMBOBOX | combo-droplist (hidden) |   | 121,117,49,93 | **CAUTION** |   |
| 1052 | 0x041C | STATIC | bitmap-sunken | #156 | 7,7,176,60 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 7,69,176,155 | **SAFE** |   |
| 1019 | 0x03FB | BUTTON | push (hidden) | Reconfigure | 19,210,84,14 | **DANGER** | Reconfigure (hidden): rewrites the motor-controller configuration. |
| 1304 | 0x0518 | BUTTON | groupbox | Home Motors | 115,81,61,136 | **SAFE** |   |
| 1290 | 0x050A | BUTTON | check | Home this axis | 123,148,46,17 | **CAUTION** | Checkbox: selects single-axis homing for the Home button (affects later motion). |
| 1291 | 0x050B | BUTTON | check | Home all axis | 123,166,45,17 | **CAUTION** | Checkbox: Home all axes when Home is pressed (affects later motion). |
| 1230 | 0x04CE | COMBOBOX | combo-droplist |   | 121,125,49,93 | **CAUTION** | Axis selector for Home (Beta/Z/X ...). |
| 2546 | 0x09F2 | BUTTON | check | Home Det. Axis in Init. | 123,187,46,26 | **CAUTION** | Checkbox: also home the detector axis during Initialize (affects later motion). |
| 2625 | 0x0A41 | BUTTON | push | Home | 120,94,50,14 | **DANGER** | Homes the axis selected in combo 1230 (or all axes if "Home all axis" is checked). Motion. |

### Dialog 427 -- "WarmUp" -- High Voltage WarmUp tab (Initialization > High Voltage, cmd 32789; property page)

DIALOG template, 20 controls, size 214x156 DLU, lang 1033, 2 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1098 | 0x044A | EDIT | edit |   | 55,19,29,14 | **CAUTION** | Target kV for the warm-up. Tube limit for Mn/Cr tube: 18 kV (MaxKV=20). |
| 1099 | 0x044B | EDIT | edit |   | 145,19,29,14 | **CAUTION** | Target mA for the warm-up. Tube limit: 1.00 mA, 20 W. |
| 1701 | 0x06A5 | BUTTON | radio | 7 min: If the tube has been used in the last week | 12,50,187,10 | **CAUTION** | Selects the 7-min program (tube used in the last week). |
| 1702 | 0x06A6 | BUTTON | radio | 15 min: If the tube has NOT been used in the last week | 12,61,190,10 | **CAUTION** | Selects the 15-min program (tube NOT used in the last week). |
| 1703 | 0x06A7 | BUTTON | radio | Conditioning | 12,72,190,10 | **CAUTION** | Selects Conditioning (long program, ~40 min per the README rules). |
| 1 | 0x0001 | BUTTON | default-push (hidden) | OK | 157,135,50,14 | **CAUTION** | OK commits the dialog. |
| 2 | 0x0002 | BUTTON | push (hidden) | Cancel | 157,135,50,14 | **SAFE** |   |
| 1095 | 0x0447 | BUTTON | push | Warm Up | 51,135,50,14 | **DANGER** | Warm Up: turns X-RAYS ON and ramps HV for 7/15 min (or Conditioning). WARNING string in the exe: "Safety Interlocks are bypassed for warm-up procedure and x-rays are being generated." |
| 1253 | 0x04E5 | BUTTON | groupbox | Warm Up Period | 7,7,200,78 | **SAFE** |   |
| 1254 | 0x04E6 | STATIC | label | Voltage: | 21,22,33,8 | **SAFE** |   |
| 1255 | 0x04E7 | STATIC | label | Current: | 111,22,33,8 | **SAFE** |   |
| 1257 | 0x04E9 | STATIC | label | kV | 90,22,18,8 | **SAFE** |   |
| 1258 | 0x04EA | STATIC | label | mA | 180,22,18,8 | **SAFE** |   |
| 1261 | 0x04ED | BUTTON | groupbox | Elapsed Time | 7,86,200,44 | **SAFE** |   |
| 1090 | 0x0442 | msctls_progress32 | progress | Progress1 | 11,98,190,14 | **SAFE** |   |
| 1370 | 0x055A | STATIC | label-center | Static | 89,116,32,10 | **SAFE** |   |
| 1243 | 0x04DB | BUTTON | push | Stop | 104,135,50,14 | **DANGER** | Stop: aborts the warm-up / commands HV off. X-rays-off must be confirmed at the beacon/front panel. |
| 1100 | 0x044C | EDIT | edit-readonly |   | 55,33,29,14 | **SAFE** | Read-only present kV. |
| 1101 | 0x044D | EDIT | edit-readonly |   | 145,33,29,14 | **SAFE** | Read-only present mA. |
| 2612 | 0x0A34 | STATIC | label |   | 132,117,68,8 | **SAFE** |   |

### Dialog 428 -- "Set HV" -- Set HV tab (property page of the High Voltage sheet)

DIALOG template, 26 controls, size 214x156 DLU, lang 1033, 5 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1096 | 0x0448 | EDIT | edit |   | 55,19,29,14 | **CAUTION** | Profile kV (limit 18 kV). |
| 1097 | 0x0449 | EDIT | edit |   | 145,19,29,14 | **CAUTION** | Profile mA (limit 1.00 mA). |
| 2498 | 0x09C2 | EDIT | edit |   | 55,50,29,14 | **CAUTION** | Gain kV. |
| 2499 | 0x09C3 | EDIT | edit |   | 145,50,29,14 | **CAUTION** | Gain mA. |
| 1 | 0x0001 | BUTTON | default-push (hidden) | OK | 135,113,50,14 | **CAUTION** | OK commits the dialog. |
| 2 | 0x0002 | BUTTON | push (hidden) | Cancel | 133,114,50,14 | **SAFE** |   |
| 1094 | 0x0446 | BUTTON | default-push | SetProfile | 27,135,50,14 | **DANGER** | SetProfile: sends the profile kV/mA to the Spellman supply (HV on). |
| 1248 | 0x04E0 | BUTTON | groupbox | Present Settings | 7,7,200,67 | **SAFE** |   |
| 1249 | 0x04E1 | STATIC | label | Voltage: | 21,22,33,8 | **SAFE** |   |
| 1250 | 0x04E2 | STATIC | label | Current: | 111,22,33,8 | **SAFE** |   |
| 1251 | 0x04E3 | STATIC | label | kV | 91,22,18,8 | **SAFE** |   |
| 1252 | 0x04E4 | STATIC | label | mA | 180,22,18,8 | **SAFE** |   |
| 1260 | 0x04EC | BUTTON | groupbox | Power | 7,78,200,51 | **SAFE** |   |
| 1093 | 0x0445 | msctls_progress32 | progress | Progress3 | 13,92,188,12 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label | 0 | 13,114,8,8 | **SAFE** |   |
| 1367 | 0x0557 | STATIC | label-right | 45 | 165,114,35,8 | **SAFE** |   |
| 1368 | 0x0558 | STATIC | label-center | Static | 79,111,56,10 | **SAFE** |   |
| 1369 | 0x0559 | BUTTON | check (hidden) | To Max | 161,139,37,10 | **DANGER** | To Max (hidden): ramp to maximum power. |
| 2491 | 0x09BB | BUTTON | push | X-Ray OFF | 7,135,48,14 | **DANGER** | X-Ray OFF: software X-ray-off command. It is the de-escalation control, but it has FAILED before ("PLC_SetXRayoffRelay: WriteFile failed"); the human confirms X-rays off at the beacon/front panel. |
| 1267 | 0x04F3 | BUTTON | groupbox | Gain | 7,37,200,37 | **SAFE** |   |
| 1253 | 0x04E5 | STATIC | label | Voltage: | 21,52,33,8 | **SAFE** |   |
| 1254 | 0x04E6 | STATIC | label | Current: | 111,52,33,8 | **SAFE** |   |
| 1255 | 0x04E7 | STATIC | label | kV | 91,52,18,8 | **SAFE** |   |
| 1256 | 0x04E8 | STATIC | label | mA | 180,52,18,8 | **SAFE** |   |
| 2492 | 0x09BC | BUTTON | push | X-Ray ON | 159,135,48,14 | **DANGER** | X-Ray ON: turns X-rays on via PLC relay. Human only. |
| 1095 | 0x0447 | BUTTON | default-push | SetGain | 129,135,50,14 | **DANGER** | SetGain: sends the gain kV/mA to the supply (HV on). |

### Dialog 489 -- "Tubes" -- Tubes tab (property page of the High Voltage sheet)

DIALOG template, 54 controls, size 214x156 DLU, lang 1033, 0 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1701 | 0x06A5 | BUTTON | radio (hidden) | Cr | 12,33,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1130 | 0x046A | EDIT | edit (hidden) |   | 43,30,24,12 | **CAUTION** |   |
| 1144 | 0x0478 | EDIT | edit (hidden) |   | 69,30,24,12 | **CAUTION** |   |
| 1001 | 0x03E9 | EDIT | edit (hidden) |   | 113,30,24,12 | **CAUTION** |   |
| 1010 | 0x03F2 | EDIT | edit (hidden) |   | 139,30,24,12 | **CAUTION** |   |
| 1702 | 0x06A6 | BUTTON | radio (hidden) |   | 12,46,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1131 | 0x046B | EDIT | edit (hidden) |   | 43,43,24,12 | **CAUTION** |   |
| 1145 | 0x0479 | EDIT | edit (hidden) |   | 69,43,24,12 | **CAUTION** |   |
| 1002 | 0x03EA | EDIT | edit (hidden) |   | 113,43,24,12 | **CAUTION** |   |
| 1011 | 0x03F3 | EDIT | edit (hidden) |   | 139,43,24,12 | **CAUTION** |   |
| 1703 | 0x06A7 | BUTTON | radio (hidden) |   | 12,59,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1132 | 0x046C | EDIT | edit (hidden) |   | 43,56,24,12 | **CAUTION** |   |
| 1146 | 0x047A | EDIT | edit (hidden) |   | 69,56,24,12 | **CAUTION** |   |
| 1003 | 0x03EB | EDIT | edit (hidden) |   | 113,56,24,12 | **CAUTION** |   |
| 1012 | 0x03F4 | EDIT | edit (hidden) |   | 139,56,24,12 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio (hidden) |   | 12,72,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1133 | 0x046D | EDIT | edit (hidden) |   | 43,69,24,12 | **CAUTION** |   |
| 1147 | 0x047B | EDIT | edit (hidden) |   | 69,69,24,12 | **CAUTION** |   |
| 1004 | 0x03EC | EDIT | edit (hidden) |   | 113,69,24,12 | **CAUTION** |   |
| 1013 | 0x03F5 | EDIT | edit (hidden) |   | 139,69,24,12 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio (hidden) |   | 12,85,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1134 | 0x046E | EDIT | edit (hidden) |   | 43,82,24,12 | **CAUTION** |   |
| 1148 | 0x047C | EDIT | edit (hidden) |   | 69,82,24,12 | **CAUTION** |   |
| 1005 | 0x03ED | EDIT | edit (hidden) |   | 113,82,24,12 | **CAUTION** |   |
| 1014 | 0x03F6 | EDIT | edit (hidden) |   | 139,82,24,12 | **CAUTION** |   |
| 1706 | 0x06AA | BUTTON | radio (hidden) |   | 12,97,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1135 | 0x046F | EDIT | edit (hidden) |   | 43,94,24,12 | **CAUTION** |   |
| 1149 | 0x047D | EDIT | edit (hidden) |   | 69,94,24,12 | **CAUTION** |   |
| 1006 | 0x03EE | EDIT | edit (hidden) |   | 113,94,24,12 | **CAUTION** |   |
| 1015 | 0x03F7 | EDIT | edit (hidden) |   | 139,94,24,12 | **CAUTION** |   |
| 1707 | 0x06AB | BUTTON | radio (hidden) |   | 12,110,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1136 | 0x0470 | EDIT | edit (hidden) |   | 43,107,24,12 | **CAUTION** |   |
| 1150 | 0x047E | EDIT | edit (hidden) |   | 69,107,24,12 | **CAUTION** |   |
| 1007 | 0x03EF | EDIT | edit (hidden) |   | 113,107,24,12 | **CAUTION** |   |
| 1016 | 0x03F8 | EDIT | edit (hidden) |   | 139,107,24,12 | **CAUTION** |   |
| 1708 | 0x06AC | BUTTON | radio (hidden) |   | 12,123,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1137 | 0x0471 | EDIT | edit (hidden) |   | 43,120,24,12 | **CAUTION** |   |
| 1151 | 0x047F | EDIT | edit (hidden) |   | 69,120,24,12 | **CAUTION** |   |
| 1008 | 0x03F0 | EDIT | edit (hidden) |   | 113,120,24,12 | **CAUTION** |   |
| 1017 | 0x03F9 | EDIT | edit (hidden) |   | 139,120,24,12 | **CAUTION** |   |
| 1709 | 0x06AD | BUTTON | radio (hidden) |   | 12,136,25,10 | **CAUTION** | Selects the active tube slot (slot 1 = Cr, slot 3 = Mn today). Hidden in template, shown at run time. |
| 1138 | 0x0472 | EDIT | edit (hidden) |   | 43,133,24,12 | **CAUTION** |   |
| 1152 | 0x0480 | EDIT | edit (hidden) |   | 69,133,24,12 | **CAUTION** |   |
| 1009 | 0x03F1 | EDIT | edit (hidden) |   | 113,133,24,12 | **CAUTION** |   |
| 1018 | 0x03FA | EDIT | edit (hidden) |   | 139,133,24,12 | **CAUTION** |   |
| 1 | 0x0001 | BUTTON | default-push (hidden) | OK | 157,135,50,14 | **CAUTION** | OK commits the dialog. |
| 2 | 0x0002 | BUTTON | push (hidden) | Cancel | 157,135,50,14 | **SAFE** |   |
| 1248 | 0x04E0 | BUTTON | groupbox | Tubes | 7,7,200,142 | **SAFE** |   |
| 2468 | 0x09A4 | STATIC | label (hidden) | Voltage | 42,21,25,8 | **SAFE** |   |
| 2469 | 0x09A5 | STATIC | label (hidden) | Current | 71,21,24,8 | **SAFE** |   |
| 2470 | 0x09A6 | STATIC | label (hidden) | Voltage | 112,21,25,8 | **SAFE** |   |
| 2471 | 0x09A7 | STATIC | label (hidden) | Current | 141,21,24,8 | **SAFE** |   |
| 1688 | 0x0698 | STATIC | label-center (hidden) | Gain | 117,12,35,8 | **SAFE** |   |
| 1687 | 0x0697 | STATIC | label-center | Warm-Up | 53,12,31,8 | **SAFE** |   |

### Dialog 221 -- "Ready for collection?" -- Ready for collection? (shown before EVERY collection)

DIALOGEX template, 48 controls, size 230x231 DLU, lang 1033, 2 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1307 | 0x051B | EDIT | edit |   | 7,148,112,14 | **CAUTION** | Description (free text, e.g. "GRX 3"). |
| 1866 | 0x074A | EDIT | edit |   | 7,176,70,14 | **CAUTION** | Job Number. |
| 1867 | 0x074B | EDIT | edit |   | 80,176,70,14 | **CAUTION** | Part Number. |
| 1992 | 0x07C8 | EDIT | edit |   | 153,176,70,14 | **CAUTION** | Lot No. |
| 1994 | 0x07CA | EDIT | edit |   | 7,210,54,14 | **CAUTION** | Internal No. |
| 1996 | 0x07CC | EDIT | edit |   | 61,210,54,14 | **CAUTION** | Segment No. |
| 2141 | 0x085D | EDIT | edit |   | 115,210,54,14 | **CAUTION** | Direction (e.g. "Short"). |
| 1510 | 0x05E6 | EDIT | edit |   | 169,210,54,14 | **CAUTION** | Depth. |
| 1 | 0x0001 | BUTTON | default-push | OK | 123,148,50,14 | **DANGER** | OK STARTS THE COLLECTION: motors move to the beta tilts, shutter opens, X-RAYS ON (AutoXRayInCollectThread=1). Only the human presses it, at the instrument. |
| 2 | 0x0002 | BUTTON | push | Cancel | 173,148,50,14 | **SAFE** | Cancel: no collection starts. |
| 1262 | 0x04EE | STATIC | label | Description: | 7,138,63,8 | **SAFE** |   |
| 1248 | 0x04E0 | BUTTON | groupbox | Collection | 7,7,110,46 | **SAFE** |   |
| 1249 | 0x04E1 | STATIC | label | Nr of exp: | 13,36,32,8 | **SAFE** |   |
| 1250 | 0x04E2 | STATIC | label | Exp. time: | 13,18,32,8 | **SAFE** |   |
| 1251 | 0x04E3 | BUTTON | groupbox | Fitting | 119,7,104,46 | **SAFE** |   |
| 1252 | 0x04E4 | STATIC | label | Method: | 123,16,39,8 | **SAFE** |   |
| 1253 | 0x04E5 | STATIC | label | Correction: | 123,27,39,8 | **SAFE** |   |
| 1254 | 0x04E6 | STATIC | label | LPA: | 123,38,39,8 | **SAFE** |   |
| 1255 | 0x04E7 | BUTTON | groupbox | Material | 7,53,110,40 | **SAFE** |   |
| 1257 | 0x04E9 | STATIC | label | Material: | 13,65,28,8 | **SAFE** |   |
| 1258 | 0x04EA | STATIC | label | Radiation: | 13,77,33,8 | **SAFE** |   |
| 1259 | 0x04EB | BUTTON | groupbox | Angles | 119,53,104,40 | **SAFE** |   |
| 1260 | 0x04EC | STATIC | label | Beta: | 123,62,27,8 | **SAFE** |   |
| 1261 | 0x04ED | STATIC | label | Phi: | 124,76,27,8 | **SAFE** |   |
| 1439 | 0x059F | EDIT | edit-readonly |   | 48,33,63,14 | **SAFE** | Read-only summary field: Nr of exposures (1). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1440 | 0x05A0 | EDIT | edit-readonly |   | 48,16,63,14 | **SAFE** | Read-only summary field: Exp. time per detector (35 s). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1126 | 0x0466 | EDIT | edit-readonly |   | 48,60,63,14 | **SAFE** | Read-only summary field: Material (e.g. NICKEL (Mn_Ka)). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1441 | 0x05A1 | EDIT | edit-readonly |   | 48,75,63,14 | **SAFE** | Read-only summary field: Radiation (Mn_Ka). Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1318 | 0x0526 | EDIT | edit-readonly |   | 154,60,63,14 | **SAFE** | Read-only summary field: Beta angles summary. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1444 | 0x05A4 | EDIT | edit-readonly |   | 154,75,63,14 | **SAFE** | Read-only summary field: Phi angles summary. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1442 | 0x05A2 | EDIT | edit-readonly |   | 165,13,52,12 | **SAFE** | Read-only summary field: Fitting method. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1443 | 0x05A3 | EDIT | edit-readonly |   | 165,25,52,12 | **SAFE** | Read-only summary field: Profile correction. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 1009 | 0x03F1 | EDIT | edit-readonly |   | 165,38,52,12 | **SAFE** | Read-only summary field: LPA correction. Read it with UIA ValuePattern to verify the setup before the human presses OK. |
| 57670 | 0xE146 | BUTTON | push | Help | 173,133,50,14 | **SAFE** |   |
| 1575 | 0x0627 | BUTTON | check | Austenite Percentage | 79,128,144,10 | **CAUTION** | Austenite Percentage checkbox (asks for % retained austenite). |
| 1687 | 0x0697 | STATIC | label | Job Number: | 7,167,72,8 | **SAFE** |   |
| 1865 | 0x0749 | STATIC | label | Part Number: | 83,167,68,8 | **SAFE** |   |
| 1688 | 0x0698 | STATIC | label | Internal No | 7,196,53,8 | **SAFE** |   |
| 1870 | 0x074E | STATIC | label | Direction: | 117,195,51,8 | **SAFE** |   |
| 1689 | 0x0699 | STATIC | label | Segment No | 61,195,53,8 | **SAFE** |   |
| 1690 | 0x069A | STATIC | label | Depth: | 171,195,52,8 | **SAFE** |   |
| 1872 | 0x0750 | STATIC | label | Lot No: | 155,167,68,8 | **SAFE** |   |
| 2874 | 0x0B3A | BUTTON | groupbox | Detector Angle | 7,94,216,29 | **SAFE** |   |
| 1263 | 0x04EF | STATIC | label | Det1: | 34,108,18,8 | **SAFE** |   |
| 1308 | 0x051C | EDIT | edit |   | 56,105,35,14 | **CAUTION** | Detector 1 angle; applied only with "Move Det." checked (then motion). |
| 1264 | 0x04F0 | STATIC | label | Det2: | 98,108,18,8 | **SAFE** |   |
| 1309 | 0x051D | EDIT | edit |   | 120,105,35,14 | **CAUTION** | Detector 2 angle; applied only with "Move Det." checked (then motion). |
| 1022 | 0x03FE | BUTTON | check | Move Det. | 163,107,49,10 | **DANGER** | Move Det.: moves the detector axis to the Det1/Det2 angles when OK is pressed. |

### Dialog 286 -- "Online Data" -- Online Data (collection progress window)

DIALOGEX template, 38 controls, size 301x118 DLU, lang 1033, 1 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1252 | 0x04E4 | STATIC | label | Beta: | 12,66,18,8 | **SAFE** |   |
| 1318 | 0x0526 | EDIT | edit-readonly |   | 42,63,34,12 | **SAFE** | Read-only live value: Beta position (deg). |
| 1249 | 0x04E1 | STATIC | label | X: | 13,21,8,8 | **SAFE** |   |
| 1572 | 0x0624 | EDIT | edit-readonly |   | 42,18,34,12 | **SAFE** | Read-only live value: X position. |
| 1250 | 0x04E2 | STATIC | label | Y: | 13,36,8,8 | **SAFE** |   |
| 1573 | 0x0625 | EDIT | edit-readonly |   | 42,33,34,12 | **SAFE** | Read-only live value: Y position. |
| 1251 | 0x04E3 | STATIC | label | Z: | 13,51,8,8 | **SAFE** |   |
| 1574 | 0x0626 | EDIT | edit-readonly |   | 42,48,34,12 | **SAFE** | Read-only live value: Z position. |
| 1253 | 0x04E5 | STATIC | label | Phi: | 12,81,25,8 | **SAFE** |   |
| 1444 | 0x05A4 | EDIT | edit-readonly |   | 42,78,34,12 | **SAFE** | Read-only live value: Phi position. |
| 1255 | 0x04E7 | STATIC | label | Stress: | 217,21,39,8 | **SAFE** |   |
| 1468 | 0x05BC | EDIT | edit-readonly |   | 258,18,31,12 | **SAFE** | Read-only live value: Stress (MPa/ksi) running result. |
| 1243 | 0x04DB | BUTTON | push | Stop | 122,97,42,14 | **DANGER** | Stop: interrupts the running collection; XrdWin then asks "abort (Yes) / pause (No)". Human decides. |
| 1254 | 0x04E6 | BUTTON | groupbox | Results | 211,7,83,104 | **SAFE** |   |
| 1257 | 0x04E9 | STATIC | label | Shear: | 217,52,39,8 | **SAFE** |   |
| 1523 | 0x05F3 | EDIT | edit-readonly |   | 258,49,31,12 | **SAFE** | Read-only live value: Shear. |
| 1258 | 0x04EA | STATIC | label | Error: | 217,36,39,8 | **SAFE** |   |
| 1469 | 0x05BD | EDIT | edit-readonly |   | 258,33,31,12 | **SAFE** | Read-only live value: Stress error. |
| 1259 | 0x04EB | STATIC | label | Breadth: | 217,81,39,8 | **SAFE** |   |
| 1470 | 0x05BE | EDIT | edit-readonly |   | 258,78,31,12 | **SAFE** | Read-only live value: Breadth. |
| 1260 | 0x04EC | STATIC | label | FWHM: | 217,96,39,8 | **SAFE** |   |
| 1471 | 0x05BF | EDIT | edit-readonly |   | 258,93,31,12 | **SAFE** | Read-only live value: FWHM. |
| 1262 | 0x04EE | STATIC | label-center | Exp. time: | 95,33,48,8 | **SAFE** |   |
| 1263 | 0x04EF | STATIC | label-center | Exp.'s nr: | 147,33,50,8 | **SAFE** |   |
| 1327 | 0x052F | STATIC | label-center-sunken | Static | 102,17,86,12 | **SAFE** | Sunken label: current detector / status text. |
| 1328 | 0x0530 | STATIC | label-center-sunken | Static | 102,44,32,12 | **SAFE** | Sunken label: exposure time. |
| 1329 | 0x0531 | STATIC | label-center-sunken | Static | 156,44,32,12 | **SAFE** | Sunken label: exposure number. |
| 1261 | 0x04ED | BUTTON | groupbox | Detectors | 84,7,123,57 | **SAFE** |   |
| 1235 | 0x04D3 | STATIC | icon | #381 | 91,78,20,20 | **SAFE** | Icon: motor moving. |
| 1236 | 0x04D4 | STATIC | icon | #380 | 91,78,20,20 | **SAFE** | Icon: motor idle. |
| 1239 | 0x04D7 | STATIC | icon | #382 | 180,78,20,20 | **SAFE** | Icon: X-rays / shutter state (#382). |
| 1240 | 0x04D8 | STATIC | icon | #383 | 180,78,20,20 | **SAFE** | Icon: X-rays / shutter state (#383). |
| 1248 | 0x04E0 | BUTTON | groupbox | Motor Positions | 7,7,73,104 | **SAFE** |   |
| 1264 | 0x04F0 | STATIC | label | Error: | 217,66,39,8 | **SAFE** |   |
| 1472 | 0x05C0 | EDIT | edit-readonly |   | 258,63,31,12 | **SAFE** | Read-only live value: Shear error. |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 211,44,83,34 | **SAFE** |   |
| 2314 | 0x090A | STATIC | label | Rho: | 12,95,25,8 | **SAFE** |   |
| 1445 | 0x05A5 | EDIT | edit-readonly |   | 42,93,34,12 | **SAFE** | Read-only live value: Rho position. |

### Dialog 326 -- "Message" -- Message: fitting error Abort / Ignore / Retry

DIALOG template, 5 controls, size 192x54 DLU, lang 1033, 3 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1629 | 0x065D | BUTTON | push | Abort | 21,32,50,14 | **DANGER** | Abort the measurement. Human answers. |
| 1692 | 0x069C | BUTTON | push | Ignore | 72,32,50,14 | **DANGER** | Ignore the fitting error and continue collecting (more X-ray exposures). Human answers. |
| 1448 | 0x05A8 | STATIC | label-center | For this angle is a fitting error | 7,7,149,19 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | icon | #161 | 165,7,21,20 | **SAFE** |   |
| 1693 | 0x069D | BUTTON | default-push | Retry | 122,32,50,14 | **DANGER** | Retry: re-collects this angle (X-rays on again). Human answers. |

### Dialog 546 -- "Warning" -- Warning: XRayEnable is not set (Yes/No)

DIALOG template, 3 controls, size 186x93 DLU, lang 1033, 2 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 6 | 0x0006 | BUTTON | default-push | Yes | 39,65,50,14 | **DANGER** | Yes = continue with X-rays although the X-Ray Enable button is not pressed. NEVER pressed by Claude. |
| 7 | 0x0007 | BUTTON | push | No | 91,65,50,14 | **DANGER** | No = do not continue. Safe outcome, but the prompt itself is an X-ray prompt: the human answers it. |
| 65535 | 0xFFFF | STATIC | label-center | XRayEnable is not set. (Press the button). Do you want to continue with x-rays? | 34,14,112,36 | **SAFE** |   |

### Dialog 112 -- "Collection Constants" -- Collection Constants (Constants > Constants, cmd 32771; property page)

DIALOGEX template, 86 controls, size 330x222 DLU, lang 1033, 2 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1085 | 0x043D | EDIT | edit (hidden) |   | 113,23,22,12 | **CAUTION** |   |
| 1104 | 0x0450 | EDIT | edit-number (hidden) |   | 113,38,22,12 | **CAUTION** |   |
| 1086 | 0x043E | EDIT | edit (hidden) |   | 136,23,22,12 | **CAUTION** |   |
| 1105 | 0x0451 | EDIT | edit-number (hidden) |   | 136,38,22,12 | **CAUTION** |   |
| 1087 | 0x043F | EDIT | edit (hidden) |   | 160,23,22,12 | **CAUTION** |   |
| 1106 | 0x0452 | EDIT | edit-number (hidden) |   | 160,38,22,12 | **CAUTION** |   |
| 1088 | 0x0440 | EDIT | edit (hidden) |   | 184,23,22,12 | **CAUTION** |   |
| 1107 | 0x0453 | EDIT | edit-number (hidden) |   | 184,38,22,12 | **CAUTION** |   |
| 1089 | 0x0441 | EDIT | edit (hidden) |   | 207,23,22,12 | **CAUTION** |   |
| 1108 | 0x0454 | EDIT | edit-number (hidden) |   | 207,38,22,12 | **CAUTION** |   |
| 1090 | 0x0442 | EDIT | edit (hidden) |   | 230,23,22,12 | **CAUTION** |   |
| 1109 | 0x0455 | EDIT | edit-number (hidden) |   | 230,38,22,12 | **CAUTION** |   |
| 1091 | 0x0443 | EDIT | edit (hidden) |   | 254,23,22,12 | **CAUTION** |   |
| 1110 | 0x0456 | EDIT | edit-number (hidden) |   | 254,38,22,12 | **CAUTION** |   |
| 1092 | 0x0444 | EDIT | edit (hidden) |   | 278,23,22,12 | **CAUTION** |   |
| 1111 | 0x0457 | EDIT | edit-number (hidden) |   | 278,38,22,12 | **CAUTION** |   |
| 1909 | 0x0775 | BUTTON | check | Lock | 215,55,38,8 | **CAUTION** | Lock exposure settings. |
| 1093 | 0x0445 | EDIT | edit |   | 68,81,25,12 | **CAUTION** | Beta angle (deg) used for single exposures. |
| 1094 | 0x0446 | EDIT | edit |   | 195,81,25,12 | **CAUTION** | Phi angle (deg). |
| 1095 | 0x0447 | BUTTON | check | Beta Angle: | 25,114,62,10 | **CAUTION** | Oscillation on Beta (OscBetaCheck=1 today). |
| 1099 | 0x044B | EDIT | edit |   | 98,112,22,12 | **CAUTION** | Beta oscillation amplitude (OscBeta=3.000 deg today). |
| 1097 | 0x0449 | BUTTON | check | X Axis: | 26,129,61,10 | **CAUTION** |   |
| 1101 | 0x044D | EDIT | edit |   | 98,127,22,12 | **CAUTION** |   |
| 1096 | 0x0448 | BUTTON | check | Phi Angle: | 230,115,41,10 | **CAUTION** |   |
| 1100 | 0x044C | EDIT | edit |   | 278,112,22,12 | **CAUTION** |   |
| 1098 | 0x044A | BUTTON | check | Y Axis: | 229,129,42,10 | **CAUTION** |   |
| 1018 | 0x03FA | EDIT | edit |   | 278,126,22,12 | **CAUTION** |   |
| 1445 | 0x05A5 | EDIT | edit |   | 90,160,53,12 | **CAUTION** | Aperture text (e.g. "2 mm"); informational, written to the file. |
| 1960 | 0x07A8 | EDIT | edit |   | 43,196,40,12 | **CAUTION** |   |
| 1961 | 0x07A9 | EDIT | edit |   | 119,196,40,12 | **CAUTION** |   |
| 1956 | 0x07A4 | EDIT | edit |   | 197,196,40,12 | **CAUTION** |   |
| 1957 | 0x07A5 | EDIT | edit |   | 273,196,40,12 | **CAUTION** |   |
| 1248 | 0x04E0 | STATIC | label | Detectors: | 65,14,45,8 | **SAFE** |   |
| 1249 | 0x04E1 | STATIC | label | Exposure Time [sec]: | 15,27,91,8 | **SAFE** |   |
| 1250 | 0x04E2 | STATIC | label | Number of Exposures: | 15,39,92,8 | **SAFE** |   |
| 1251 | 0x04E3 | STATIC | label (hidden) | Number of Separate Collection Parameters: | 7,98,145,8 | **SAFE** |   |
| 1003 | 0x03EB | BUTTON | groupbox | Exposures | 7,7,316,60 | **SAFE** |   |
| 1252 | 0x04E4 | BUTTON | groupbox | Angles | 7,67,316,37 | **SAFE** |   |
| 1630 | 0x065E | STATIC | label-center (hidden) | 1 | 154,98,18,9 | **SAFE** |   |
| 1253 | 0x04E5 | STATIC | label-right | Beta Angle: | 12,84,53,8 | **SAFE** |   |
| 1254 | 0x04E6 | STATIC | label | deg. | 96,84,21,8 | **SAFE** |   |
| 1255 | 0x04E7 | STATIC | label-right | Phi Angle: | 150,84,42,8 | **SAFE** |   |
| 1257 | 0x04E9 | STATIC | label | deg. | 222,84,21,8 | **SAFE** |   |
| 1231 | 0x04CF | BUTTON | groupbox | Oscillation | 7,104,316,53 | **SAFE** |   |
| 1258 | 0x04EA | STATIC | label | deg. | 121,115,17,8 | **SAFE** |   |
| 1259 | 0x04EB | STATIC | label | mm | 121,129,29,8 | **SAFE** |   |
| 1260 | 0x04EC | STATIC | label | deg. | 300,115,14,8 | **SAFE** |   |
| 1261 | 0x04ED | STATIC | label | mm | 300,129,13,8 | **SAFE** |   |
| 1023 | 0x03FF | STATIC | label-center (hidden) | 1 | 121,14,8,8 | **SAFE** |   |
| 1024 | 0x0400 | STATIC | label-center (hidden) | 2 | 144,14,8,8 | **SAFE** |   |
| 1025 | 0x0401 | STATIC | label-center (hidden) | 3 | 167,14,8,8 | **SAFE** |   |
| 1026 | 0x0402 | STATIC | label-center (hidden) | 4 | 190,14,8,8 | **SAFE** |   |
| 1027 | 0x0403 | STATIC | label-center (hidden) | 5 | 213,14,8,8 | **SAFE** |   |
| 1028 | 0x0404 | STATIC | label-center (hidden) | 6 | 236,14,8,8 | **SAFE** |   |
| 1029 | 0x0405 | STATIC | label-center (hidden) | 7 | 259,14,8,8 | **SAFE** |   |
| 1030 | 0x0406 | STATIC | label-center (hidden) | 8 | 282,14,8,8 | **SAFE** |   |
| 1266 | 0x04F2 | STATIC | label (hidden) |   | 305,28,8,8 | **SAFE** |   |
| 1270 | 0x04F6 | STATIC | label | Aperture | 13,162,69,11 | **SAFE** |   |
| 1197 | 0x04AD | BUTTON | push | Motor Limits | 245,72,72,14 | **DANGER** | Motor Limits: opens the software motor-limit editor; wrong limits allow collisions. |
| 1862 | 0x0746 | STATIC | icon | #388 | 142,157,20,20 | **SAFE** |   |
| 1863 | 0x0747 | STATIC | icon | #388 | 114,78,20,20 | **SAFE** |   |
| 1953 | 0x07A1 | BUTTON | groupbox | Austenite | 7,174,316,41 | **SAFE** |   |
| 1954 | 0x07A2 | STATIC | label | RM1: | 175,200,18,8 | **SAFE** |   |
| 1955 | 0x07A3 | STATIC | label | RM2: | 252,200,18,8 | **SAFE** |   |
| 1958 | 0x07A6 | STATIC | label | RA1: | 22,200,17,8 | **SAFE** |   |
| 1959 | 0x07A7 | STATIC | label | RA2: | 98,200,17,8 | **SAFE** |   |
| 1655 | 0x0677 | BUTTON | check | Stress  Austenite | 38,184,166,10 | **CAUTION** |   |
| 1102 | 0x044E | BUTTON | check | Rho: | 26,144,61,10 | **CAUTION** |   |
| 1103 | 0x044F | EDIT | edit |   | 98,141,22,12 | **CAUTION** |   |
| 1262 | 0x04EE | STATIC | label | deg | 121,144,16,8 | **SAFE** |   |
| 2392 | 0x0958 | BUTTON | push | ? | 135,81,14,14 | **SAFE** | Help/info button. |
| 1198 | 0x04AE | BUTTON | push | Motor Home Pos | 245,87,72,14 | **DANGER** | Motor Home Pos: edits home positions used by Initialize/Home. |
| 1112 | 0x0458 | EDIT | edit-number (hidden) |   | 113,52,22,12 | **CAUTION** |   |
| 1113 | 0x0459 | EDIT | edit-number (hidden) |   | 136,52,22,12 | **CAUTION** |   |
| 1114 | 0x045A | EDIT | edit-number (hidden) |   | 160,52,22,12 | **CAUTION** |   |
| 1115 | 0x045B | EDIT | edit-number (hidden) |   | 184,52,22,12 | **CAUTION** |   |
| 1256 | 0x04E8 | STATIC | label | Number of Exposures Gain: | 15,52,97,8 | **SAFE** |   |
| 1116 | 0x045C | BUTTON | check | R | 229,144,42,10 | **CAUTION** |   |
| 1117 | 0x045D | EDIT | edit |   | 278,140,22,12 | **CAUTION** |   |
| 1263 | 0x04EF | STATIC | label | deg | 300,143,14,8 | **SAFE** |   |
| 1118 | 0x045E | EDIT | edit |   | 140,112,22,12 | **CAUTION** |   |
| 1264 | 0x04F0 | STATIC | label | deg. | 163,115,17,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label | Quick | 256,55,20,8 | **SAFE** |   |
| 1119 | 0x045F | EDIT | edit-number |   | 277,51,22,12 | **CAUTION** | Quick gain exposures. |
| 1120 | 0x0460 | BUTTON | check | Z | 153,143,26,10 | **CAUTION** |   |
| 1121 | 0x0461 | EDIT | edit |   | 188,140,22,12 | **CAUTION** |   |

### Dialog 113 -- "Fitting Constants" -- Fitting Constants (property page)

DIALOGEX template, 79 controls, size 330x222 DLU, lang 1033, 0 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1122 | 0x0462 | EDIT | edit |   | 70,16,28,12 | **CAUTION** |   |
| 1123 | 0x0463 | msctls_updown32 | spin | Spin6 | 98,16,11,14 | **CAUTION** |   |
| 1060 | 0x0424 | BUTTON | radio | Parabola | 13,29,53,10 | **CAUTION** |   |
| 1061 | 0x0425 | BUTTON | radio | Gaussian | 13,44,53,10 | **CAUTION** |   |
| 1062 | 0x0426 | BUTTON | radio | Cauchy | 13,59,53,10 | **CAUTION** |   |
| 1063 | 0x0427 | BUTTON | radio | Pearson VII | 13,74,53,10 | **CAUTION** |   |
| 1111 | 0x0457 | EDIT | edit |   | 71,72,22,12 | **CAUTION** |   |
| 1064 | 0x0428 | BUTTON | radio | Mid Chord | 13,89,53,10 | **CAUTION** |   |
| 1112 | 0x0458 | EDIT | edit |   | 71,87,22,12 | **CAUTION** |   |
| 1065 | 0x0429 | BUTTON | radio | Centroid | 13,104,53,10 | **CAUTION** |   |
| 1066 | 0x042A | BUTTON | radio | Centered Centroid | 13,119,74,9 | **CAUTION** |   |
| 1590 | 0x0636 | EDIT | edit |   | 91,116,17,12 | **CAUTION** |   |
| 1067 | 0x042B | BUTTON | radio (disabled) | Modified Lorentzian | 13,133,97,9 | **CAUTION** |   |
| 1113 | 0x0459 | BUTTON | check | TwoPeaks Model | 13,160,87,8 | **CAUTION** |   |
| 1114 | 0x045A | BUTTON | check | Display Ka1,Ka2 | 13,168,87,8 | **CAUTION** |   |
| 1108 | 0x0454 | BUTTON | check | Ka Strip | 13,177,79,8 | **CAUTION** |   |
| 2460 | 0x099C | BUTTON | check | Average channels | 13,186,73,8 | **CAUTION** |   |
| 2462 | 0x099E | EDIT | edit |   | 96,184,14,12 | **CAUTION** |   |
| 2413 | 0x096D | BUTTON | check | 1..5 Gauss | 13,195,51,8 | **CAUTION** |   |
| 1051 | 0x041B | BUTTON | radio | Absolute Peak | 133,24,70,10 | **CAUTION** |   |
| 1052 | 0x041C | BUTTON | radio | Cross Corelation | 133,37,70,10 | **CAUTION** |   |
| 1053 | 0x041D | BUTTON | radio (hidden) | Difference | 133,50,70,10 | **CAUTION** |   |
| 1036 | 0x040C | BUTTON | radio | P/G | 138,84,70,10 | **CAUTION** |   |
| 1037 | 0x040D | BUTTON | radio | P-G | 138,95,70,10 | **CAUTION** |   |
| 1038 | 0x040E | BUTTON | radio | No Correction | 138,106,70,10 | **CAUTION** |   |
| 1054 | 0x041E | BUTTON | radio | P/G(s)* | 138,117,70,10 | **CAUTION** |   |
| 1039 | 0x040F | BUTTON | radio | No LPA | 138,146,70,10 | **CAUTION** |   |
| 1040 | 0x0410 | BUTTON | radio (hidden) | LPA 1 | 123,151,70,10 | **CAUTION** |   |
| 1041 | 0x0411 | BUTTON | radio | LPA 2 | 138,158,70,10 | **CAUTION** |   |
| 1651 | 0x0673 | BUTTON | check | Auto Remove Bad Points | 128,178,78,16 | **CAUTION** |   |
| 1652 | 0x0674 | EDIT | edit |   | 185,194,22,12 | **CAUTION** |   |
| 1643 | 0x066B | BUTTON | check (hidden) | Peaks Separation | 119,202,72,10 | **CAUTION** |   |
| 3000 | 0x0BB8 | EDIT | edit (hidden) |   | 242,19,27,12 | **CAUTION** |   |
| 3001 | 0x0BB9 | EDIT | edit (hidden) |   | 293,19,27,12 | **CAUTION** |   |
| 3002 | 0x0BBA | EDIT | edit (hidden) |   | 242,32,27,12 | **CAUTION** |   |
| 3003 | 0x0BBB | EDIT | edit (hidden) |   | 293,32,27,12 | **CAUTION** |   |
| 3004 | 0x0BBC | EDIT | edit (hidden) |   | 242,44,27,12 | **CAUTION** |   |
| 3005 | 0x0BBD | EDIT | edit (hidden) |   | 293,44,27,12 | **CAUTION** |   |
| 3006 | 0x0BBE | EDIT | edit (hidden) |   | 242,57,27,12 | **CAUTION** |   |
| 3007 | 0x0BBF | EDIT | edit (hidden) |   | 293,57,27,12 | **CAUTION** |   |
| 1023 | 0x03FF | BUTTON | push | Load New | 274,81,44,23 | **CAUTION** | Load New: file dialog (powder/reference file). |
| 1109 | 0x0455 | BUTTON | check | Background Substract | 229,173,87,10 | **CAUTION** |   |
| 1701 | 0x06A5 | BUTTON | radio | Linear | 222,183,47,10 | **CAUTION** |   |
| 1702 | 0x06A6 | BUTTON | radio | Parabola | 273,183,47,10 | **CAUTION** |   |
| 1110 | 0x0456 | BUTTON | check | Ignore error warnings | 229,196,87,16 | **CAUTION** | "Ignore error warnings": when checked the Abort/Ignore/Retry box (326) is suppressed and collection continues automatically. Leave OFF so the human keeps control. |
| 1254 | 0x04E6 | BUTTON | groupbox | LPA Correction | 122,134,88,36 | **SAFE** |   |
| 1248 | 0x04E0 | BUTTON | groupbox | Peak Location | 7,7,107,140 | **SAFE** |   |
| 1249 | 0x04E1 | STATIC | label-right | % used: | 27,19,42,8 | **SAFE** |   |
| 1252 | 0x04E4 | BUTTON | groupbox | Peak Shift Method | 122,7,87,61 | **SAFE** |   |
| 1253 | 0x04E5 | BUTTON | groupbox | Profile Correction | 122,71,88,59 | **SAFE** |   |
| 1255 | 0x04E7 | BUTTON | groupbox | Average Peak Pos. | 217,7,106,100 | **SAFE** |   |
| 1050 | 0x041A | BUTTON | groupbox | Other | 217,163,106,52 | **SAFE** |   |
| 2475 | 0x09AB | STATIC | label (hidden) | Det 1 | 221,21,18,8 | **SAFE** |   |
| 2476 | 0x09AC | STATIC | label (hidden) | Det 2 | 272,21,18,8 | **SAFE** |   |
| 2477 | 0x09AD | STATIC | label (hidden) | Det 3 | 221,34,18,8 | **SAFE** |   |
| 2478 | 0x09AE | STATIC | label (hidden) | Det 4 | 272,34,18,8 | **SAFE** |   |
| 2479 | 0x09AF | STATIC | label (hidden) | Det 5 | 221,46,18,8 | **SAFE** |   |
| 2480 | 0x09B0 | STATIC | label (hidden) | Det 6 | 272,46,18,8 | **SAFE** |   |
| 2481 | 0x09B1 | STATIC | label (hidden) | Det 7 | 221,59,18,8 | **SAFE** |   |
| 2482 | 0x09B2 | STATIC | label (hidden) | Det 8 | 272,59,18,8 | **SAFE** |   |
| 1642 | 0x066A | BUTTON | groupbox | Two Peaks | 7,148,107,67 | **SAFE** |   |
| 1644 | 0x066C | BUTTON | groupbox (hidden) | Two Phases | 111,194,97,21 | **SAFE** |   |
| 1654 | 0x0676 | BUTTON | groupbox |   | 122,170,88,45 | **SAFE** |   |
| 1653 | 0x0675 | STATIC | label | Threshold: | 128,197,52,12 | **SAFE** |   |
| 1724 | 0x06BC | BUTTON | check (hidden) | Shift Up | 167,99,41,10 | **CAUTION** |   |
| 1733 | 0x06C5 | BUTTON | check |   | 98,76,9,8 | **CAUTION** |   |
| 1271 | 0x04F7 | BUTTON | groupbox | Powder Correction | 217,107,106,55 | **SAFE** |   |
| 1737 | 0x06C9 | BUTTON | check | Use Powder Correction | 220,116,96,13 | **CAUTION** |   |
| 1738 | 0x06CA | EDIT | edit-readonly |   | 250,145,67,14 | **SAFE** | Read-only file name. |
| 1623 | 0x0657 | BUTTON | push | Reset | 270,129,42,14 | **CAUTION** | Reset powder correction. |
| 1272 | 0x04F8 | STATIC | label | File: | 223,146,23,13 | **SAFE** |   |
| 1739 | 0x06CB | BUTTON | push | Load | 227,129,42,14 | **CAUTION** | Load powder-correction file (file dialog). |
| 1703 | 0x06A7 | BUTTON | radio | Automatic | 222,71,54,10 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio | Manual | 276,71,39,10 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio | Curve fit E | 222,82,49,10 | **CAUTION** |   |
| 1706 | 0x06AA | BUTTON | radio | Curve fit M | 222,92,50,10 | **CAUTION** |   |
| 2713 | 0x0A99 | BUTTON | check | 2Peaks Sm. | 13,204,49,8 | **CAUTION** |   |
| 2714 | 0x0A9A | EDIT | edit |   | 63,202,24,12 | **CAUTION** |   |
| 1650 | 0x0672 | EDIT | edit |   | 89,202,22,12 | **CAUTION** |   |

### Dialog 114 -- "Material Chart" -- Material Chart (property page)

DIALOGEX template, 65 controls, size 330x226 DLU, lang 1033, 0 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1701 | 0x06A5 | BUTTON | radio (hidden) | Detector 1 | 10,16,49,10 | **CAUTION** |   |
| 1702 | 0x06A6 | BUTTON | radio (hidden) | Detector 2 | 61,16,49,10 | **CAUTION** |   |
| 1703 | 0x06A7 | BUTTON | radio (hidden) | Detector 3 | 112,16,49,10 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio (hidden) | Detector 4 | 163,16,49,10 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio (hidden) | Detector 5 | 10,27,49,10 | **CAUTION** |   |
| 1706 | 0x06AA | BUTTON | radio (hidden) | Detector 6 | 61,27,49,10 | **CAUTION** |   |
| 1707 | 0x06AB | BUTTON | radio (hidden) | Detector 7 | 112,27,49,10 | **CAUTION** |   |
| 1708 | 0x06AC | BUTTON | radio (hidden) | Detector 8 | 163,27,49,10 | **CAUTION** |   |
| 1043 | 0x0413 | BUTTON | radio | ksi | 267,19,51,10 | **CAUTION** |   |
| 1154 | 0x0482 | BUTTON | radio | MPa | 267,31,51,10 | **CAUTION** |   |
| 1149 | 0x047D | COMBOBOX | combo-droplist |   | 73,57,60,98 | **CAUTION** | Radiation type selector (e.g. Mn_Ka, lambda 2.10314 A). |
| 1079 | 0x0437 | EDIT | edit-readonly |   | 207,57,37,12 | **SAFE** | Read-only wavelength (A). |
| 1446 | 0x05A6 | EDIT | edit |   | 73,76,94,14 | **CAUTION** |   |
| 1155 | 0x0483 | COMBOBOX | combo-droplist |   | 66,108,114,116 | **CAUTION** | Material selector (e.g. "NICKEL (Mn_Ka)"). |
| 1126 | 0x0466 | EDIT | edit-readonly |   | 66,127,179,12 | **SAFE** | Read-only material name. |
| 1152 | 0x0480 | EDIT | edit-readonly |   | 66,141,40,12 | **SAFE** | Read-only symmetry (FCC). |
| 1081 | 0x0439 | EDIT | edit-readonly |   | 66,155,40,12 | **SAFE** | Read-only hkl plane (311). |
| 1080 | 0x0438 | EDIT | edit |   | 199,156,40,12 | **CAUTION** |   |
| 1082 | 0x043A | EDIT | edit |   | 66,187,40,12 | **CAUTION** |   |
| 1083 | 0x043B | EDIT | edit |   | 66,203,40,12 | **CAUTION** |   |
| 1127 | 0x0467 | BUTTON | push | Add Radiation Type | 257,51,62,22 | **CAUTION** | Adds a radiation type. |
| 1128 | 0x0468 | BUTTON | push | Del Radiation Type | 257,74,62,22 | **CAUTION** | Deletes a radiation type from the material database (destructive to data, no hardware). |
| 1000 | 0x03E8 | BUTTON | push | Add Material | 257,121,62,11 | **CAUTION** | Adds a material. |
| 1591 | 0x0637 | BUTTON | push | Del Material | 257,133,62,11 | **CAUTION** | Deletes a material from the database (destructive to data, no hardware). |
| 1248 | 0x04E0 | BUTTON | groupbox | Detectors | 7,7,242,42 | **SAFE** |   |
| 1250 | 0x04E2 | BUTTON | groupbox | Radiation | 7,49,242,46 | **SAFE** |   |
| 1251 | 0x04E3 | STATIC | label-right | Radiation Type: | 12,59,55,8 | **SAFE** |   |
| 1252 | 0x04E4 | STATIC | label-right | Wavelength: | 134,59,69,8 | **SAFE** |   |
| 1253 | 0x04E5 | BUTTON | groupbox | Material | 7,96,242,123 | **SAFE** |   |
| 1255 | 0x04E7 | STATIC | label | Material: | 13,130,52,8 | **SAFE** |   |
| 1260 | 0x04EC | STATIC | label | Bragg Angle: | 129,158,66,8 | **SAFE** |   |
| 1258 | 0x04EA | STATIC | label | hkl Plane: | 13,158,52,8 | **SAFE** |   |
| 1259 | 0x04EB | STATIC | label | X-Ray Elastic Constants: | 13,176,93,8 | **SAFE** |   |
| 1261 | 0x04ED | STATIC | label-right | 1/2 S2: | 26,191,33,8 | **SAFE** |   |
| 1262 | 0x04EE | STATIC | label-right | S1: | 26,206,34,8 | **SAFE** |   |
| 1254 | 0x04E6 | STATIC | label | Materials List: | 13,111,52,8 | **SAFE** |   |
| 1249 | 0x04E1 | BUTTON | groupbox | Units | 252,7,72,42 | **SAFE** |   |
| 1270 | 0x04F6 | BUTTON | groupbox | D-Spacing [d0] | 252,179,72,40 | **SAFE** |   |
| 1084 | 0x043C | STATIC | label-center | Static | 263,199,52,11 | **SAFE** | Computed d0 label. |
| 1263 | 0x04EF | STATIC | label | x10 | 106,190,12,8 | **SAFE** |   |
| 1264 | 0x04F0 | STATIC | label | -6 | 118,186,8,8 | **SAFE** |   |
| 1265 | 0x04F1 | STATIC | label | x10 | 106,206,12,8 | **SAFE** |   |
| 1266 | 0x04F2 | STATIC | label | -6 | 118,202,8,8 | **SAFE** |   |
| 1257 | 0x04E9 | STATIC | label | Symmetry: | 13,145,52,8 | **SAFE** |   |
| 1271 | 0x04F7 | STATIC | label-right | Filter: | 12,79,55,10 | **SAFE** |   |
| 1863 | 0x0747 | STATIC | icon | #388 | 166,73,20,20 | **SAFE** |   |
| 1869 | 0x074D | EDIT | edit |   | 199,187,43,12 | **CAUTION** |   |
| 2105 | 0x0839 | STATIC | label-right | (E/(1+v)) | 158,191,29,8 | **SAFE** |   |
| 1870 | 0x074E | EDIT | edit |   | 199,203,43,12 | **CAUTION** |   |
| 2106 | 0x083A | STATIC | label-right | (E/v) | 164,206,21,8 | **SAFE** |   |
| 2107 | 0x083B | STATIC | label | <==> | 138,191,17,8 | **SAFE** |   |
| 2108 | 0x083C | STATIC | label | <==> | 138,206,17,8 | **SAFE** |   |
| 2109 | 0x083D | STATIC | label | eff | 187,196,9,8 | **SAFE** |   |
| 2110 | 0x083E | STATIC | label | eff | 187,208,9,8 | **SAFE** |   |
| 2210 | 0x08A2 | BUTTON | push | Text Out | 251,155,37,11 | **CAUTION** |   |
| 2211 | 0x08A3 | BUTTON | push | Text In | 289,155,30,11 | **CAUTION** |   |
| 2212 | 0x08A4 | BUTTON | push | Export | 251,144,37,11 | **CAUTION** |   |
| 2213 | 0x08A5 | BUTTON | push | Import | 289,144,30,11 | **CAUTION** |   |
| 2214 | 0x08A6 | BUTTON | push | XML Out | 251,167,37,11 | **CAUTION** |   |
| 2215 | 0x08A7 | BUTTON | push | XML In | 290,167,30,11 | **CAUTION** |   |
| 1909 | 0x0775 | BUTTON | check | Lock | 113,38,132,8 | **CAUTION** |   |
| 2648 | 0x0A58 | BUTTON | push | K calc | 132,173,28,14 | **CAUTION** |   |
| 2659 | 0x0A63 | BUTTON | check (hidden) | Link Rad.-Mat. | 184,106,63,8 | **CAUTION** |   |
| 2216 | 0x08A8 | BUTTON | push | Database | 257,104,62,16 | **CAUTION** | Opens the material Database dialog. |
| 2725 | 0x0AA5 | BUTTON | check (hidden) | Short List | 183,115,61,8 | **CAUTION** |   |

### Dialog 111 -- "Beta Angles" -- Beta Angles (property page)

DIALOGEX template, 110 controls, size 330x215 DLU, lang 1033, 1 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1701 | 0x06A5 | BUTTON | radio | Automatic | 262,21,54,8 | **CAUTION** |   |
| 1702 | 0x06A6 | BUTTON | radio | Manual | 262,30,39,8 | **CAUTION** |   |
| 1703 | 0x06A7 | BUTTON | radio | PF incr. | 262,38,51,8 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio | PF steps | 262,47,51,8 | **CAUTION** |   |
| 1050 | 0x041A | EDIT | edit-number |   | 111,32,26,12 | **CAUTION** | Number of beta angles (NrBetaAngles=11 in registry; file used 9). |
| 1051 | 0x041B | EDIT | edit-number |   | 221,32,26,12 | **CAUTION** | Maximum beta (30 deg). |
| 1130 | 0x046A | EDIT | edit |   | 29,71,30,12 | **CAUTION** |   |
| 1131 | 0x046B | EDIT | edit |   | 76,71,30,12 | **CAUTION** |   |
| 1132 | 0x046C | EDIT | edit |   | 123,71,30,12 | **CAUTION** |   |
| 1133 | 0x046D | EDIT | edit |   | 170,71,30,12 | **CAUTION** |   |
| 1134 | 0x046E | EDIT | edit |   | 217,71,30,12 | **CAUTION** |   |
| 1135 | 0x046F | EDIT | edit |   | 29,85,30,12 | **CAUTION** |   |
| 1136 | 0x0470 | EDIT | edit |   | 76,85,30,12 | **CAUTION** |   |
| 1137 | 0x0471 | EDIT | edit |   | 123,85,30,12 | **CAUTION** |   |
| 1138 | 0x0472 | EDIT | edit |   | 170,85,30,12 | **CAUTION** |   |
| 1139 | 0x0473 | EDIT | edit |   | 217,85,30,12 | **CAUTION** |   |
| 1140 | 0x0474 | EDIT | edit |   | 29,99,30,12 | **CAUTION** |   |
| 1141 | 0x0475 | EDIT | edit |   | 76,99,30,12 | **CAUTION** |   |
| 1142 | 0x0476 | EDIT | edit |   | 123,99,30,12 | **CAUTION** |   |
| 1143 | 0x0477 | EDIT | edit |   | 170,99,30,12 | **CAUTION** |   |
| 1144 | 0x0478 | EDIT | edit |   | 217,99,30,12 | **CAUTION** |   |
| 1145 | 0x0479 | EDIT | edit |   | 29,113,30,12 | **CAUTION** |   |
| 1146 | 0x047A | EDIT | edit |   | 76,113,30,12 | **CAUTION** |   |
| 1147 | 0x047B | EDIT | edit |   | 123,113,30,12 | **CAUTION** |   |
| 1148 | 0x047C | EDIT | edit |   | 170,113,30,12 | **CAUTION** |   |
| 1149 | 0x047D | EDIT | edit |   | 217,113,30,12 | **CAUTION** |   |
| 1150 | 0x047E | EDIT | edit |   | 29,127,30,12 | **CAUTION** |   |
| 1151 | 0x047F | EDIT | edit |   | 76,127,30,12 | **CAUTION** |   |
| 1152 | 0x0480 | EDIT | edit |   | 123,127,30,12 | **CAUTION** |   |
| 1153 | 0x0481 | EDIT | edit |   | 170,127,30,12 | **CAUTION** |   |
| 1154 | 0x0482 | EDIT | edit |   | 217,127,30,12 | **CAUTION** |   |
| 1155 | 0x0483 | EDIT | edit |   | 29,141,30,12 | **CAUTION** |   |
| 1156 | 0x0484 | EDIT | edit |   | 76,141,30,12 | **CAUTION** |   |
| 1157 | 0x0485 | EDIT | edit |   | 123,141,30,12 | **CAUTION** |   |
| 1158 | 0x0486 | EDIT | edit |   | 170,141,30,12 | **CAUTION** |   |
| 1159 | 0x0487 | EDIT | edit |   | 217,141,30,12 | **CAUTION** |   |
| 1045 | 0x0415 | EDIT | edit-number |   | 270,183,26,12 | **CAUTION** | Number of phi angles (1). |
| 1035 | 0x040B | EDIT | edit |   | 29,174,30,12 | **CAUTION** |   |
| 1036 | 0x040C | EDIT | edit |   | 76,174,30,12 | **CAUTION** |   |
| 1037 | 0x040D | EDIT | edit |   | 123,174,30,12 | **CAUTION** |   |
| 1038 | 0x040E | EDIT | edit |   | 170,174,30,12 | **CAUTION** |   |
| 1039 | 0x040F | EDIT | edit |   | 217,174,30,12 | **CAUTION** |   |
| 1040 | 0x0410 | EDIT | edit |   | 29,188,30,12 | **CAUTION** |   |
| 1041 | 0x0411 | EDIT | edit |   | 76,188,30,12 | **CAUTION** |   |
| 1042 | 0x0412 | EDIT | edit |   | 123,188,30,12 | **CAUTION** |   |
| 1043 | 0x0413 | EDIT | edit |   | 170,188,30,12 | **CAUTION** |   |
| 1044 | 0x0414 | EDIT | edit |   | 217,188,30,12 | **CAUTION** |   |
| 1611 | 0x064B | BUTTON | check (hidden) | Chi Method | 262,159,52,8 | **CAUTION** |   |
| 1352 | 0x0548 | BUTTON | check | Multi Gain | 262,133,57,8 | **CAUTION** |   |
| 1635 | 0x0663 | BUTTON | check | Homing After Collection | 262,142,55,16 | **CAUTION** | Homing After Collection: motion at the end of each collection (setting). |
| 1047 | 0x0417 | BUTTON | push | Reverse | 265,58,50,12 | **CAUTION** | Reverse the order of the beta list. |
| 1250 | 0x04E2 | STATIC | label | Number of Beta Angels: | 21,34,87,8 | **SAFE** |   |
| 1251 | 0x04E3 | STATIC | label-right | Maximum Beta: | 145,34,73,8 | **SAFE** |   |
| 1249 | 0x04E1 | BUTTON | groupbox | Initial Data | 13,16,243,41 | **SAFE** |   |
| 1252 | 0x04E4 | BUTTON | groupbox | Beta Angle Results | 13,57,243,101 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 1. | 17,73,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 2. | 64,73,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 3. | 111,73,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 4. | 158,73,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 5. | 205,73,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 6. | 17,87,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 7. | 64,87,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 8. | 111,87,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 9. | 158,87,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 10. | 203,87,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 11. | 15,101,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 12. | 62,101,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 13. | 109,101,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 14. | 156,101,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 15. | 203,101,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 16. | 15,115,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 17. | 62,115,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 18. | 109,115,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 19. | 156,115,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 20. | 203,115,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 21. | 15,129,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 22. | 62,129,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 23. | 109,129,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 24. | 156,129,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 25. | 203,129,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 26. | 15,143,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 27. | 62,143,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 28. | 109,143,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 29. | 156,143,10,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 30. | 203,143,10,8 | **SAFE** |   |
| 1253 | 0x04E5 | BUTTON | groupbox | Phi Angles | 7,163,316,48 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 1. | 17,177,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 2. | 64,177,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 3. | 111,177,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 4. | 158,177,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 5. | 205,177,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 6. | 17,191,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 7. | 64,191,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 8. | 111,191,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 9. | 158,191,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label-right | 10. | 203,191,10,8 | **SAFE** |   |
| 1254 | 0x04E6 | BUTTON | groupbox | Nr of Phi Angles | 252,172,65,33 | **SAFE** |   |
| 1248 | 0x04E0 | BUTTON | groupbox | Beta Angles | 7,7,316,155 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 259,16,59,41 | **SAFE** |   |
| 1017 | 0x03F9 | BUTTON | push (hidden) | Fix Bad Osc | 265,142,50,14 | **DANGER** | Fix Bad Osc (hidden): writes a new oscillation program to the motor controller. |
| 2101 | 0x0835 | BUTTON | check (hidden) | Sin2Psi Equal Increments | 265,58,62,16 | **CAUTION** |   |
| 1052 | 0x041C | EDIT | edit-number |   | 111,32,26,12 | **CAUTION** |   |
| 1255 | 0x04E7 | STATIC | label | Increment: | 21,34,85,8 | **SAFE** |   |
| 2470 | 0x09A6 | BUTTON | push (hidden) | Load Saved | 265,81,50,12 | **CAUTION** |   |
| 2471 | 0x09A7 | BUTTON | push (hidden) | Save | 265,70,50,11 | **CAUTION** |   |
| 1256 | 0x04E8 | STATIC | label | No of steps: | 21,33,87,8 | **SAFE** |   |
| 1053 | 0x041D | EDIT | edit-number |   | 111,32,26,12 | **CAUTION** |   |
| 2662 | 0x0A66 | BUTTON | check | HomeBeta after each phi | 262,104,58,19 | **CAUTION** | HomeBeta after each phi: homing motion during multi-phi runs (setting). |
| 2681 | 0x0A79 | BUTTON | check | Phi warning | 262,123,53,8 | **CAUTION** |   |
| 2663 | 0x0A67 | BUTTON | check | HomeBeta pt | 262,95,58,9 | **CAUTION** | HomeBeta pt (setting affecting motion). |

### Dialog 163 -- "MoveMotors" -- MoveMotors (Initialization > Move Motors, cmd 32791, toolbar "Move")

DIALOGEX template, 19 controls, size 201x130 DLU, lang 1033, 9 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1001 | 0x03E9 | EDIT | edit |   | 13,71,53,14 | **CAUTION** | Target value (deg or mm) for Move. Typing does not move anything until Move is pressed. |
| 3 | 0x0003 | BUTTON | default-push | Move | 139,75,55,14 | **DANGER** | Move: moves the selected axis to the typed value. IDABORT id 3 is reused as the Move button. |
| 2 | 0x0002 | BUTTON | push | Cancel | 139,89,55,14 | **SAFE** |   |
| 1228 | 0x04CC | COMBOBOX | combo-droplist (hidden) |   | 16,20,54,75 | **CAUTION** | Head selector (hidden). |
| 1229 | 0x04CD | COMBOBOX | combo-droplist (hidden) |   | 87,20,39,75 | **CAUTION** | Axis selector variant (hidden). |
| 1230 | 0x04CE | COMBOBOX | combo-droplist |   | 38,20,66,75 | **CAUTION** | Axis selector (Beta, Z, X ... per string table 33080-33095). |
| 1248 | 0x04E0 | BUTTON | groupbox | HeadAxis | 7,7,127,35 | **SAFE** |   |
| 1249 | 0x04E1 | BUTTON | groupbox | Value: | 7,53,127,50 | **SAFE** |   |
| 1233 | 0x04D1 | BUTTON | push | Move to "0" | 139,34,55,25 | **DANGER** | Move to "0": moves the selected axis to zero. |
| 1235 | 0x04D3 | STATIC | icon | #380 | 89,66,20,20 | **SAFE** | Status icon (moving). |
| 1236 | 0x04D4 | STATIC | icon | #381 | 89,66,20,20 | **SAFE** | Status icon (idle). |
| 1287 | 0x0507 | BUTTON | push | Stop | 139,60,55,14 | **DANGER** | Stop: sends StopMotors to the controller (interrupts motion). Human decision. |
| 4 | 0x0004 | BUTTON | push (hidden) | Refocus | 117,104,50,14 | **DANGER** | Refocus (hidden): Z motion (autofocus). |
| 57670 | 0xE146 | BUTTON | push | Help | 139,104,55,14 | **SAFE** |   |
| 1951 | 0x079F | BUTTON | push | OscTest | 93,42,33,12 | **DANGER** | OscTest: runs an oscillation test (motion). |
| 2616 | 0x0A38 | BUTTON | push | Z=0 | 139,22,21,12 | **DANGER** | Z=0: zeroes/moves the Z axis (prompt "X, Y motors are not at 0, do you wish to set the current position to zero?"). |
| 2617 | 0x0A39 | BUTTON | push | XY=0 | 163,22,31,12 | **DANGER** | XY=0: zeroes/moves X and Y. |
| 2618 | 0x0A3A | BUTTON | push | Beta=0 | 139,8,27,12 | **DANGER** | Beta=0: zeroes/moves Beta (prompt "Beta is not in zero. Do you want to move Beta to zero?"). |
| 2619 | 0x0A3B | BUTTON | push | Phi=0 | 167,8,27,12 | **DANGER** | Phi=0: zeroes/moves Phi. |

### Dialog 335 -- "User System Configuration" -- User System Configuration (Configuration > System Config, cmd 32921)

DIALOGEX template, 99 controls, size 299x318 DLU, lang 1033, 16 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1307 | 0x051B | EDIT | edit |   | 90,208,193,12 | **CAUTION** |   |
| 1989 | 0x07C5 | EDIT | edit |   | 90,220,91,12 | **CAUTION** |   |
| 1991 | 0x07C7 | EDIT | edit |   | 90,233,91,12 | **CAUTION** |   |
| 1992 | 0x07C8 | EDIT | edit |   | 90,246,91,12 | **CAUTION** |   |
| 1994 | 0x07CA | EDIT | edit |   | 90,259,91,12 | **CAUTION** |   |
| 1996 | 0x07CC | EDIT | edit |   | 90,272,91,12 | **CAUTION** |   |
| 2141 | 0x085D | EDIT | edit |   | 90,284,91,12 | **CAUTION** |   |
| 1510 | 0x05E6 | EDIT | edit |   | 90,297,91,12 | **CAUTION** |   |
| 1 | 0x0001 | BUTTON | default-push (hidden) | OK | 242,98,50,14 | **CAUTION** | OK (hidden): commits the configuration to the registry. |
| 1569 | 0x0621 | BUTTON | push | Open Shutter | 10,16,52,14 | **DANGER** | Open Shutter: opens the X-ray shutter via PLC. |
| 1570 | 0x0622 | BUTTON | push | Close Shutter | 10,32,52,14 | **DANGER** | Close Shutter: PLC shutter command. |
| 1006 | 0x03EE | EDIT | edit |   | 113,31,28,13 | **CAUTION** | Ro [mm] goniometer radius. |
| 1219 | 0x04C3 | BUTTON | check (hidden) | ActiveDet1 | 13,72,50,10 | **CAUTION** |   |
| 1220 | 0x04C4 | BUTTON | check (hidden) | ActiveDet2 | 13,83,50,10 | **CAUTION** |   |
| 1221 | 0x04C5 | BUTTON | check (hidden) | ActiveDet3 | 13,93,50,10 | **CAUTION** |   |
| 1222 | 0x04C6 | BUTTON | check (hidden) | ActiveDet4 | 13,104,50,10 | **CAUTION** |   |
| 1223 | 0x04C7 | BUTTON | check (hidden) | ActiveDet5 | 13,115,50,10 | **CAUTION** |   |
| 1224 | 0x04C8 | BUTTON | check (hidden) | ActiveDet6 | 13,126,50,10 | **CAUTION** |   |
| 1225 | 0x04C9 | BUTTON | check (hidden) | ActiveDet7 | 13,137,50,10 | **CAUTION** |   |
| 1226 | 0x04CA | BUTTON | check (hidden) | ActiveDet8 | 13,147,50,10 | **CAUTION** |   |
| 1701 | 0x06A5 | BUTTON | radio | Full System | 121,98,82,8 | **DANGER** | Full System radio: changes the motor configuration ("The Full system must be enabled in order to change the motor configuration"). |
| 1702 | 0x06A6 | BUTTON | radio | Beta  Z System | 121,107,82,8 | **DANGER** | Beta  Z System radio: changes the motor configuration. |
| 1703 | 0x06A7 | BUTTON | radio | Standard | 119,119,84,8 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio | Modified | 119,128,84,8 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio | Psi Method | 119,138,84,8 | **CAUTION** |   |
| 1706 | 0x06AA | BUTTON | radio | Laboratory | 121,158,82,8 | **CAUTION** |   |
| 1707 | 0x06AB | BUTTON | radio | Potable | 121,169,82,8 | **CAUTION** |   |
| 1708 | 0x06AC | BUTTON | radio | SET | 121,179,82,8 | **CAUTION** |   |
| 1709 | 0x06AD | BUTTON | radio | 4PB | 121,189,82,8 | **CAUTION** |   |
| 1874 | 0x0752 | BUTTON | check (disabled) (hidden) | Auto | 173,185,31,10 | **CAUTION** |   |
| 1251 | 0x04E3 | BUTTON | groupbox | Shutter | 7,7,58,53 | **SAFE** |   |
| 1252 | 0x04E4 | BUTTON | groupbox | Config | 108,7,42,53 | **SAFE** |   |
| 1253 | 0x04E5 | STATIC | label-center | Ro [mm]: | 108,19,36,8 | **SAFE** |   |
| 1255 | 0x04E7 | BUTTON | groupbox | Detectors | 7,61,103,97 | **SAFE** |   |
| 1710 | 0x06AE | BUTTON | check | AutoXRayOff | 154,11,126,9 | **DANGER** | AutoXRayOff checkbox (ON today). Unchecking removes the automatic X-ray-off after collection. |
| 1021 | 0x03FD | EDIT | edit |   | 234,142,22,14 | **CAUTION** |   |
| 1022 | 0x03FE | EDIT | edit |   | 227,182,22,14 | **CAUTION** |   |
| 1262 | 0x04EE | BUTTON | groupbox | AutoFocus | 215,61,77,139 | **SAFE** |   |
| 1263 | 0x04EF | STATIC | label | Correction coefficient: | 217,122,72,18 | **SAFE** |   |
| 1264 | 0x04F0 | STATIC | label | Defocus: | 219,164,30,16 | **SAFE** |   |
| 1864 | 0x0748 | STATIC | icon | #388 | 265,161,20,20 | **SAFE** |   |
| 1278 | 0x04FE | BUTTON | groupbox | Miscellaneous | 117,61,92,139 | **SAFE** |   |
| 1884 | 0x075C | BUTTON | check | Axis UpsideDown | 219,96,69,8 | **DANGER** | Axis UpsideDown: inverts axis direction. |
| 1885 | 0x075D | STATIC | label (hidden) | Static | 68,72,40,8 | **SAFE** |   |
| 1886 | 0x075E | STATIC | label (hidden) | Static | 68,83,40,8 | **SAFE** |   |
| 1887 | 0x075F | STATIC | label (hidden) | Static | 68,93,40,8 | **SAFE** |   |
| 1888 | 0x0760 | STATIC | label (hidden) | Static | 68,104,40,8 | **SAFE** |   |
| 1889 | 0x0761 | STATIC | label (hidden) | Static | 68,115,40,8 | **SAFE** |   |
| 1890 | 0x0762 | STATIC | label (hidden) | Static | 68,126,40,8 | **SAFE** |   |
| 1891 | 0x0763 | STATIC | label (hidden) | Static | 68,137,40,8 | **SAFE** |   |
| 1892 | 0x0764 | STATIC | label (hidden) | Static | 68,147,40,8 | **SAFE** |   |
| 1312 | 0x0520 | BUTTON | groupbox |   | 7,201,285,111 | **SAFE** |   |
| 2002 | 0x07D2 | BUTTON | check | Quick Autofocus | 219,74,69,10 | **CAUTION** |   |
| 2011 | 0x07DB | STATIC | label (hidden) | Chi Method | 119,147,36,8 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 117,92,92,26 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 117,148,92,51 | **SAFE** |   |
| 1776 | 0x06F0 | BUTTON | check | Debug Mode | 189,290,86,8 | **CAUTION** | Debug Mode (more logging). |
| 2071 | 0x0817 | BUTTON | check (hidden) | Alignment Correction | 154,42,84,8 | **CAUTION** |   |
| 2076 | 0x081C | BUTTON | push (hidden) | Align Corr. | 244,39,45,8 | **CAUTION** |   |
| 2090 | 0x082A | BUTTON | check | Move Beta to '0' after SET, Austenite | 154,29,132,10 | **DANGER** | Move Beta to '0' after SET, Austenite: motion after collections. |
| 2091 | 0x082B | BUTTON | check | Warning | 238,85,52,10 | **CAUTION** |   |
| 65535 | 0xFFFF | BUTTON | groupbox | Triaxial | 7,158,103,41 | **SAFE** |   |
| 2101 | 0x0835 | BUTTON | check | D-spacing | 21,168,86,10 | **CAUTION** |   |
| 2102 | 0x0836 | EDIT | edit |   | 37,180,64,14 | **CAUTION** |   |
| 2136 | 0x0858 | BUTTON | check | Oscillation Test Enabled | 189,299,97,8 | **CAUTION** | Oscillation Test Enabled. |
| 2315 | 0x090B | BUTTON | push | Write Controller | 191,224,54,14 | **DANGER** | Write Controller: writes motor-controller parameters. |
| 2350 | 0x092E | BUTTON | check | Description | 11,208,74,10 | **CAUTION** |   |
| 2351 | 0x092F | BUTTON | check | JobNo | 11,220,74,10 | **CAUTION** |   |
| 2352 | 0x0930 | BUTTON | check | PartNo | 11,233,74,10 | **CAUTION** |   |
| 2353 | 0x0931 | BUTTON | check | LotNo | 11,246,74,10 | **CAUTION** |   |
| 2354 | 0x0932 | BUTTON | check | InternalNo | 11,259,74,10 | **CAUTION** |   |
| 2355 | 0x0933 | BUTTON | check | SegmentNo | 11,272,74,10 | **CAUTION** |   |
| 1183 | 0x049F | BUTTON | check | Direction | 11,284,74,10 | **CAUTION** |   |
| 2357 | 0x0935 | BUTTON | check | Depth | 11,297,74,10 | **CAUTION** |   |
| 2391 | 0x0957 | BUTTON | push (hidden) | Inclinometer | 191,239,96,15 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | D: | 218,185,8,8 | **SAFE** |   |
| 1023 | 0x03FF | EDIT | edit |   | 265,182,22,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | R: | 255,185,8,8 | **SAFE** |   |
| 1711 | 0x06AF | BUTTON | check | XRayDisable | 212,20,80,9 | **DANGER** | XRayDisable checkbox: "Disable checking the ReadXRay, CloseShutter/OpenShutter". Safety-relevant. |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 185,218,107,94 | **SAFE** |   |
| 2548 | 0x09F4 | BUTTON | check | Disable Phi Limits | 189,281,79,8 | **DANGER** | Disable Phi Limits: removes software motion limits. |
| 2392 | 0x0958 | BUTTON | push (hidden) | LinearTransducer | 189,238,96,16 | **CAUTION** |   |
| 2614 | 0x0A36 | BUTTON | check | TeachButton | 219,107,69,8 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Z: | 224,145,8,8 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox |   | 215,115,77,45 | **SAFE** |   |
| 2710 | 0x0A96 | BUTTON | check | fast collection | 189,272,104,8 | **CAUTION** |   |
| 2715 | 0x0A9B | BUTTON | push | Osc Prog | 247,224,40,14 | **DANGER** | Osc Prog: writes the oscillation program to the controller. |
| 2349 | 0x092D | BUTTON | push | Local | 66,16,35,14 | **DANGER** | Local: switches the HV supply to local mode (XrdWin loses control). |
| 2356 | 0x0934 | BUTTON | push | Remote | 66,32,35,14 | **DANGER** | Remote: switches the HV supply to remote mode. |
| 1254 | 0x04E6 | BUTTON | groupbox | HV Control | 64,7,42,53 | **SAFE** |   |
| 2371 | 0x0943 | BUTTON | push (hidden) | ? | 66,46,13,12 | **SAFE** |   |
| 2845 | 0x0B1D | STATIC | label |   | 81,49,19,8 | **SAFE** |   |
| 1712 | 0x06B0 | BUTTON | radio | Standard Stages | 123,72,69,10 | **DANGER** | Standard Stages radio: motor configuration. |
| 1713 | 0x06B1 | BUTTON | radio | LargeStages | 123,82,56,10 | **DANGER** | LargeStages radio: motor configuration. |
| 1017 | 0x03F9 | BUTTON | push | V | 257,140,12,14 | **CAUTION** | Unlabelled button "V" next to AutoFocus (function unknown; treat as a setting). |
| 1018 | 0x03FA | BUTTON | push | ? | 273,140,12,14 | **SAFE** | Help "?" button. |
| 1024 | 0x0400 | BUTTON | check | DisablePhiMove SET,MET | 189,260,101,10 | **DANGER** | DisablePhiMove SET,MET: changes motion behaviour. |
| 2571 | 0x0A0B | BUTTON | check | Refocus Laser | 154,51,60,10 | **CAUTION** |   |
| 2736 | 0x0AB0 | EDIT | edit |   | 245,49,31,12 | **CAUTION** |   |

### Dialog 538 -- "Options" -- Options (Configuration > Options, cmd 33075)

DIALOG template, 25 controls, size 379x176 DLU, lang 4105, 5 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1 | 0x0001 | BUTTON | default-push | OK | 136,146,50,14 | **CAUTION** | OK commits all options to the registry (HKCU\...\XrdWin). |
| 2 | 0x0002 | BUTTON | push | Cancel | 194,146,50,14 | **SAFE** |   |
| 1642 | 0x066A | BUTTON | check | Profile Outside ROI | 208,49,76,8 | **CAUTION** |   |
| 1643 | 0x066B | BUTTON | check | InfoMainFrameDisplay(KV,mA,LPA,P_G) | 208,63,142,8 | **CAUTION** |   |
| 1644 | 0x066C | BUTTON | check | Teach Button on Screen(MyCom ver<3.2) | 22,101,148,8 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | check | Voice Recognition Menu | 208,76,95,8 | **CAUTION** |   |
| 1791 | 0x06FF | BUTTON | check | Show FWHM Fit - Report | 208,36,94,8 | **CAUTION** |   |
| 1857 | 0x0741 | BUTTON | check | Curve Fit | 208,23,44,8 | **CAUTION** |   |
| 1050 | 0x041A | BUTTON | check | SoftwareAutoCorrect | 22,23,81,8 | **CAUTION** |   |
| 2051 | 0x0803 | BUTTON | check | BetaPhi sides switching | 208,89,92,8 | **CAUTION** |   |
| 2082 | 0x0822 | BUTTON | check | Check for X-Ray* | 22,113,83,8 | **DANGER** | Check for X-Ray* (CheckForXRay=1 today): disabling removes the X-ray state check before collecting. |
| 2098 | 0x0832 | BUTTON | check | R calc, extended table | 208,101,87,8 | **CAUTION** |   |
| 2101 | 0x0835 | BUTTON | check | Triaxial D0 predefined | 208,113,84,8 | **CAUTION** |   |
| 2104 | 0x0838 | BUTTON | check | Display (E/(1+v))eff | 208,126,89,8 | **CAUTION** |   |
| 2500 | 0x09C4 | BUTTON | check | Init in CollectThread* | 22,63,78,8 | **DANGER** | Init in CollectThread*: XrdWin initializes (homes) by itself at collection start. |
| 2501 | 0x09C5 | BUTTON | check | AutoXray in CollectThread | 22,89,95,8 | **DANGER** | AutoXray in CollectThread (AutoXRayInCollectThread=1): X-rays switched on automatically inside a collection; "If the system wasn't initialized/warmed-up/set HV will do that before." |
| 1053 | 0x041D | BUTTON | check | Auto-Retry Coll XRay OFF | 22,36,94,8 | **DANGER** | Auto-Retry Coll XRay OFF (AutoRetryCollXRayOff=1): auto re-collect when X-rays were off. |
| 2606 | 0x0A2E | EDIT | edit |   | 119,34,16,12 | **CAUTION** | Retry count (AutoRetryCount=3). |
| 2645 | 0x0A55 | BUTTON | check | AutoScanPorts | 22,76,63,8 | **CAUTION** | AutoScanPorts (AutoScanPortsInInitThread=1). |
| 2608 | 0x0A30 | EDIT | edit |   | 119,21,16,12 | **CAUTION** |   |
| 2722 | 0x0AA2 | BUTTON | check | TryRecoveryCOMPorts | 22,49,92,8 | **CAUTION** | TryRecoveryCOMPorts. |
| 2175 | 0x087F | BUTTON | groupbox | Hardware | 7,7,179,135 | **SAFE** |   |
| 2179 | 0x0883 | BUTTON | groupbox | Software | 193,7,179,135 | **SAFE** |   |
| 2843 | 0x0B1B | BUTTON | check | Use I5 Limit Sensor | 22,126,77,10 | **DANGER** | Use I5 Limit Sensor: limit-sensor wiring option. |
| 2865 | 0x0B31 | BUTTON | push | Fitting Parameters | 285,145,74,14 | **CAUTION** | Opens Fitting Parameters (549). |

### Dialog 559 -- "Parameters" -- MiniPIX / camera Parameters (detector bridge settings)

DIALOG template, 66 controls, size 384x206 DLU, lang 4105, 2 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 1 | 0x0001 | BUTTON | default-push | OK | 87,185,50,14 | **CAUTION** | OK saves detector/bridge parameters. |
| 2 | 0x0002 | BUTTON | push | Cancel | 154,185,50,14 | **SAFE** |   |
| 65535 | 0xFFFF | STATIC | label | Exposure | 17,103,30,8 | **SAFE** |   |
| 1001 | 0x03E9 | EDIT | edit |   | 62,100,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | FrameRate | 17,119,36,8 | **SAFE** |   |
| 1002 | 0x03EA | EDIT | edit |   | 62,116,30,14 | **CAUTION** |   |
| 1022 | 0x03FE | BUTTON | check | AutoExposure | 17,51,60,10 | **CAUTION** |   |
| 1023 | 0x03FF | BUTTON | check | AutoFrameRate | 17,62,65,10 | **CAUTION** |   |
| 1024 | 0x0400 | BUTTON | check | AutoWhiteBalance | 18,73,75,10 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Binning | 17,133,24,8 | **SAFE** |   |
| 1003 | 0x03EB | EDIT | edit |   | 62,130,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Subsampling | 17,147,41,8 | **SAFE** |   |
| 1004 | 0x03EC | EDIT | edit |   | 62,144,30,14 | **CAUTION** |   |
| 1017 | 0x03F9 | BUTTON | push | Uninit | 97,110,57,14 | **CAUTION** | Uninit camera. |
| 1025 | 0x0401 | BUTTON | check | AutoGain | 17,42,45,10 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Gain | 17,88,16,8 | **SAFE** |   |
| 1005 | 0x03ED | EDIT | edit |   | 62,85,30,14 | **CAUTION** |   |
| 1018 | 0x03FA | BUTTON | push | Install Service | 98,39,57,14 | **CAUTION** | Install Service (uEye/ZWO camera service): modifies Windows services. |
| 1019 | 0x03FB | BUTTON | push | Uninstall Service | 98,56,57,14 | **CAUTION** | Uninstall Service: modifies Windows services. |
| 1020 | 0x03FC | BUTTON | push | Start Service | 98,72,57,14 | **CAUTION** | Start Service. |
| 1021 | 0x03FD | BUTTON | push | Stop Service | 98,86,57,14 | **CAUTION** | Stop Service. |
| 1701 | 0x06A5 | BUTTON | radio | Generic | 20,17,41,10 | **CAUTION** | Generic radio: detector type. Changing breaks the detector setup. |
| 1702 | 0x06A6 | BUTTON | radio | uEye | 85,17,32,10 | **CAUTION** | uEye radio: detector type. Changing breaks the detector setup. |
| 1703 | 0x06A7 | BUTTON | radio | ZWO | 126,17,33,10 | **CAUTION** | ZWO radio: detector type. Changing breaks the detector setup. |
| 1704 | 0x06A8 | BUTTON | radio | Minipix | 184,17,37,10 | **CAUTION** | Minipix radio: detector type (currently Minipix). Changing breaks the detector setup. |
| 65535 | 0xFFFF | BUTTON | groupbox | uEye  ZWO | 13,30,146,146 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox | Minipix | 161,30,208,133 | **SAFE** |   |
| 1026 | 0x0402 | BUTTON | push | Start Server | 241,41,57,14 | **CAUTION** | Start Server: launches the Python TCP bridge (tcpserverMiniPix2D_Event.py on localhost:8094). Starts a process; forbidden in read-only sessions. No motion/X-rays. |
| 1027 | 0x0403 | BUTTON | push | Python Path | 241,55,57,14 | **CAUTION** | Python Path (file picker; must stay Python37). |
| 1028 | 0x0404 | BUTTON | push | Script Path | 241,70,57,14 | **CAUTION** | Script Path (file picker). |
| 65535 | 0xFFFF | STATIC | label | Threshold | 165,60,32,8 | **SAFE** |   |
| 1006 | 0x03EE | EDIT | edit |   | 210,57,30,14 | **CAUTION** | Threshold. |
| 65535 | 0xFFFF | STATIC | label | Bias | 165,45,14,8 | **SAFE** |   |
| 1007 | 0x03EF | EDIT | edit |   | 210,42,30,14 | **CAUTION** | Bias voltage for the Timepix3 sensors. |
| 65535 | 0xFFFF | STATIC | label | Det1 | 169,119,16,8 | **SAFE** |   |
| 1008 | 0x03F0 | EDIT | edit |   | 188,116,99,14 | **CAUTION** | Det1 serial (C10-W0115 = left). |
| 65535 | 0xFFFF | STATIC | label | Det2 | 169,134,16,8 | **SAFE** |   |
| 1009 | 0x03F1 | EDIT | edit |   | 188,131,99,14 | **CAUTION** | Det2 serial (F06-W0115 = right). |
| 65535 | 0xFFFF | BUTTON | groupbox | Serials | 166,92,131,66 | **SAFE** |   |
| 1029 | 0x0405 | BUTTON | push | Get Serials | 239,98,57,14 | **CAUTION** | Get Serials: queries the detectors through the bridge (needs the bridge running). |
| 1030 | 0x0406 | BUTTON | check (hidden) | T3pa | 259,170,33,10 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Method | 302,108,25,8 | **SAFE** |   |
| 1010 | 0x03F2 | EDIT | edit |   | 336,105,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Tolerance | 302,92,33,8 | **SAFE** |   |
| 1011 | 0x03F3 | EDIT | edit |   | 336,89,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | High | 302,123,16,8 | **SAFE** |   |
| 1012 | 0x03F4 | EDIT | edit |   | 336,120,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Low | 302,139,14,8 | **SAFE** |   |
| 1013 | 0x03F5 | EDIT | edit |   | 336,136,30,14 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio | ToT | 307,57,29,10 | **CAUTION** |   |
| 1706 | 0x06AA | BUTTON | radio | T3pa | 307,72,33,10 | **CAUTION** |   |
| 1707 | 0x06AB | BUTTON | radio | Event | 307,41,35,10 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Dir | 96,134,10,8 | **SAFE** |   |
| 1014 | 0x03F6 | EDIT | edit |   | 124,131,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Min. Off | 95,148,26,8 | **SAFE** |   |
| 1015 | 0x03F7 | EDIT | edit |   | 124,145,30,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | Regions file | 17,162,38,8 | **SAFE** |   |
| 1016 | 0x03F8 | EDIT | edit |   | 62,159,30,14 | **CAUTION** |   |
| 1031 | 0x0407 | BUTTON | push | ON | 285,15,19,14 | **DANGER** | ON: powers the detector USB hub via the COM device given in 1034 (hardware action, hub power). |
| 1032 | 0x0408 | BUTTON | push | OFF | 309,14,19,14 | **DANGER** | OFF: powers the detector hub off (hardware action). |
| 1033 | 0x0409 | EDIT | edit |   | 331,14,30,14 | **CAUTION** |   |
| 1034 | 0x040A | EDIT | edit |   | 259,9,19,14 | **CAUTION** |   |
| 65535 | 0xFFFF | STATIC | label | COM | 236,11,17,8 | **SAFE** |   |
| 1048 | 0x0418 | BUTTON | check | ResetHUB | 231,24,50,10 | **CAUTION** | ResetHUB: power-cycles the hub automatically at start (hardware setting). |
| 1049 | 0x0419 | BUTTON | check | Show Script | 167,79,54,10 | **CAUTION** |   |
| 1050 | 0x041A | BUTTON | check | Adjust Flat Gain | 163,167,65,10 | **CAUTION** |   |

### Dialog 491 -- "Batch Processing" -- Batch Processing (File > Batch..., cmd 33050)

DIALOG template, 23 controls, size 242x255 DLU, lang 1033, 0 DANGER controls.

| ID | hex | type | style | text | rect [x,y,w,h] DLU | RISK | note |
|---|---|---|---|---|---|---|---|
| 2021 | 0x07E5 | BUTTON | push | Load | 162,7,66,14 | **CAUTION** | Load: file dialog, adds files to the list. |
| 1946 | 0x079A | BUTTON | push | Calculate | 162,22,66,14 | **CAUTION** | Calculate: recalculates and writes reports/exports for the listed files (file writes, no hardware). |
| 2062 | 0x080E | BUTTON | push | Clear list | 162,38,66,14 | **CAUTION** | Clear list. |
| 1176 | 0x0498 | BUTTON | push | Stop | 162,54,66,14 | **SAFE** | Stops the offline batch calculation (no hardware involved). |
| 1024 | 0x0400 | BUTTON | check | [ksi] to [MPa] | 157,78,67,8 | **CAUTION** |   |
| 1025 | 0x0401 | BUTTON | check | [MPa] to [ksi] | 157,89,67,8 | **CAUTION** |   |
| 2480 | 0x09B0 | BUTTON | check | Text Report | 155,113,75,8 | **CAUTION** |   |
| 2482 | 0x09B2 | BUTTON | check | Word Report | 155,123,75,8 | **CAUTION** |   |
| 2483 | 0x09B3 | BUTTON | check | Excel Report | 155,133,75,8 | **CAUTION** |   |
| 1701 | 0x06A5 | BUTTON | radio | Profile and Gain | 153,159,75,10 | **CAUTION** |   |
| 1702 | 0x06A6 | BUTTON | radio | Profile | 153,169,75,10 | **CAUTION** |   |
| 1703 | 0x06A7 | BUTTON | radio | Gain | 153,179,75,10 | **CAUTION** |   |
| 1704 | 0x06A8 | BUTTON | radio | None | 153,189,75,10 | **CAUTION** |   |
| 1705 | 0x06A9 | BUTTON | radio | 2Theta | 153,199,75,10 | **CAUTION** |   |
| 2708 | 0x0A94 | BUTTON | check | SaveAs version | 149,219,65,10 | **CAUTION** |   |
| 2709 | 0x0A95 | EDIT | edit |   | 215,218,17,12 | **CAUTION** |   |
| 1 | 0x0001 | BUTTON | default-push | OK | 169,234,50,14 | **SAFE** | OK closes the dialog. |
| 2048 | 0x0800 | LISTBOX | listbox |   | 7,28,140,194 | **SAFE** | File list (selection only). |
| 1004 | 0x03EC | msctls_progress32 | progress | Progress1 | 7,7,140,10 | **SAFE** |   |
| 1005 | 0x03ED | STATIC | label-center |   | 7,18,150,8 | **SAFE** |   |
| 2488 | 0x09B8 | BUTTON | groupbox | Export Profile, Gain | 151,147,84,69 | **SAFE** |   |
| 2487 | 0x09B7 | BUTTON | groupbox | Export Report | 151,101,84,44 | **SAFE** |   |
| 65535 | 0xFFFF | BUTTON | groupbox | Units | 151,68,84,33 | **SAFE** |   |

## 4. Other dialogs mentioning X-Ray / Warm / Shutter / HV / Abort / Stop / Continue / Home / Init / Collect / Password / Login / User

Found by scanning all 195 dialog templates. Full control lists are in the JSON (`selection: "keyword-scan"`); here only the caption and the actionable (BUTTON / EDIT-password) controls that are CAUTION or DANGER.

| Dialog | caption | what it is | DANGER / CAUTION controls (id: text [style]) |
|---|---|---|---|
| 553 |   | XRayEnable prompt, 3-button variant (Yes / No / Cancel) | **1: Yes [default-push]**; **2: Cancel [push]**; **3: No [push]** |
| 164 |   | High Voltage, single-dialog variant (Set + Warm Up + Stop, 7/15 min) | 1701: 7 min [radio]; 1702: 15 min [radio]; **1094: Set [default-push]**; **1095: Warm Up [push]**; **1243: Stop [push]**; 1: OK [push]; 1241: Auto Stand-By [check]; 1369: To Max [check] |
| 291 |   | "Push OK to continue collection." (pause/resume prompt) | **1628: OK [default-push]**; **1629: Cancel [push]** |
| 432 |   | "Push OK to continue collection." with X/Y offset entry | **1: OK [default-push]**; **2: Cancel [push]**; 2590: Offset [check]; 2718: Calibration [check] |
| 178 |   | Progress prompt with Stop / OK ("(or click OK)") | **1243: Stop [default-push]**; 1: OK [push] |
| 276 |   | Progress bar with Stop | **1243: Stop [default-push]** |
| 188 | Shutter | Shutter / PLC configuration (Open/Close Shutter, XRayEnable, XRayON bits, Set HV) | **1362: Open Shutter [push]**; **1363: Open Shutter [push]**; **1364: Open Shutter [push]**; **1365: Open Shutter [push]**; **1366: Close Shutter [push]**; **1367: Close Shutter [push]**; **1368: Close Shutter [push]**; **1369: Close Shutter [push]**; 1683: Use Timer* [check]; 2438: COM [push]; 2437: Use Trilogi PLC* [check]; 2439: Read Status [push]; 2440: Use SmartTFT* [check]; 2441: X Ray ON/OFF [push]; 2442: HVPower [push]; 2443: GetStatus [push]; 2444: SetIOs [push]; **2446: Set HV [push]**; 1022: Flow [check]; 1024: Door [check]; 1026: Combo [check]; 1028: OV [check]; 1030: OA [check]; 1023: OT [check]; 1048: TubeInPlace [check]; 1049: ShutterInPlace [check]; 1050: XRayBulbInPlace [check]; 1051: ShutterBulbInPlace [check]; 1052: OpenCloseShutter [check]; 1053: XRayEnable [check]; 1054: XRayON [check]; 1055: ShutterOpen [check]; 1056: ShutterClose [check]; 1057: HVPowerON [check]; ... (11 more, see JSON) |
| 106 | X-Ray Tube | X-Ray Tube configuration (tube limits, warm-up constants) | 1731: Continuous set (for Warm-Up proc.)* [check]; 2336: MAX532 and new power supply (first controller, port A)* [check]; 2352: InvertLogic(kV<->mA)* [check]; **2426: Interlock Reset Memory(power supply vs 2)* [check]**; 2428: Serial Power Supply* [check]; 2429: COM [push]; 2430: Config [push]; 2525: through Direct05 (LXRD)* [check]; 2526: Hermes* [check]; 2842: Flash [check]; 2867: DF60N3X3645 [check]; 2868: MFX50W [check] |
| 498 | Direct05 | Direct05 power-supply I/O (Write XRayON / XRayOFF) | 1547: Read [push]; 1548: Write [push]; 1: OK [default-push]; 1549: Read kV [push]; 1550: Read mA [push]; 1551: Read T [push]; 1552: Read Filament [push]; 1553: Read I/O [push]; **1554: Write XRayON(C0) [push]**; **1555: Write XRayOFF(C4) [push]**; 1556: Write Reset(Y3) [push]; 1701: Local/Remote [radio]; 1702: HV fault [radio]; 1703: XRay ON [radio]; 1599: TEST [push] |
| 474 | Spellman Serial | Spellman Serial (HV supply serial settings) | 1: OK [default-push]; 2307: Send [push]; 2433: ResetFault(31) [push]; 2371: Ask PowerSupply [push]; 2611: Read filament [push]; 1022: Wait for HV [check] |
| 204 | Enter your password | Enter your password | **1358:   [edit-password]**; 1: OK [default-push] |
| 205 | Set the Password | Set the Password / user management | 1359:   [edit-password]; 1360:   [edit-password]; 1361:   [edit-password]; 1: OK [default-push]; 57671: Delete user [push] |
| 102 | Update | Update (User / Password / download) | 1001: Check Update [push]; 1: OK [push]; 1858: LAN* [check]; 2003: Database [check]; 2004: Update(it needs UpdateManager.exe) [check]; 2052: Email [check]; 2053: Add [push]; 2045: Del [push] |
| 451 | Dialog | Remote connect dialog (User ID / Password / Server IP) | 1: OK [push]; **1248:   [edit-password]**; 2303: Connect [default-push]; 2306: Disconnect [push]; 2307: Send [default-push]; 2309: Balloon [check] |
| 176 | COM Ports | COM Ports selection | 1: OK [default-push]; 1701: COM1 [radio]; 1702: COM2 [radio]; 1703: COM3 [radio]; 1704: COM4 [radio]; 1705: COM5 [radio]; 1706: COM6 [radio]; 1707: COM7 [radio]; 1708: COM8 [radio] |
| 334 | Sounds | Sounds (Initialization done / Warm-up done / Collection done) | 1500: Start program [check]; 1501: End program [check]; 1502: Initialization done [check]; 1503: Warm-up done [check]; 1504: Exposure done [check]; 1505: Collection done [check]; 1506: End motor movement [check]; 1507: Defocus done [check]; 1508: Refocus done [check]; 1509: Warning [check]; 1510: End of measurement [check]; 1511: Ready to refocus [check]; 1512: Ready to go down [check]; 1513: Teach Button [check]; 1701:   [radio]; 1702:   [radio]; 1703:   [radio]; 1704:   [radio]; 1705:   [radio]; 1706:   [radio]; 1707:   [radio]; 1708:   [radio]; 1709:   [radio]; 1710:   [radio]; 1711:   [radio]; 1712:   [radio]; 1713:   [radio]; 1714:   [radio]; 1750: Browse [push]; 1: OK [push] |
| 136 | Motors | Motors configuration (HOME) | 1701: 2 [radio]; 1702: 3 [radio]; 1703: 4 [radio]; 1500: X [check]; 1501: Y [check]; 1502: Z [check]; 1503: Beta [check]; 1504: Phi [check]; 1505: R1* [check]; 1506: R2 [check]; 1507: R3* [check]; 1184: Add Head [push]; 1185: Delete Last Head [push]; 1189: Controller Setup [push]; 1191: Add Controller [push]; 1508: R4* [check]; 1509: R5* [check]; 1510: R6* [check]; 1511: R7* [check]; 1512: R8* [check]; 1513: R9 [check]; 1514: R10 [check]; 1515: R11 [check]; 1192: Delete Cntr. [push]; **1565: HOME [push]**; 1075: Simulation [check]; 2485: XCircleAxis=0 [check]; 2457: Sim Motors [check]; 1566: LIMITS [push]; 2868: ChiSys use R1 [check]; 2869: 2DET [check] |
| 105 | Setup | Motor axis Setup (Reverse Moves(HOME), Home Speed) | 1179: Encoder Enabled: [check]; 1180: AutoCorrection: [check]; 1181: Reverse Moves(HOME): [check]; 1182: Offline Oscillation: [check]; 1215: Backwards [radio]; 1216: Forwards [radio]; 1183: Reverse Direction(SOFT.): [check]; 1185: RD.STA Logic New [check] |
| 473 | Dialog | Motor controller setup (InitSpeed, home sensors) | 1183: Reverse Direction(SOFT.): [check]; 1179: Encoder Enabled: [check]; 1180: AutoCorrection: [check]; 1181: Reverse (DE-RE-FOCUS): [check]; 1215: Backwards [radio]; 1216: Forwards [radio]; 1049:   [check]; 1050:   [check]; 1051:   [check]; 1052:   [check]; 1017: READ Data [push]; 2427: Jog Enable [check]; 2521: Write Osc /Z speed Prog [push]; 1018: WRITE Data [push]; 2644: Aust LimMin Home sens [check]; 2663: ForceCOMPort [check]; 2428: Hardware Autocorrect* [check]; 2695: New osc [check]; 2773: Z2Sp [check] |
| 147 | Miscellaneous | Miscellaneous options (Check for X-Ray, AutoXray in CollectThread ...) | 1174: Read Contr >> [push]; 1396: Write Contr [push]; 1634: Admin access (Import P,G) [check]; 1636: Load original registry from file [push]; 1638: Config Access for OpenDocuments [check]; 1175: Delete Prog. [push]; 1641: Enable Chi AND Psi Selection [check]; 1642: Profile Outside ROI [check]; 1643: InfoMainFrameDisplay(KV,mA,LPA,P_G) [check]; 1644: Teach Button on Screen [check]; 1704: Voice Recognition Menu [check]; 1776: Debug Mode [check]; 1790: Movie [push]; 1791: Show FWHM Fit - Report [check]; 1857: Curve Fit [check]; 1872: Don't Check MSWord Version [check]; 1940: Print(ctrl) Config [push]; 1986: IncrementalOsc [check]; 1995: Wait before Osc [check]; 1050: SoftwareAutoCorrect [check]; 2015: Dual System [check]; 2051: BetaPhi sides switching [check]; **2055: Move [push]**; 2056: Download PRG [push]; 2057: Run PRG [push]; 2059: Set Path [push]; **2082: Check for X-Ray* [check]**; ... (26 more, see JSON) |
| 336 | User System Configuration | User System Configuration (second page) | 1: OK [default-push]; 1645: Save Template [push]; 1646: Load Template [push]; 2613: DocumentCompletelyCollected [check] |
| 348 | Hardware Configuration | Hardware Configuration (XRay Update) | 1: OK [default-push]; 1763: Diagnostics [push]; 1773: Test [check]; 1774: Test [check]; 1775: Test [check]; 1776: Test [check]; 1777: XRay Update [check]; 2174: IOs Update [check]; 1623: Reset [push]; 1624: Read [push] |
| 545 | Nitride | Nitride setup (Home Beta / Home Detector) | 1: OK [default-push]; 1701: Compound Layer Thickness [radio]; 1702: Crystaline Phases [radio]; 1703: Both [radio]; 1022: Home Beta [check]; 1023: Home Detector [check] |
| 442 | Average Peak Method | Average Peak Method (Collect / Home Beta) | 1: OK [default-push]; 1017: Load file... [push]; 1020: Load file... [push]; 1019: Load file... [push]; 1045: Load file... [push]; 1046: Load file... [push]; 1375: Calculate [push]; 1051: R Calc. [push]; 1101: Reset [push]; 1377: I Manual [check]; 1469: Print [push]; 2095: Table [push]; 2316: Collect [check]; 2318: Setup [push]; 1874: Auto [check]; 2417: Gain [check]; 2646: R List [check]; 2651: Home Beta [check]; 1022: QG [check]; 1024: Beta after Aust [check] |
| 166 | Teach Map | Teach Map (Collect, Stop, GO HOME) | 1398: Start [default-push]; **1407: At the END -> GO HOME [check]**; **1176: Stop [push]**; 1019: Back 1 Point [push]; 1045: Undo [push]; 1: Save [push]; 1593: Register point [push]; **1587: Collect [default-push]**; 1701: S.E.T. [radio]; 1702: Multi [radio]; 1703: Elliptical [radio]; 1704: Triaxial [radio]; 1021: Load Teach Map [push]; **1051: Home X/Y Motors after [check]**; 1022: Calculate Normal to surface [check]; 1621: ZPos [push]; 2139: using Z [check]; 2312: Cylindrical Map (rho axis) [check] |
| 167 | Square Map | Square Map (Home X/Y after, Auto X-Ray Shut Off) | 1345: Load [default-push]; 1048: Manual Refocusing [check]; **1051: Home X/Y Motors after [check]**; **1052: Auto X-Ray Shut Off [check]**; 1017: Zero X/Y Motors [push]; 1706: S.E.T. [radio]; 1707: M.E.T. [radio]; 1708: E.M. [radio]; 1709: Triaxial [radio]; 1: OK [push]; 1397: Z Position Calculation [check]; 1621: ZPos [push]; 1622: Reset ZPos [push]; 1053: Ignore prompt errors [check]; 1022: use curve surface correction during collection [check]; 2112: Alarm [push]; 2139: using Z [check]; 2312: Cylindrical Map (rho axis) [check]; 2317: Import [push] |
| 168 | Circle Map | Circle Map (Home X/Y after, Auto X-Ray Shut Off) | 1345: Load [default-push]; 1048: Manual Refocusing [check]; **1051: Home X/Y Motors after [check]**; **1052: Auto X-Ray Shut Off [check]**; 1017: Zero X/Y Motors [push]; 1706: S.E.T. [radio]; 1707: M.E.T. [radio]; 1708: E.M. [radio]; 1709: Triaxial [radio]; 1: OK [push]; 1397: Z Position Calculation [check]; 1621: ZPos [push]; 1622: Reset ZPos [push]; 1053: Ignore prompt errors [check]; 2139: using Z [check] |
| 269 | Austenite Calibration | Austenite Calibration (Collect Standard/Samples/Gain) | 1: OK [default-push]; **1587: Collect Standard [push]**; 1101: Reset [push]; 1375: Calculate [push]; **1596: Collect Samples [push]**; 1637: Sample from file [check]; **1588: Collect Gain [push]**; 2093: Recollect [check]; 1102: Limits [push] |
| 328 | Inline measurements | Inline measurements (Non stop / Stop) | 1701: Nr of Samples [radio]; 1702: Time running [radio]; 1703: Non stop [radio]; 1: OK [default-push]; 1707: Start [push]; **1243: Stop [push]**; **1736: Calibration [push]**; 2590: Intensity [check]; 1871: Load [push]; 1704: Intensity Ratio: [radio]; 1705: Integral Ratio: [radio]; 1713: absolute [radio]; 1714: relative pos [radio]; 2676: View File [push]; 1623: Reset [push]; 2679: Use peak params in single [check]; 2801: Intensity Max [check] |
| 332 | SET Calculus | SET Calculus (Collect) | 1714: Load [push]; **1715: Collect [push]**; 1729: Reset [push]; 1719: Load [push]; **1720: Collect [push]**; 1730: Reset [push]; 1375: Calculate [push]; 1: OK [default-push]; 1742: Print [push] |
| 411 | Calibration | Calibration (Collect) | 2099: Long Method [check]; **1684: Collect [push]**; 1739: Load [push]; 1946: Calculate [push]; 1623: Reset [push]; 2049: Save [push]; **1685: Collect [push]**; 1740: Load [push]; 1947: Calculate [push]; 1624: Reset [push]; 2051: Save [push]; 1: OK [default-push]; 1469: Print [push]; 2696: Cx RS [check]; **2703: Calibrate [push]**; **2704: Collect [push]**; 1096: Osc Phi [check] |
| 414 | Alignment Correction | Alignment Correction (Stop) | 1: OK [default-push]; 1398: Start [push]; **1176: Stop [push]** |
| 457 | Find | Find (Stop) | 1: OK [default-push]; 1000: Find [push]; **1243: Stop [push]**; 1004: Pause [push]; 2345: Update [push]; 2346: Clear [push]; 2347: Root [push]; **2349: Local [push]** |
| 522 | Powder Diffraction | Powder Diffraction (Stop) | 1: OK [default-push]; 2626: PSI Scan (Tube) [push]; 2627: CHI Scan (Beta) [push]; 2628: PSI  CHI Scan [push]; 2629: INLINE measurement [push]; 2630: Formula [push]; **1243: Stop [push]**; 2637: OscPSI [check]; 2639: OscCHI [check]; 1701: Around current pos. [radio]; 1702: Using left pos [radio]; 2631: 2Theta Scan (Tube,Det) [push]; 2632: X Scan [push]; 1097: OscX [check] |
| 537 | Dialog | Detector offset dialog (Init / Collect Offset) | 1: OK [default-push]; **1184: Init [push]**; 2752: Inverted [check]; 2754: Equalize [check]; 1185: Convert HIS to BMP [push]; 2756: Collect Offset [check]; 1739: Load Offset [push]; 1740: Load PixelMask [push] |
| 539 | Handheld system | Handheld system (STOP) | 1: OK [default-push]; 1587: START [push]; **1243: STOP [push]**; 1871: Load [push]; 1101: Reset [push]; 1460: Save [push]; 1227: Test [push]; 1375: Calculate [push]; 2850: Obtain Powder [push] |

Dialogs 326 (fitting error), 546 and 553 (XRayEnable) are the only resource-defined message boxes; all other prompts in section 8 are plain `AfxMessageBox` / `MessageBox` calls (window class `#32770`, caption "XrdWin", buttons IDOK=1 / IDYES=6 / IDNO=7 / IDCANCEL=2).

## 5. Main-window menu tree

Menu resource ID = document template string ID (string table block 10): 148 SET (.st), **149 MET (.mt) = the residual-stress measurement**, 150 EM, 151 Triaxial, 152 Square Map, 153 Circle Map, 154 Teach Map, 155 Austenite (.as), 156 Pole Figure, 157 Single Crystal, 158 Powder Diffraction. Menu 128 is the frame menu with no document; 129 is the legacy default document. All menus are classic (non-extended) MENU resources, so UIA exposes them as MenuBar > MenuItem by caption; the command ID is what `WM_COMMAND` carries.

### Menu 128 -- main frame, no document open (22 commands)

| cmd | path | RISK | note / status-bar string |
|---|---|---|---|
| 183 | File > New > SET | CAUTION | Single Exposure Technique Document / Single Exposure |
| 184 | File > New > Multi | CAUTION | Multiple Exposure Technique Document / Multiple Exposure |
| 186 | File > New > Triaxial | CAUTION | Triaxial Document / Triaxial |
| 187 | File > New > Square Map | CAUTION | Square Map Document / Square Map |
| 189 | File > New > Teach  Map | CAUTION | LAUE Document / Sx Orientation |
| 190 | File > New > Austenite | CAUTION | Austenite Document / Austenite |
| 190 | File > New > Austenite | CAUTION | Austenite Document / Austenite |
| 191 | File > New > Pole Figure | CAUTION | Pole Figure Document / Pole Figure |
| 192 | File > New > Single Crystal | CAUTION | Single Crystal Document / Single Crystal |
| 57601 | File > Open... | SAFE | Open an existing document / Open |
| 32874 | File > Choose Project | CAUTION | Choose Project (folder under C:\XrdWin Data). |
| 32880 | File > New Project | CAUTION | New Project (creates a folder). |
| 57616 | File > Recent File | SAFE | Open this document |
| 57665 | File > Exit | SAFE | Exit: prompts to save documents; does not touch hardware (X-ray off is NOT guaranteed by exiting). |
| 59392 | View > Toolbar | SAFE | Show or hide the toolbar / Toggle ToolBar |
| 59393 | View > Status Bar | SAFE | Show or hide the status bar / Toggle StatusBar |
| 57667 | Help > Help Topics | SAFE | List Help topics / Help Topics |
| 57664 | Help > About XrdWin... | SAFE | Display program information, version number and copyright / About |
| 32890 | Help > Wizard Mode | SAFE |   |
| 32923 | Help > Wizard | SAFE | Show the Wizard / Wizard |
| 32932 | Help > Wizard Options | SAFE |   |
| 32934 | Help > Update | CAUTION |   |

### Menu 149 -- Multiple Exposure Technique (.mt) -- stress measurement (98 commands)

| cmd | path | RISK | note / status-bar string |
|---|---|---|---|
| 183 | File > New > SET | CAUTION | Single Exposure Technique Document / Single Exposure |
| 184 | File > New > Multi | CAUTION | Multiple Exposure Technique Document / Multiple Exposure |
| 186 | File > New > Triaxial | CAUTION | Triaxial Document / Triaxial |
| 187 | File > New > Square Map | CAUTION | Square Map Document / Square Map |
| 188 | File > New > Circle Map | CAUTION | Circle Map Document / Circle Map |
| 189 | File > New > Teach  Map | CAUTION | LAUE Document / Sx Orientation |
| 190 | File > New > Austenite___ | CAUTION | Austenite Document / Austenite |
| 191 | File > New > Pole Figure | CAUTION | Pole Figure Document / Pole Figure |
| 192 | File > New > Single Crystal | CAUTION | Single Crystal Document / Single Crystal |
| 57601 | File > Open.......................... | SAFE | Open an existing document / Open |
| 32873 | File > Open Gain__ | CAUTION | Open an existing gain file / Open Gain |
| 57603 | File > Save | CAUTION | Save the active document / Save |
| 57604 | File > Save As... | CAUTION | Save the active document with a new name / Save As |
| 32868 | File > Export To Text File > Profile  Gain | CAUTION |   |
| 32867 | File > Export To Text File > Profile  Gain(2Th) | CAUTION |   |
| 32869 | File > Export To Text File > Profile | CAUTION |   |
| 32870 | File > Export To Text File > Gain | CAUTION |   |
| 33079 | File > Export To Text File > 2Theta | CAUTION | Head4, R11 Axis |
| 33087 | File > Export To Text File > Setup XLS | CAUTION | R3 Axis |
| 33088 | File > Export To Text File > Setup XML | CAUTION | Rho Axis |
| 33089 | File > Export To Text File > Setup CSV | CAUTION | Aust Axis |
| 32871 | File > Import From Text File______ > Profile  Gain____ | CAUTION |   |
| 32872 | File > Import From Text File______ > Profile | CAUTION |   |
| 32873 | File > Import From Text File______ > Gain | CAUTION | Open an existing gain file / Open Gain |
| 32902 | File > Import From Text File______ > Import from old file | CAUTION |   |
| 32874 | File > Choose Project | CAUTION | Choose Project (folder under C:\XrdWin Data). |
| 32880 | File > New Project | CAUTION | New Project (creates a folder). |
| 33068 | File > Set current project | CAUTION | Head4, Phi Axis |
| 57607 | File > Print... | SAFE | Print the active document / Print |
| 57609 | File > Print Preview | SAFE | Display full pages / Print Preview |
| 57606 | File > Print Setup... | SAFE | Change the printer and printing options / Print Setup |
| 33050 | File > Batch... | CAUTION | Batch...: opens dialog 491. |
| 32895 | File > Choose New Password | CAUTION | Choose New Password: opens 205. |
| 57612 | File > Send... |  | Send the active document through electronic mail / Send Mail |
| 57665 | File > Exit | SAFE | Exit: prompts to save documents; does not touch hardware (X-ray off is NOT guaranteed by exiting). |
| 57616 | File > Recent Files | SAFE | Open this document |
| 59392 | View > Toolbar | SAFE | Show or hide the toolbar / Toggle ToolBar |
| 59393 | View > Status Bar | SAFE | Show or hide the status bar / Toggle StatusBar |
| 32771 | Constants > Constants | CAUTION | Constants: opens the property sheet with pages 112/113/114/111. |
| 32772 | Constants > Background | CAUTION | Choose Background and ROI Constants / Peak Fit Limits |
| 32921 | Configuration > System Config | CAUTION | System Config: opens dialog 335. |
| 32773 | Configuration > System | CAUTION | System constants (hardware configuration). |
| 32792 | Configuration > Save Configuration | CAUTION | Save Configuration: writes the registry configuration. |
| 33075 | Configuration > Options | CAUTION | Options: opens dialog 538. |
| 32786 | Initialization > Motors | DANGER | Initialization > Motors: opens dialog 206 (then "Initialization" homes the motors). |
| 32789 | Initialization > High Voltage | DANGER | Initialization > High Voltage: opens the HV property sheet (427/428/489). Warm Up / Set turn X-rays on. |
| 32791 | Initialization > Move Motors | DANGER | Initialization > Move Motors: opens dialog 163. |
| 32891 | Initialization > Refocus | DANGER | Refocus: Z motion (autofocus). |
| 32896 | Initialization > Defocus | DANGER | Defocus: Z motion. |
| 35000 | Initialization > Calibration | DANGER |   |
| 32800 | Collect > Multiple Exposure Technique | DANGER | Collect > Multiple Exposure Technique: the stress measurement (motion + X-rays) after dialog 221. |
| 32847 | Collect > Calculation | SAFE | Calculation: recalculates the open document from stored data (no hardware). |
| 32834 | Collect > Gain | DANGER | Collect > Gain: collection with X-rays. |
| 33070 | Collect > Quick gain | DANGER | Quick gain: collection with X-rays. |
| 33078 | Collect > Multi gain | DANGER | Multi gain: X-rays. |
| 32865 | Collect > Continuate later | DANGER | Continuate later: resumes a paused measurement (goes to the second-to-last angle, X-rays). |
| 32885 | Collect > Austenite Setup | DANGER |   |
| 32887 | Collect > Austenite Parameters_ | CAUTION |   |
| 57667 | Help > Help Topics | SAFE | List Help topics / Help Topics |
| 57664 | Help > About XrdWin... | SAFE | Display program information, version number and copyright / About |
| 32890 | Help > Wizard Mode | SAFE |   |
| 32932 | Help > Wizard Options | SAFE |   |
| 32934 | Help > Update | CAUTION |   |
| 32987 | Help > Simulate | CAUTION | Simulate: Simulation flag (Simulation=0 today). The README states no safe simulation mode exists. |
| 32903 | Utilities > Stress with depth > New |  |   |
| 32904 | Utilities > Stress with depth > Open |  |   |
| 32907 | Utilities > Principal stress determination > Model 2D |  |   |
| 32908 | Utilities > Principal stress determination > Model 3D |  |   |
| 32877 | Utilities > Proto Strain |  |   |
| 32878 | Utilities > Proto Gradient |  |   |
| 32966 | Utilities > Pole Figure |  | Pole Figure Document / Pole Figure |
| 32985 | Utilities > Inline Measurements |  |   |
| 32994 | Utilities > Expert System |  |   |
| 33133 | Utilities > Camera |  |   |
| 33081 | Utilities > Alignment Camera |  | Y Axis |
| 33127 | Utilities > Database |  |   |
| 33121 | Utilities > Proto Stress vs Depth |  |   |
| 33069 | Utilities > Blade Loading |  | Head4, Big Z Axis |
| 33074 | Utilities > ISTL |  | Head4, Tube Axis |
| 33222 | Utilities > XRDWIN Utility |  |   |
| 32967 | Go > Initialize | DANGER | Go > Initialize: same as Motors Initialize. |
| 32968 | Go > High Voltage | DANGER | Go > High Voltage. |
| 32969 | Go > Autofocus | DANGER |   |
| 32970 | Go > Defocus | DANGER |   |
| 32971 | Go > Move Beta | DANGER | Go > Move Beta. |
| 32972 | Go > Move Phi | DANGER | Go > Move Phi. |
| 32973 | Go > Move X | DANGER | Go > Move X. |
| 32974 | Go > Move Y | DANGER | Go > Move Y. |
| 32975 | Go > Move Z | DANGER | Go > Move Z. |
| 32976 | Go > New Single | DANGER |   |
| 32977 | Go > New Multi | DANGER |   |
| 32978 | Go > New Triaxial | DANGER |   |
| 32979 | Go > New Square | DANGER |   |
| 32980 | Go > New Circle | DANGER |   |
| 32981 | Go > New Teach | DANGER |   |
| 32982 | Go > New Austenite | DANGER |   |
| 32983 | Go > Fit |  |   |

### Menu 148 -- Single Exposure Technique (.st) (93 commands)

| cmd | path | RISK | note / status-bar string |
|---|---|---|---|
| 183 | File > New > SET | CAUTION | Single Exposure Technique Document / Single Exposure |
| 184 | File > New > Multi | CAUTION | Multiple Exposure Technique Document / Multiple Exposure |
| 186 | File > New > Triaxial | CAUTION | Triaxial Document / Triaxial |
| 187 | File > New > Square Map | CAUTION | Square Map Document / Square Map |
| 188 | File > New > Circle Map | CAUTION | Circle Map Document / Circle Map |
| 189 | File > New > Teach  Map | CAUTION | LAUE Document / Sx Orientation |
| 190 | File > New > Austenite | CAUTION | Austenite Document / Austenite |
| 191 | File > New > Pole Figure | CAUTION | Pole Figure Document / Pole Figure |
| 192 | File > New > Single Crystal | CAUTION | Single Crystal Document / Single Crystal |
| 57601 | File > Open... | SAFE | Open an existing document / Open |
| 32873 | File > Open Gain | CAUTION | Open an existing gain file / Open Gain |
| 57603 | File > Save | CAUTION | Save the active document / Save |
| 57604 | File > Save As... | CAUTION | Save the active document with a new name / Save As |
| 32868 | File > Export To Text File > Profile  Gain | CAUTION |   |
| 32867 | File > Export To Text File > Profile  Gain(2Th) | CAUTION |   |
| 32869 | File > Export To Text File > Profile | CAUTION |   |
| 32870 | File > Export To Text File > Gain | CAUTION |   |
| 32871 | File > Import From Text File > Profile  Gain | CAUTION |   |
| 32872 | File > Import From Text File > Profile | CAUTION |   |
| 32873 | File > Import From Text File > Gain | CAUTION | Open an existing gain file / Open Gain |
| 32902 | File > Import From Text File > Import from old file | CAUTION |   |
| 32874 | File > Choose Project | CAUTION | Choose Project (folder under C:\XrdWin Data). |
| 32880 | File > New Project | CAUTION | New Project (creates a folder). |
| 33068 | File > Set current project | CAUTION | Head4, Phi Axis |
| 57607 | File > Print... | SAFE | Print the active document / Print |
| 57609 | File > Print Preview | SAFE | Display full pages / Print Preview |
| 57606 | File > Print Setup... | SAFE | Change the printer and printing options / Print Setup |
| 33050 | File > Batch... | CAUTION | Batch...: opens dialog 491. |
| 32895 | File > Choose New Password | CAUTION | Choose New Password: opens 205. |
| 57612 | File > Send... |  | Send the active document through electronic mail / Send Mail |
| 57665 | File > Exit | SAFE | Exit: prompts to save documents; does not touch hardware (X-ray off is NOT guaranteed by exiting). |
| 57616 | File > Recent Files | SAFE | Open this document |
| 59392 | View > Toolbar | SAFE | Show or hide the toolbar / Toggle ToolBar |
| 59393 | View > Status Bar | SAFE | Show or hide the status bar / Toggle StatusBar |
| 32771 | Constants > Constants | CAUTION | Constants: opens the property sheet with pages 112/113/114/111. |
| 32772 | Constants > Background | CAUTION | Choose Background and ROI Constants / Peak Fit Limits |
| 32921 | Configuration > System Config | CAUTION | System Config: opens dialog 335. |
| 32773 | Configuration > System | CAUTION | System constants (hardware configuration). |
| 32792 | Configuration > Save Configuration | CAUTION | Save Configuration: writes the registry configuration. |
| 33075 | Configuration > Options | CAUTION | Options: opens dialog 538. |
| 32786 | Initialization > Motors | DANGER | Initialization > Motors: opens dialog 206 (then "Initialization" homes the motors). |
| 32789 | Initialization > High Voltage | DANGER | Initialization > High Voltage: opens the HV property sheet (427/428/489). Warm Up / Set turn X-rays on. |
| 32791 | Initialization > Move Motors | DANGER | Initialization > Move Motors: opens dialog 163. |
| 32891 | Initialization > Refocus | DANGER | Refocus: Z motion (autofocus). |
| 32896 | Initialization > Defocus | DANGER | Defocus: Z motion. |
| 35000 | Initialization > Calibration | DANGER |   |
| 32838 | Collect > Profile | DANGER | Collect > Profile: opens "Ready for collection?" (221) then collects with X-rays. |
| 32834 | Collect > Gain | DANGER | Collect > Gain: collection with X-rays. |
| 33070 | Collect > Quick gain | DANGER | Quick gain: collection with X-rays. |
| 32986 | Collect > SET Calculus | DANGER |   |
| 33128 | Collect > Stress Calculation (2) | DANGER |   |
| 33084 | Collect > Setup Nitride | DANGER | Phi Axis |
| 57667 | Help > Help Topics | SAFE | List Help topics / Help Topics |
| 57664 | Help > About XrdWin... | SAFE | Display program information, version number and copyright / About |
| 32890 | Help > Wizard Mode | SAFE |   |
| 32932 | Help > Wizard Options | SAFE |   |
| 32934 | Help > Update | CAUTION |   |
| 32987 | Help > Simulate | CAUTION | Simulate: Simulation flag (Simulation=0 today). The README states no safe simulation mode exists. |
| 32903 | Utilities > Stress with depth > New |  |   |
| 32904 | Utilities > Stress with depth > Open |  |   |
| 32907 | Utilities > Principal stress determination > Model 2D |  |   |
| 32908 | Utilities > Principal stress determination > Model 3D |  |   |
| 32877 | Utilities > Proto Strain__ |  |   |
| 32878 | Utilities > Proto Gradient__ |  |   |
| 32985 | Utilities > Inline Measurements__ |  |   |
| 32994 | Utilities > Expert System |  |   |
| 33133 | Utilities > Camera |  |   |
| 33081 | Utilities > Alignment Camera |  | Y Axis |
| 33127 | Utilities > Database |  |   |
| 2100 | Utilities > Peak Broadening |  |   |
| 33062 | Utilities > Cameras  Inclinometer |  | Head3, R10 Axis |
| 33073 | Utilities > Material Bragg Angle |  | Head4, Aust Axis |
| 33074 | Utilities > ISTL |  | Head4, Tube Axis |
| 33076 | Utilities > Handheld system |  | Head4, Blade Axis |
| 33222 | Utilities > XRDWIN Utility |  |   |
| 32967 | Go > Initialize | DANGER | Go > Initialize: same as Motors Initialize. |
| 32968 | Go > High Voltage | DANGER | Go > High Voltage. |
| 32969 | Go > Autofocus | DANGER |   |
| 32970 | Go > Defocus | DANGER |   |
| 32971 | Go > Move Beta | DANGER | Go > Move Beta. |
| 32972 | Go > Move Phi | DANGER | Go > Move Phi. |
| 32973 | Go > Move X | DANGER | Go > Move X. |
| 32974 | Go > Move Y | DANGER | Go > Move Y. |
| 32975 | Go > Move Z | DANGER | Go > Move Z. |
| 32976 | Go > New Single | DANGER |   |
| 32977 | Go > New Multi | DANGER |   |
| 32978 | Go > New Triaxial | DANGER |   |
| 32979 | Go > New Square | DANGER |   |
| 32980 | Go > New Circle | DANGER |   |
| 32981 | Go > New Teach | DANGER |   |
| 32982 | Go > New Austenite | DANGER |   |
| 32983 | Go > Fit |  |   |

### Menus 150-158 -- differences from menu 148

* **Menu 150 (Elliptical Method (.em))**: 80 commands; additional vs 148: 184 File > New > MET [CAUTION]; 185 File > New > EM [CAUTION]; 32873 File > Open Gain__ [CAUTION]; 32799 Collect > Elliptical Method [DANGER]; 32865 Collect > Continuate later [DANGER]; 32847 Collect > Calculation [SAFE]; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient
* **Menu 151 (Triaxial Method (.tr))**: 90 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export To MET File; 32871 File > Import From Text File > Profile  Gain______ [CAUTION]; 32917 File > Import From Text File > Import from Multi files; 32802 Collect > Triaxial Method [DANGER]; 32801 Collect > Display Results [SAFE]; 32865 Collect > Continuate later [DANGER]; 32885 Collect > Austenite Setup [DANGER]; 32887 Collect > Austenite Parameters_ [CAUTION]; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient
* **Menu 152 (Square Map (.sm))**: 97 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export Curent Point To MET File; 33071 File > Export To Text File > Export Rows; 33072 File > Export To Text File > Export Columns; 33217 File > Export To Text File > Export All Points To MET Files; 33011 File > Import From Text File > Map algebra > Current - ?; 33132 File > Import From Text File > Map algebra > Current + ?; 33131 File > Import From Text File > Map algebra > (Current + ?) / 2; 33130 File > Import From Text File > Map algebra > Reset Map algebra; 32803 Collect > Square Map Method [DANGER]; 32865 Collect > Continuate later [DANGER]; 32847 Collect > Calculation [SAFE]; 33124 Collect > View Map__ > Normal__; 33123 Collect > View Map__ > Sharp 3D__; 32885 Collect > Austenite Setup [DANGER]; 32887 Collect > Austenite Parameters_ [CAUTION]; 32858 Collect > Square Map Parameters; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient
* **Menu 153 (Circle Map (.cm))**: 90 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export to MET file; 33011 File > Import From Text File > Map algebra > Current - ?; 33132 File > Import From Text File > Map algebra > Current + ?; 33131 File > Import From Text File > Map algebra > (Current + ?) / 2; 33130 File > Import From Text File > Map algebra > Reset Map algebra; 32804 Collect > Circle Map Method [DANGER]; 32865 Collect > Continuate later [DANGER]; 32847 Collect > Calculation [SAFE]; 32897 Collect > View Map [SAFE]; 32858 Collect > Square Map Parameters; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient
* **Menu 154 (Teach Map (.tm))**: 92 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export to MET file; 33217 File > Export To Text File > Export All Points to MET files; 32805 Collect > Collect Teach Map [DANGER]; 32834 Collect > Gain__ [DANGER]; 32865 Collect > Continuate later___ [DANGER]; 32893 Collect > Export Map___; 32894 Collect > Import Map___; 32847 Collect > Calculation___ [SAFE]; 32885 Collect > Austenite Setup___ [DANGER]; 32887 Collect > Austenite Parameters_ [CAUTION]; 32858 Collect > Square Map Parameters; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient; 33063 Utilities > Laue
* **Menu 155 (Austenite Method (.as))**: 89 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32834 Collect-- > Gain-- [DANGER]; 32889 Collect-- > Stress and Austenite-- [DANGER]; 32885 Standard Method-- > Setup-- [DANGER]; 32886 Standard Method-- > Calibration-- [DANGER]; 32887 Standard Method-- > Calibration Parameters-- [CAUTION]; 32901 Standard Method-- > Calculate--; 32962 Average Peak Method-- > Average Peak Method- [DANGER]; 33122 Average Peak Method-- > Average Peak Method Mini-Calculator [SAFE]; 57667 Help-- > Help Topics--- [SAFE]; 57664 Help-- > About XrdWin...-- [SAFE]; 32890 Help-- > Wizard Mode-- [SAFE]; 32932 Help-- > Wizard Options-- [SAFE]; 32934 Help-- > Update-- [CAUTION]; 32903 Utilities-- > Stress with depth-- > New--; 32904 Utilities-- > Stress with depth-- > Open--; 32907 Utilities-- > Principal stress determination-- > Model 2D--; 32908 Utilities-- > Principal stress determination-- > Model 3D--; 32877 Utilities-- > Proto Strain--; 32878 Utilities-- > Proto Gradient--
* **Menu 156 (Pole Figure (.pf))**: 91 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export To MET File; 33011 File > Import From Text File > Map algebra > Current - ?; 33132 File > Import From Text File > Map algebra > Current + ?; 33131 File > Import From Text File > Map algebra > (Current + ?) / 2; 33130 File > Import From Text File > Map algebra > Reset Map algebra; 33048 Collect > Collect Pole Figure [DANGER]; 32834 Collect > Gain__ [DANGER]; 32865 Collect > Continuate later__ [DANGER]; 32847 Collect > Calculation__ [SAFE]; 33124 Collect > View Map__ > Normal__; 33123 Collect > View Map__ > Sharp 3D__; 32858 Collect > Square Map Parameters; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient
* **Menu 157 (Single Crystal (.sc))**: 91 commands; additional vs 148: 32873 File > Open Gain__ [CAUTION]; 32767 File > Export To Text File > Export To MET File; 33011 File > Import From Text File > Map algebra > Current - ?; 33132 File > Import From Text File > Map algebra > Current + ?; 33131 File > Import From Text File > Map algebra > (Current + ?) / 2; 33130 File > Import From Text File > Map algebra > Reset Map algebra; 33045 Collect > Collect Single Crystal [DANGER]; 32834 Collect > Gain__ [DANGER]; 32865 Collect > Continuate later__ [DANGER]; 32847 Collect > Calculation__ [SAFE]; 32858 Collect > Square Map Parameters; 32877 Utilities > Proto Strain; 32878 Utilities > Proto Gradient; 33063 Utilities > Laue
* **Menu 158 (Powder Diffraction (.pd))**: 86 commands; additional vs 148: 33066 Collect > Parameters [CAUTION]

The full item list of every menu 128/129/148-158 is in the JSON `menus` array.

### Toolbars

**Toolbar 128** (16x15 buttons):

| pos | cmd | caption | tooltip | RISK | note |
|---|---|---|---|---|---|
| 0 | 32786 | Motors | Init | DANGER | Initialization > Motors: opens dialog 206 (then "Initialization" homes the motors). |
| 1 | 32789 | High Voltage | HV | DANGER | Initialization > High Voltage: opens the HV property sheet (427/428/489). Warm Up / Set turn X-rays on. |
| 2 | - | separator | | | |
| 3 | 32771 | Constants | Constants | CAUTION | Constants: opens the property sheet with pages 112/113/114/111. |
| 4 | 32772 | Background | Peak Fit Limits | CAUTION |   |
| 5 | - | separator | | | |
| 6 | 32791 | Move Motors | Move | DANGER | Initialization > Move Motors: opens dialog 163. |
| 7 | 32896 | Defocus | Defocus | DANGER | Defocus: Z motion. |
| 8 | 32891 | Refocus | Autofocus | DANGER | Refocus: Z motion (autofocus). |
| 9 | - | separator | | | |
| 10 | 57601 | Open... | Open | SAFE |   |
| 11 | 32873 | Open Gain | Open Gain | CAUTION |   |
| 12 | 57603 | Save | Save | CAUTION |   |
| 13 | - | separator | | | |
| 14 | 32847 | Calculation | Calculation | SAFE | Calculation: recalculates the open document from stored data (no hardware). |
| 15 | - | separator | | | |
| 16 | 32923 | Wizard | Wizard | SAFE |   |
| 17 | 57669 | Context Help (ID_CONTEXT_HELP) | Help | SAFE |   |
| 18 | 33218 | (no caption) |   | CAUTION | Toolbar-only command (no menu caption / string found). |

**Toolbar 201** (16x15 buttons):

| pos | cmd | caption | tooltip | RISK | note |
|---|---|---|---|---|---|
| 0 | 183 | SET | Single Exposure | CAUTION |   |
| 1 | - | separator | | | |
| 2 | 184 | Multi | Multiple Exposure | CAUTION |   |
| 3 | 186 | Triaxial | Triaxial | CAUTION |   |
| 4 | - | separator | | | |
| 5 | 187 | Square Map | Square Map | CAUTION |   |
| 6 | 188 | Circle Map | Circle Map | CAUTION |   |
| 7 | 189 | Teach  Map | Sx Orientation | CAUTION |   |
| 8 | 191 | Pole Figure | Pole Figure | CAUTION |   |
| 9 | - | separator | | | |
| 10 | 190 | Austenite | Austenite | CAUTION |   |
| 11 | 194 | (unused document slot) |   | CAUTION |   |

Toolbar 201 holds the "New document" buttons (183 SET, 184 MET, 186 Triaxial, 187 Square, 188 Circle, 189 Teach Map, 191 Pole Figure, 190 Austenite, 194 unknown). Creating a new document is CAUTION (no hardware), but every new document leads to a Collect command.

### Accelerators (ACCEL 128)

Ctrl+N 57600 New, Ctrl+O 57601 Open, Ctrl+P 57607 Print, Ctrl+S 57603 Save, Esc 32768 (ID_CANCEL_EDIT_CNTR), F1 57670 Help, Shift+F1 57669, F6/Shift+F6 pane switch, Ctrl+Ins/Shift+Ins copy/paste, Ctrl+X cut, Ctrl+Z undo. No accelerator starts motion or X-rays.

## 6. Document-type string table entries

| ID | text |
|---|---|
| 128 | XrdWin |
| 129 | XrdWin \n XrdWin \n Default \n Default Files (*.xrd) \n .xrd \n Default.Document \n Default Document |
| 148 | XrdWin \n Single Exposure Technique \n Single Exposure Technique \n SingleExposureTechnique Files (*.st) \n .st \n SingleExposureTechnique.Document \n SingleExposureTechnique Document |
| 149 | XrdWin \n Multiple Exposure Techique \n Multiple Exposure Techique \n MultipleExposureTechnique Files (*.mt) \n .mt \n MultipleExposureTechnique.Document \n Multiple ExposureTechnique Document |
| 150 |   |
| 151 | XrdWin \n Triaxial Method \n Triaxial Method \n TriaxialMethod Files (*.tr) \n .tr \n TriaxialMethod.Document \n TriaxialMethod Document |
| 152 | XrdWin \n Square Map \n Square Map \n SquareMap Files (*.sm) \n .sm \n SquareMap.Document \n SquareMap Document |
| 153 | XrdWin \n Circle Map \n Circle Map \n CircleMap Files (*.cm) \n .cm \n CircleMap.Document \n CircleMap Document |
| 154 | XrdWin \n Teach Map \n Teach Map \n TeachMap Files (*.tm) \n .tm \n TeachMap.Document \n TeachMap Document |
| 155 | XrdWin \n Austenite Method \n Austenite Method \n Austenite Files (*.as) \n .as \n Austenite.Document \n Austenite Document |
| 156 | XrdWin \n PoleFigure Method \n PoleFigure Method \n PoleFigure Files (*.pf) \n .pf \n PoleFigure.Document \n PoleFigure Document |
| 157 | XrdWin \n SingleCrystal Method \n SingleCrystal Method \n SingleCrystal Files (*.sc) \n .sc \n SingleCrystal.Document \n SingleCrystal Document |
| 158 | XrdWin \n PowderDiffraction Scan \n PowderDiffraction Scan \n PowderDiffraction Files (*.pd) \n .pd \n PowderDiffraction.Document \n PowderDiffraction Document |
| 183 | Single Exposure Technique Document \n Single Exposure |
| 184 | Multiple Exposure Technique Document \n Multiple Exposure |
| 185 |   |
| 186 | Triaxial Document \n Triaxial |
| 187 | Square Map Document \n Square Map |
| 188 | Circle Map Document \n Circle Map |
| 189 | LAUE Document \n Sx Orientation |
| 190 | Austenite Document \n Austenite |
| 191 | Pole Figure Document \n Pole Figure |
| 192 | Single Crystal Document \n Single Crystal |
| 193 | Powder Diffraction |

Format of 148-158: `WindowTitle\nDocName\nFileNewName\nFilterName\nFilterExt\nRegFileTypeId\nRegFileTypeName` (MFC CDocTemplate). The current project uses MET documents `*.mt` (e.g. `15OCT26_0007.mt`).

## 7. Who answers what -- rule

* **HUMAN**: every prompt about X-rays, HV, warm-up, shutter, door, interlock, limits, homing, moving, continuing/resuming a collection, aborting, retrying, ignoring errors, collisions, passwords, and any Yes/No whose Yes leads to hardware action.
* **CLAUDE may dismiss**: pure information boxes with a single OK and no hardware consequence (file not found, validation of a typed number, licence messages). Even then: log the exact text and the window handle first, say explicitly in the run log that the box was dismissed, and if the text is not in the table below treat it as HUMAN.

## 8. Message-box / prompt catalogue

| text | likely context | who answers | source |
|---|---|---|---|
| HASP not found ! | Start-up: Sentinel HASP dongle (VID_0529) not detected; XrdWin will not run normally. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x064a254 |
| HASP Device Driver not installed. | Start-up licence check. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x064a18c |
| Can't read from HASP Device Driver. | Start-up licence check. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x064a1b0 |
| Incorrect Password | Login dialog 173 / password dialog 204: wrong password. Claude never types passwords; the human retries. | HUMAN | xrdwin_exe_strings.txt @0x064a268 |
| Cannot delete the admin user | Set the Password dialog (205). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0627b7c |
| Do you want to delete the user %s? | Set the Password dialog (205), Delete user. | HUMAN | xrdwin_exe_strings.txt @0x0627b9c |
| Do you want to change the project with the current one? | Login / Choose Project: project folder switch under C:\XrdWin Data. | HUMAN | xrdwin_exe_strings.txt @0x05fc404 |
| Do you want to change the application's main folder to: %s? | Project path change (registry Projects Path). | HUMAN | xrdwin_exe_strings.txt @0x0640a7a |
| Do you want to load the %s configuration? | Start-up/Initialize: a configuration matching the system serial number was found. | HUMAN | xrdwin_exe_strings.txt @0x0641b9b |
| Cannot find the serial number in the configuration | Start-up/Initialize configuration load. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0641cb8 |
| A new version (%d) is available for download. Do you want to proceed? | Help > Update / start-up update check (network download). | HUMAN | xrdwin_exe_strings.txt @0x06425c8 |
| Cannot open the language file! | Start-up language resource. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0640b54 |
| Simulation-Enabled. | Start-up when registry Simulation=1 (it is 0). Means hardware I/O is faked; README: no safe simulation mode. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0617014 |
| Initialization - in progress ... | Status text in dialog 206 while InitializeThread runs (motors homing). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0641b08 |
| Cannot detect Motor's serial port. | Initialize: AutoScanPorts could not find the RS-485 motor port (COM9). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0615088 |
| Cannot detect Power supply's serial port. | Initialize: Spellman HV COM1 not found. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x06150f4 |
| Cannot detect TRILOGI_PLC's serial port. | Initialize: safety PLC port (COM8) not found. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0615154 |
| Error: Cannot open Power supply's COM port | Initialize / Set HV: COM1 open failed. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x060b0cc |
| Trilogi PLC communication error. | Initialize: PLC (shutter/interlock) not answering on COM8. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x060b0f8 |
| HV communication error. | Initialize / Set HV: Spellman supply not answering. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0641900 |
| Communication error. Power supply is not in Remote mode. | Set HV / warm-up: supply in Local mode (front panel). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x060a198 |
| Power supply error.(FaultCondition) | HV fault reported by the supply. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x060a014 |
| %s: Cannot read the 0 position.(pos=%.2lf, head:%d, axis:%d) | Initialize: homing did not end at 0 (seen 15 Oct 2026 for the Beta axis, pos=2.23 / -2.25). Logged, may be shown. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0641e50 |
| End of travel (limit sensor) has been reached. | Motion: a limit switch was hit (seen 1 Oct 2026). Motion stops. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0642ec8 |
| Z axis limit sensor was reached. | Autofocus / Z motion hit its limit. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0647ab8 |
| The door is open. | Interlock: enclosure door open; collection/motion refused ("Don't move if door open" option). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x06274d0 |
| System not initialized | Move Motors / Collect requested before Initialize. Next step would be Initialize (homing) - human decides. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x061a9b8 |
| The beta motor will be homed. Are you sure? | Home Beta command (dialogs 442/545, Nitride/Average Peak) - motion. | HUMAN | xrdwin_exe_strings.txt @0x06136d8 |
| Beta is not in zero. Do you want to move Beta to zero? | Before a collection / Beta=0 button in MoveMotors (163) - motion. | HUMAN | xrdwin_exe_strings.txt @0x0659ea4 |
| X, Y motors are not at 0, do you wish to set the current position to zero? | MoveMotors XY=0 / map start - redefines zero. | HUMAN | xrdwin_exe_strings.txt @0x05fafb8 |
| Do you want to move Phi to %.2lf? | Collection with phi angles - motion. | HUMAN | xrdwin_exe_strings.txt @0x0644cb4 |
| Encoder motor %s is out by %d (%.4lf degrees). Do you want to continue? | Motion check after a move: encoder mismatch (possible slip/collision). | HUMAN | xrdwin_exe_strings.txt @0x0643724 |
| The head will go down %.1lf mm. Continue? | Autofocus/Refocus: Z motion towards the sample (collision risk). | HUMAN | xrdwin_exe_strings.txt @0x0646b48 |
| Possibly due to surface geometry, the sensor cannot read the position(1). Continue? | Autofocus laser could not read; continuing moves Z blind. | HUMAN | xrdwin_exe_strings.txt @0x0646d68 |
| Backlash is negative. The system should have been initialized in the first point. Continue measurement? | Collection start without proper initialization. | HUMAN | xrdwin_exe_strings.txt @0x05fb004 |
| The Full system must be enabled in order to change the motor configuration. Do you want to enable it? | User System Configuration (335): motor configuration change. | HUMAN | xrdwin_exe_strings.txt @0x0618900 |
| The limit sensors have not been written.(otherwise press CTRL) | Write Controller (335) / motor setup. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0619850 |
| Unable to write new configuration. Please check hardware. | Write Controller / Osc Prog failed. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x062de04 |
| Do you want to write the new osc. program? | Osc Prog / Fix Bad Osc: writes to the motor controller. | HUMAN | xrdwin_exe_strings.txt @0x062df44 |
| XRayEnable is not set. (Press the button). Do you want to continue with x-rays? | Dialogs 546 (Yes/No) and 553 (Yes/No/Cancel): the front-panel X-Ray Enable button is not pressed when Warm Up / Set HV / Collect wants X-rays. Also shown as a MessageBox from PowerSupply_SetXRayON / ReadXRay. | HUMAN | xrdwin_exe_strings.txt @0x0609bb8, @0x060a530; dialogs 546, 553 |
| WARNING: Safety Interlocks are bypassed for warm-up procedure and x-rays are being generated. Ensure device is properly installed in warm-up carriage. | CDlgHVWarm (427/164) when Warm Up starts. | HUMAN | xrdwin_exe_strings.txt @0x06243cc |
| Warm-up done | End of the warm-up (sound/message, dialog 334 "Sounds"). X-rays go off per software; confirm at the beacon. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | XrdWin.strings.txt @006994d6 |
| Cannot set HV. | Set HV / warm-up: the supply rejected the setting. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0609e00 |
| Cannot set a voltage value smaller than 5 kV. | Set HV input validation. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x060878c |
| XRays are OFF. Do you want to recollect? | Collection: X-rays found off during an exposure (AutoRetryCollXRayOff). Yes = X-rays on again. | HUMAN | xrdwin_exe_strings.txt @0x06458e4 |
| XRays are not set. | Collection could not switch X-rays on. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x06242a8 |
| XRays are ON. / XRays are OFF. | Status messages from the shutter/HV configuration page (188/335). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x061a9d0 |
| OpenShutter FAILED / CloseShutter FAILED | Shutter command to the PLC failed (seen in logs as PLC_Read: WriteFile failed). | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x061a8e0 |
| XRay OFF : error in Status PLC_SetXRayoffRelay(); | Software X-ray-off failed (seen 23/28 Sep 2026 in 09-2026.log). X-rays may still be ON: human checks beacon/front panel. | HUMAN | xrdwin_exe_strings.txt @0x05fe004 |
| Auto XRay Disable. | XRayDisable option active: ReadXRay/shutter checks disabled. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x062d9e8 |
| Ready for collection? | Dialog 221 caption; OK starts motion + X-rays. The human presses OK. | HUMAN | dialog 221 |
| Push OK to continue collection. | Dialogs 291/432: paused measurement (after Stop > No, or Continuate later) waiting to resume at the second-to-last angle. | HUMAN | dialogs 291, 432; XrdWin.strings.txt @00697046 |
| For this angle is a fitting error | Dialog 326 Abort / Ignore / Retry during a collection (suppressed only by "Ignore error warnings"). | HUMAN | dialog 326; xrdwin_exe_strings.txt @0x0697962 |
| Possible bad fitting for Beta[%d], detector %d. | Collection/calculation warning. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0610bf4 |
| Oscillation error. Do you want to recollect? | Collection: beta oscillation failed; Yes re-exposes. | HUMAN | xrdwin_exe_strings.txt @0x0645930 |
| Do you want to continue - line %d (YES) or restart the measurement(NO)? | Resuming a Teach Map / multi-point run. | HUMAN | xrdwin_exe_strings.txt @0x064c5c8 |
| Do you want to continue? | Generic continue prompt in collection threads. | HUMAN | xrdwin_exe_strings.txt @0x0643d61 |
| Check the cables. Do you want to retry? | Detector (MiniPIX bridge) read failed; Retry re-exposes. Today the detectors are ABSENT from USB. | HUMAN | xrdwin_exe_strings.txt @0x0604d61 |
| PCCARD: error :Check the cable and if the detector is powered | Detector not reachable. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x0607094 |
| Cannot communicate with the robot connect | Robot/handling option not present; appears if misconfigured. | HUMAN (information box, but it reports hardware / X-ray / interlock state) | xrdwin_exe_strings.txt @0x05fda90 |
| det1 or det2 must be on the right side of the X-Ray tube. | Detector geometry validation in constants. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0628b8c |
| You need to set the beta angles according with the current detector. | Constants validation. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0628b44 |
| Check beta and oscillation values. Limits exceeded. | Collection Constants / Beta Angles validation (beta + osc > MaxBetaAngle). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0613c54 |
| Nr of Exp: Limits exceeded. | Collection Constants validation. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0613c88 |
| Cannot find the gain file. | Collect/Calculate: gain file missing for the material. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x05fb408 |
| Do you want to collect a new gain? | Collect: gain missing or old; Yes starts a gain collection (X-rays). | HUMAN | xrdwin_exe_strings.txt @0x06495d1 |
| Do you want to import gain? | Collect: import gain from another file (no hardware). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0640e44 |
| Do you want to overwrite? | Saving a document over an existing file. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0649728 |
| File read-only. Do you want to change the attribute? | Saving a document. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x064a02c |
| Cannot Open %s, error=%d | File open failed (project/data file). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0648d5c |
| You didn't set your material. Are you sure you want to go to the next step? | Wizard mode step check. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0626d34 |
| You didn't focus. Are you sure you want to go to the next step? | Wizard mode: autofocus not done; the next step may collect. | HUMAN | xrdwin_exe_strings.txt @0x0626d80 |
| Do you want to change NrPhiAngles? | Beta Angles page (111). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x061ec8c |
| Do you want to reset the list? | Beta Angles page (111) list reset. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x06200f8 |
| Do you want to delete material %s ? | Material Chart (114) Del Material. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x0628ab4 |
| Do you want to proceed? | Generic confirmation in constants / calculation code paths. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | xrdwin_exe_strings.txt @0x061c9d6 |
| Do you want to ask you next time? | Checkbox-style follow-up after a confirmation. | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | XrdWin.strings.txt @068430e |
| Stop > "abort (Yes) / pause (No)" | After Stop in Online Data (286) the manual (p.106-107) describes a Yes/No box: Yes aborts, No pauses for "Continuate later". Exact text not found in the string dumps. | HUMAN | xrdwin_manual.txt p.106-107 |
| If the X-ray Lock key is not turned, the following message will come up | Manual p.38: key-switch-off message at collection start (image only; text not in dumps). | HUMAN | xrdwin_manual.txt p.38 |
| Wait, please... | Busy string (string table 61448). | CLAUDE may dismiss (pure information; log the text first). If in doubt, HUMAN. | string table 61448 |

## 9. Cross-check of the sources and what could not be found

* All 18 requested dialog IDs (173, 206, 427, 428, 489, 221, 286, 326, 546, 112, 113, 114, 111, 163, 335, 538, 559, 491) **were found** in the EXE resources and in both text dumps. **No requested dialog ID is missing.**
* Dialog 206 exists twice (lang 1033 and 1041/Japanese, identical controls); 538 and 559 exist only as lang 4105 (en-IN). The 1033 copy is used here where available.
* `xrdwin_resources.txt` (peres.py) matches this parse control-for-control for every requested dialog; the only difference is that it prints the "-1" static ID as 4294967295 where this document uses 65535 (same control).
* `resources_xrdwin.txt` (binary variant) omits every control whose text is empty (all EDIT boxes, combos, list boxes, progress bars) and icon statics, so it under-reports the controls; it agrees on every control it does list.
* Neither dump contained styles or rectangles; those come from re-parsing the DLGTEMPLATE(EX) records with `tools\xrdwin_res_full.py`.
* Not found anywhere as text: the "abort (Yes) / pause (No)" box after Stop and the "X-ray Lock key is not turned" box (manual p.38, p.106-107 show them only as images). Toolbar command 33218 has no menu caption or string. Command 194 on toolbar 201 has no caption (slot for an unused document type).
* String table IDs for the Initialization menu (block 2050): 32786 "Initialize the motors\nInit", 32789 "Set High Voltage\nHV", 32791 "Move Motors\nMove" -- these are the toolbar tooltips / status-bar prompts.

Files: `prep\XRDWIN_DIALOGS.md` (this file), `prep\xrdwin_dialogs.json` (machine-readable, same data plus every control of the keyword-scan dialogs), `tools\xrdwin_res_full.py` (read-only extractor), `tools\build_xrdwin_dialogs.py` (this generator).
