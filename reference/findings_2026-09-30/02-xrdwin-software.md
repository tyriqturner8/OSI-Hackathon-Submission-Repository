## XrdWin software: workflow, menus and automation features

**Key points**

- XrdWin is a menu-driven Windows program (Microsoft MFC, one window per "document"). The standard stress workflow is: log in, **Initialize** (motors home), **High Voltage** warm-up (7 or 15 min), focus, set **Constants**, test profile and **Gain** in a Single Exposure document, then run a **Multiple Exposure** (sin²ψ) document, fit and save/export. The 2010 manual still describes this well, but the installed build (2.0 build 87, file dated 2024-11-18) has many menus and options the manual does not mention.
- XrdWin already has its own sequencing tools: tilt series (up to 30 β × 10 φ angles), square, circle and cylindrical maps, **Teach Map** point lists (importable `.map` files), **Inline measurements** (repeated QC runs), **Batch Processing** (offline re-calculation and export), pause/**Continue later**, and constants templates.
- We found **no external control interface** in XrdWin. It registers no command-line/DDE open action, has no COM automation type library, and its direct socket imports are client-only. The manual's "Remote Control" chapter only describes Laplink screen-sharing for Proto service staff. Internal TCP-client hooks for robots, ISTL, IO-Link and a "Client/Server" module exist, but they are switched off or their helper programs are missing.
- In practice Claude has two options: (1) supervised GUI operation (menu commands have stable IDs, but many modal prompts block progress), and (2) **read-only use of outputs**: documents named `DDMMMYY_NNNN.ext` under `C:\XrdWin Data\...`, text exports, and plain-text logs in `c:\Xrdwin Log Files` (including a per-measurement X-ray exposure log).
- The software safety layers (login, front-panel X-ray Enable, auto X-ray-off, X-ray checks with auto-retry, fit-error prompts, motor limits) help, but they are **not a guaranteed barrier**. The September 2026 event log records failed X-ray-OFF relay writes to the PLC.

**Citation keys.** M = 2010 manual text `sw-manual\xrdwin_manual.txt` (manual page numbers). R = menu/dialog resources extracted read-only from the installed `XrdWin.exe` into `investigation-2026-09-30\_synth\software\xrdwin_resources.txt` ("dlg" = dialog ID); I = its import table (`...\_synth\software\xrdwin_imports.txt`). Reg = `registry-config\parsed_live_hkcu.txt` line number. GS = Proto XRD Guide Sheet (`other7.txt`); SE = Single Exposure and Gain Reference (`other8.txt`). Log = `c:\Xrdwin Log Files\<file>`.

### Sources used

The other software guides in `D:\Manuals\Software` were matched to their text dumps by content:

| Text file | Guide (PDF in D:\Manuals\Software) | File date |
|---|---|---|
| other1 / other2 | Austenite – Average Peak Method MiniCalculator; *Automated* Austenite – same | 2009 |
| other3 | Gradient and Depth correction | 2008 |
| other4 / other5 | How to Add a New Material; How to Add Material from the Database | 2010 / 2009 |
| other6 | Multiple Exposure Reference | 2008 |
| other7 | Proto XRD Guide Sheet (written for an LXRD2000) | 2012 |
| other8 | Single Exposure and Gain Reference | 2008 |
| other9 | Alignment + Calibration\Auto Focus Calibration | 2012 |
| other10 | Measurement Parameters Guide\Materials-Anode Quick Reference | 2021 file (chart © 2000) |
| other11 / other12 | Suggested Collection Constants; Suggested SAMPLE Collection Constants (LXRD, Cr 60 mm tube) | 2012 |
| other13 | Target choices for residual stress | 2008 |
| (hw-manual\warmup.txt, alignguide.txt) | System Initialization and Target Warm up; Proto XRD Alignment Guide | 2009 / 2012 |

All the guides are 2008–2012 documents written for LXRD/iXRD systems with the older 512-channel detectors. None mentions the iXRDmini or the MiniPIX detectors.

### 2010 manual vs the installed 2024 build

| Topic | 2010 manual | Installed XrdWin.exe 2.0.87.17353 |
|---|---|---|
| Document types | SET, MET, Triaxial, Square Map, Teach Map, Austenite (M p.6) | Adds Elliptical (.em), Circle Map (.cm), Pole Figure (.pf), Single Crystal (.sc), Powder Diffraction (.pd) (R string table 148–158) |
| File names | "SET/MET… + date + index" (M p.7) | Actually `DDMMMYY_NNNN.ext`, e.g. `20SEP26_0014.mt`. The day counter is kept in the registry (Reg 11519–11520 LastData/LastIndex) |
| Exposure log | In the Program Files folder (M p.115) | Now `c:\Xrdwin Log Files\ExposureXRay_MM-YYYY.log`, alongside event logs `MM-YYYY.log` and `MM-YYYYDebug.log` (directory listing) |
| New menu items | – | File > **Batch...**; Export > 2Theta / Setup XLS/XML/CSV / Export All Points To MET Files; Collect > **Quick gain**, **Multi gain**, Setup Nitride; Help > **Simulate**, Update; Utilities > Inline Measurements, Expert System, Camera, Alignment Camera, Database, ISTL, Laue, Blade Loading, XRDWIN Utility (R menus 148–157) |
| Detector config | 1–2 (up to 8) linear detectors | Camera/MiniPIX "Parameters" dialog: Start Server, Python Path, Script Path, Get Serials, Threshold, Bias, ToT/T3pa/Event (R dlg 559). Details are in the detector section |
| Menu captions | "Set-up Parameters", "System" | Resources contain both "Constants"/"Initialization" and "Set-Up Parameters"/"System" captions. The language files (`lang1-5.dat`) may rename them at run time (inferred). **Command IDs are the same either way.** |

### Standard measurement workflow (step by step)

Menu names are given as in the 2024 build; names in [brackets] are from the 2010 manual.

| # | Step | What the operator does in XrdWin | Notes / evidence |
|---|---|---|---|
| 1 | Power up | Main Power On; check that the cooling fan is running and water is flowing | M p.26 (the iXRDmini procedure may differ, inferred) |
| 2 | Start, log in | Launch XrdWin; **User** dialog asks for name + password and shows the current project; **New Project** button | A Single Exposure document opens automatically (M p.25–26; R dlg 173). The Guide Sheet prints a default admin login (not reproduced here) |
| 3 | Project folder | File > New Project / Choose Project / Set current project | Current data folder: `C:\XrdWin Data\24193-24172T\Donovan Cr Tube` (Reg 11518) |
| 4 | Initialize | Left toolbar **Initialize** ("Init"), or System [Initialization] > Motors, opens **Motors Initialization** > *Initialization* | Opens COM ports and homes axes (HomingAxis9and10InInit=1, Reg 2892). The dialog warns about collision damage. Other buttons: COM Port, Reset Error, Reconfigure, Stop, Home this/all axis. Not needed just to review stored data (M p.20–21, 27; R dlg 206) |
| 5 | X-rays, warm-up | Press the front-panel **X-ray Enable** button. Toolbar **HV** / System > High Voltage > **Warm Up** tab: *7 min* ("if the tube has been used in the last week") or *15 min*; also *Conditioning*; then Warm Up/Start. Check the Tube(s) tab | X-rays switch on only during warm-up or a collection (M p.21, 28, 36; R dlg 427; warmup.txt). Last warm-up was 20 Sep 2026 15:51 (Reg 11521) |
| 6 | Focus | Manual pointer + System > **Defocus**, or System > **AutoFocus** [Refocus] with the autofocus pointer and the pendant Teach button | Default defocus is 20 mm. Recalibrate autofocus at least every 3 months (M p.30–35; other9) |
| 7 | Set constants | Set-up Parameters [Constants] > **Constants** (tabs: Collection, Fitting, Material Chart, plus Beta and Phi Angles in multi-angle documents); **Background** = Peak Fit Limits (ROI) | See next table (M p.8–14) |
| 8 | Test profile | Single Exposure > Collect > **Profile** opens **Ready for collection?** (Description, Job/Part/Lot/Internal/Segment No., Direction, Depth), then OK | Check that peaks are not saturated and are centred (move the detector with Move Motors). Set background/ROI by clicking the plot. Re-collecting overwrites (M p.36–39; SE; GS §2.3–2.5; R dlg 221) |
| 9 | Gain | Place the gain shim. Collect > **Quick gain**, adjust gain kV by ±2–4 kV until it matches the profile background, then Collect > **Gain** (about 4× the profile exposures) | The gain carries over to the next document and is also saved as its own file (M p.40–42, 46; GS §2.6; SE p.7–9) |
| 10 | Stress run | Check the safe tilt range with Move Motors (Guide Sheet: max 33°, set max β 3° below the safe angle). Open a **Multiple Exposure** document, then Collect > **Multiple Exposure Technique**, check the Beta and Phi Angles tab, enter a description, click OK | Runs unattended: β steps (with oscillation), a profile is shown after each tilt, and it ends with the d vs sin²ψ plot and stress report. MET documents are auto-saved (M p.45–48; GS §3; other6) |
| 11 | Analysis | Right-click a profile (fit method, correction, View Data/Results/Angles). Right-click sin²ψ (Linear ψ, Elliptical, Linear χ, Elliptical χ, Triaxial). Collect > **Calculation**; powder correction | A stored document can be re-fitted but never re-collected (M p.89–101, 111–113; R menus 193, 198) |
| 12 | Save / export | File > Save / Save As; File > **Export To Text File** (Profile & Gain, Profile & Gain (2Th), Profile, Gain, 2Theta); right-click the report > Copy To Text / Excel / Word; File > **Batch...** | Single Exposure documents are not saved unless you save them (M p.6, 101, 108–110; R menus 149, 199; dlg 491) |
| 13 | Shut down | X-rays off; let the tube cool 10 min before powering off; home the motors (Move Motors > Move to "0") | GS §3.10; M p.22 |

Other built-in procedures follow the same pattern:

- **Retained austenite:** the Standard method uses ≥2 standards and "Collect Standards/Samples"; the Average Peak method uses 4 peaks, M(211) 156°, A(220) 128°, M(200) 106° and A(200) 79° with a Cr tube (M p.69–88).
- **Triaxial:** ≥3 φ angles (M p.50–55).
- **Maps:** see the automation table below.

### Main window, menus and dialogs (reference for a GUI script)

**Window layout** (M p.5 screenshot):
- top **quick-launch bar**: Single Exposure, Multiple Exposure, Triaxial, Square Map, Circle Map, Teach Map, Pole Figure, Austenite;
- **left toolbar**: Initialize, High Voltage, Constants, Peak Fit Lim., Move Motors, Defocus, Autofocus, Open, Open Gain, Save, Calculation, Wizard, Help (R TOOLBAR 128/201);
- **status line** showing Laboratory/Portable, Psi/Chi geometry and live Voltage/Current;
- two detector plot panes per document.

The plot panes are custom-drawn, so an automation tool cannot read peak data from the screen. Read the files instead (inferred from the class names in the debug log).

| Menu | Key commands (resource command ID) |
|---|---|
| File | New > SET 183, Multi 184, EM 185, Triaxial 186, Square 187, Circle 188, Teach 189, Austenite 190, Pole Figure 191, Single Crystal 192; Open 57601; Open Gain 32873; Save 57603; Save As 57604; Export To Text File 32867–32870, 33079; Import 32871–32872, 32902, 32917; Choose Project 32874; New Project 32880; Set current project 33068; **Batch... 33050**; Choose New Password 32895; Send 57612 |
| Set-up Parameters [Constants] | Constants 32771; Background (Peak Fit Limits) 32772 |
| Configuration | System (User System Configuration) 32773; System Config 32921 (password, "reserved for Proto personnel", M p.20); Save Configuration 32792; Options 33075 |
| System [Initialization] | Motors (Initialize) 32786; High Voltage 32789; Move Motors 32791; Refocus/AutoFocus 32891; Defocus 32896; Calibration 35000 |
| Collect (varies by document) | Profile 32838; Gain 32834; Quick gain 33070; Multi gain 33078; Multiple Exposure Technique 32800; Elliptical Method 32799; Triaxial Method 32802; Square Map Method 32803; Circle Map Method 32804; Collect Teach Map 32805; Export/Import Map 32893/32894; Square Map Parameters 32858; **Continue later 32865**; Calculation 32847 |
| Help | Help Topics; Wizard Mode 32890; **Simulate 32987**; Update 32934 |
| Go (voice-command menu) | Initialize 32967, High Voltage 32968, Autofocus 32969, Defocus 32970, Move Beta/Phi/X/Y/Z 32971–32975, New Single…New Austenite 32976–32982, Fit 32983 |
| Tray-icon menu (inferred) | Reset Error 33200, Open Log File 33201, Hardware configuration 33202, Client/Server 33203, Find 33204, Check/Download Updates (R menu 338). Identified as the tray menu because M p.114 describes finding documents from the tray icon |

These IDs are read from the executable's resources (verified). Nobody has tested whether sending them to the running program (e.g. as a Windows `WM_COMMAND` message) behaves exactly like clicking the menu (inferred).

| Dialog (R dlg ID) | Purpose and main controls |
|---|---|
| Motors Initialization (206) | Initialization, COM Port, Reset Error, Reconfigure, Stop, Exit; Home Motors: Home, axis list, Home this axis / Home all axis, Home Det. Axis in Init. |
| High Voltage: Set HV (428) / WarmUp (427) / Tubes (489) | SetProfile / SetGain (kV, mA), **X-Ray ON / X-Ray OFF**, To Max, Present Settings; warm-up 7/15 min or Conditioning; kV/mA per target for warm-up and gain |
| Collection Constants (112) | Exposure time and number of exposures per detector (profile, gain), Lock; β, φ, X, Y positions; Oscillation (β, φ, X, Y); Motor Limits; Motor Home Pos; Aperture; Stress & Austenite (RM/RA) |
| Fitting Constants (113), Material Chart (114), Beta Angles (111) | See parameter table |
| Ready for collection? (221) | Description plus traceability fields; summary of exposure/fit/material/angles; Detector Angle / Move Det.; Austenite Percentage; OK/Cancel. **Shown before every collection** |
| Online Data (286) | The progress window shown during collection (called "Data Collection" in M p.106): live β, φ, X, Y, Z, Rho, Stress, Shear, Error, FWHM, Breadth, exposure time and count; **Stop**; Results; Motor Positions |
| MoveMotors (163) | Head & Axis, Value, Move, Move to "0", Stop, Refocus, OscTest, Z=0, XY=0, Beta=0, Phi=0 |
| Message (326) | "For this angle is a fitting error": Abort / Ignore / Retry |
| User System Configuration (335) | Open/Close Shutter, ActiveDet1–8, Psi vs Chi (standard/modified) geometry, Laboratory/Portable/Auto, R0, AutoXRayOff, XRayDisable, Quick Autofocus, defocus distances, Oscillation Test Enabled, HV Control Local/Remote, Disable Phi Limits |
| Options (538) | Check for X-Ray, Auto-Retry Coll XRay OFF, AutoXray in CollectThread, Init in CollectThread, AutoScanPorts, TryRecoveryCOMPorts, SoftwareAutoCorrect, Voice Recognition Menu |

### Measurement parameters

Vendor guidance comes from 2008–2012 guides for older LXRD/iXRD detectors. The "current" column shows what the registry and logs say this PC actually uses.

| Parameter | Where set | Options | Vendor guidance | Current on this PC |
|---|---|---|---|---|
| Exposure time (s) | Collection Constants | per detector, Lock | 0.3–2 s; background >2000 counts, peak <20 000 (detector max ~22 000) (other11/12; GS §2.4) | **60 s** (Reg 2715 ExpTimeDet1) |
| Exposures, profile / gain | Collection Constants | per detector | profile 10–20; gain ≈4× profile | 1 / 1 (Reg 2754, 2762) |
| β tilts | Beta Angles tab | 1–30 angles, Automatic (even sin²ψ steps) or Manual, Max β, Reverse, Save/Load angle sets, Multi Gain, Homing after collection / after each φ, Chi Method | 7–11 tilts, max 20–30°. The list includes the ψ=0 angle for each detector, β = ±(180°−2θ)/2 (M p.47, 102) | 11 tilts, max 30° (Reg 67–70). A 2025 report lists β 0, ±13.6, ±20.67, 30 |
| φ angles | Beta Angles tab | up to 10; triaxial needs ≥3 (0/45/90 or 0/60/120) | M p.13, 51 | – |
| Oscillation | Collection Constants | on/off and range per axis (β, φ, X, Y) | M p.8 | β on, 3° (Reg 2781–2783) |
| kV / mA | High Voltage (profile and gain set separately) | software limits MaxKV 25, MaxmA 2, MaxKW 0.05 (Reg 11262–11264) | 25–30 kV and 5–30 mA for older tubes; 16 mm tubes nominally 18 kV / 2 mA (M p.28–29) | Sep 2026 runs: **18 kV / 1.00 mA** (Log ExposureXRay_09-2026) |
| Aperture | Collection Constants (only a text label) | – | 1 mm round (low-stress standard), 2 mm, 0.5×3 mm slot parallel to the β axis (other11/12) | 1 mm or 2 mm (exposure log) |
| Peak fit | Fitting Constants | Parabola, Gaussian, Cauchy, Pearson VII, Mid Chord, Centroid, Centered Centroid, Modified Lorentzian; % of peak used; Two-peak Kα1/Kα2; Kα strip | ≥50 % for functions, 60 % for chord, 30 % for parabola (M p.9) | e.g. Gaussian 85 % in a 2025 report (`RV2\08JUL25_0012exportsetup.txt`) |
| Peak shift, corrections | Fitting Constants | Absolute Peak / Cross-correlation / Difference; P/G, P−G, none, P/G(s); No LPA / LPA 1 / LPA 2; Auto Remove Bad Points; background linear/parabola; Ignore error warnings; Powder Correction | P/G for stress, P−G required for austenite (M p.10) | Ignore error warnings is OFF (Reg 2967) |
| Material / XEC | Material Chart | radiation, material, ½S₂ and S₁ or E/(1+ν), MPa/ksi, filter, database import | other4/5 | – |
| Background / ROI | Background (Peak Fit Limits) | static/dynamic limits and ROI, channels 10–500 | set in flat regions outside the peak (SE p.5) | 256-px MiniPIX: whether the channel numbers mean the same thing is untested (see open questions) |

### Built-in sequencing and "automation" features

| Feature | What it does | Status here / relevance |
|---|---|---|
| Multiple Exposure, Elliptical, Triaxial | Automatic tilt series (and φ rotation); pauses between tilts only for prompts | Main workflow; runs without further clicks once started (M p.45–53) |
| Square / Circle / Cylindrical map | Grid in X-Y (or circle, or rotation about the Rho axis). Per-point method SET/MET/EM/Triaxial; Z Position Calculation (autofocus every point); curved-surface normal correction; Snake Y; Home X/Y after; Auto X-Ray Shut Off; Ignore prompt errors; stress **Alarm** min/max; Import Z coords / Load Profilometer File | Real multi-point automation (M p.55–63; R dlg 167, 485, 482) |
| Teach Map | List of X, Y, Z, Phi, Rho points taught with the pendant, plus a **PointAction** column (2024 only). "Create New Script", "Load empty list" (type coordinates), Export/Import `.map`, Sphere generator, Refocus 5 times | The closest thing to a user-written measurement script. 182 `.map` files exist in `C:\XrdWin Data` (M p.64–68; R dlg 486) |
| Austenite MiniCalculator **Auto** | Collects all 4 peaks automatically when the detector arc is motorized | other1/other2 |
| Inline measurements | Repeats measurements by Nr of Samples, Time running or Non stop, at a set time interval; upper/lower limits, pass/fail counters, alarms, Excel formula cells | QC mode. Defaults in Reg 11365–11427 (NrSamples=100, TimeRunning=60) (R dlg 328) |
| Batch Processing (File > Batch...) | Load many documents: Calculate, write Text/Word/Excel reports, export Profile/Gain/2θ, convert ksi↔MPa | Offline and safe (no hardware). Useful for bulk export (R dlg 491) |
| Continue later / resume | Stop, then "No" pauses; resume later, even after restarting the program; it re-collects from the second-to-last angle | M p.106–107 |
| Templates | Save/Load sets of collection and fitting constants | M p.18; R dlg 336 |
| Simulation | Help > Simulate makes synthetic profiles (stress, shear, noise, spikes, background, peak shape). Motors dialog has "Simulation" / "Sim Motors" | Off (Reg 11527–11528 Simulation=0, SimulationInit=0). Probably password-protected, judging from a "Simullation Password" value (Reg 35) (inferred). Could make a hardware-free dry-run environment, but only with Proto's guidance (inferred) |
| Wizard, voice "Go" menu | Microsoft Agent character guide; one-click commands | M p.23–24; R menu 148 |
| External hooks | Siemens/AB robot TCP client (plain-text commands such as `movex`, `movebeta`, `isInPosition`, `startcycle`, logged to `logrobot.txt`); **Client/Server** module ("needs server.exe"); **ISTL** (Server, Port, Part/Serial/Cycle number); IO-Link (`iolink.bat` → `tcpserverFT10RTA_IO_Link.py`) | All off or incomplete: bUseSiemensRobot=0, bUseABRobot=0 (Reg 11193–11194); no server.exe; ISTL key empty (Reg 11431); IO-Link script absent. Like the MiniPIX link, XrdWin is always the **client** of a local helper server, sending `<cmd>;xrdwin2;` (`pixet-detector\XrdWin.strings.txt`, offsets 0x604b10–0x6575d0) |
| Update / Send | FTP update check (WinINet FTP imports; Update dialog with server/user/password) and e-mail Send | I; R dlg 102 |
| "Remote Control" | Laplink remote-desktop session so Proto can diagnose the system | Not a programming interface (M p.115–116) |
| Command line / DDE / COM | – | Nothing registered: `HKCR\.st` and `.mt` only carry an "XrdInfoTip" shell extension, with no open/ddeexec verb. No type-library resource. OLE imports are only CoInitialize/CoCreateGuid (Office "Copy to Excel/Word" makes XrdWin a COM *client*, inferred). Socket imports have socket/connect/send/recv but no bind/accept (I). MFC socket classes could still listen, but XrdWin was not running at 15:20 today, so no live port check was possible |

`ClientApp.exe` (2022, .NET) looks like a developer test client for a "TCPService" Windows service (camera/Laue image functions, robot-cell commands such as `movegrab;` and `movexray;`). No such service is installed (Get-Service), so it has no role here (inferred).

### Files and logs written

| What | Name / location | Evidence |
|---|---|---|
| Documents (binary) | `.st` (single exposure), `.mt` (MET), `.em`, `.tr`, `.sm`, `.cm`, `.tm`, `.as`, `.pf`, `.sc`, `.pd`, named `DDMMMYY_NNNN.ext` in the project folder. Counts in `C:\XrdWin Data`: 1265 .mt, 214 .st, 184 .tm, 19 .sm, 10 .as, 2 .tr | R strings 148–158; directory scan |
| Gains and text exports | `.Gain` (multi-gain `…M.Gain`), `.Profile`, `.ProfileGain`, `_2th_.ProfileGain`, `.xye` and `_xrdwin.xye`, `…Data1Phi0.txt` (per φ), `…exportsetup.txt` (report header with all settings) | directory scan |
| Map data | `…DataMapTM_x_y.s3d` (point number, X, Y, Z, stress), `.map` (teach coordinates), `…backup.txt` (X Y Z point lists) | files read |
| Reports | `.xls`, `.doc`, 226 `.pdf` (printed reports, inferred) | directory scan |
| Logs | `c:\Xrdwin Log Files\ExposureXRay_MM-YYYY.log`: one line per document with start, end, duration, target, kV, mA, aperture, user. Also `MM-YYYY.log` (events/errors), `MM-YYYYDebug.log`, `text11.txt` (constantly written serial register trace, inferred) and `retry_reason.txt` in the install folder | files read |
| Settings | `HKCU\Software\Proto Manufacturing Ltd\XrdWin` ("Save Configuration" writes it automatically, M p.20) | Reg |

### Software safety behaviour

- **Access and collision:** Login is required, and accounts are created by the manager (M p.113). The Initialization dialog warns "possible to damage equipment by collision", and initializing moves the axes (Reg 2892). The Guide Sheet asks for a manual tilt-clearance check before every MET (GS §3.3).
- **X-ray enabling:** X-rays need the front-panel X-ray Enable button and only switch on during warm-up or a collection. XrdWin shows prompts when X-rays are off, when X-ray Enable is not pressed, or when the key is not turned (M p.36–38). A 2024 dialog asks "XRayEnable is not set… continue with x-rays?" (R dlg 546). **An automation script must never answer these prompts itself.**
- **Automatic X-ray off and retry:** AutoXRayOff=1 turns X-rays off at the end of a measurement. The optional "X-ray Disable" setting requires a manual re-enable at the front panel (M p.15–16). CheckForXRay=1 and AutoRetryCollXRayOff=1 with AutoRetryCount=3 (Reg 2817–2828) mean XrdWin can repeat a collection on its own. `retry_reason.txt` records XRayRetry and FitErrorRetryCollect events (2025–2026).
- **Interrupting a run:** A fitting error opens Abort/Ignore/Retry (can be suppressed by "Ignore error warnings", currently off). Stop in the progress window gives the choice abort (Yes) or pause (No) (M p.106–108).
- **Limits and door:** Motor Limits and Home positions are user-definable, and there is a "Disable Phi Limits" option. Limit-switch hits appear in the event log ("End of travel"). The shutter options include "Don't move if door open", and the corresponding registry flag DoorInterlockTriggerDontMove=0 suggests it is off (inferred mapping; Reg 11199).
- **Not guaranteed:** On 23 and 28 Sep 2026 the event log shows `PLC_SetXRayoffRelay: WriteFile failed` and `XRay OFF : error in Status PLC_SetXRayonRelay();` (Log 09-2026.log). At those moments the software's X-ray-off command did not reach the PLC. Software shut-off must not be treated as the safety barrier; hardware interlocks and a person at the instrument are.

### What this means for Claude control

1. **No supported API exists.** Claude can drive XrdWin only through its GUI (menus, toolbar, dialogs; command IDs listed above), with a trained operator present. Every collection passes through at least one modal dialog ("Ready for collection?"), and X-ray or fit-error prompts can appear at any time. A script must detect every prompt and hand safety prompts to the human.
2. **Use XrdWin's own sequencers instead of stepping the hardware.** The most useful and lowest-risk role is to prepare inputs (angle sets, templates, Teach Map coordinate lists once the `.map` format is confirmed), have the operator or a supervised GUI step start a MET, map, Teach Map or Inline run, and let XrdWin handle motors, shutter and X-rays with its interlocks and auto-off.
3. **Reading data is safe today and needs no instrument access.** Claude can parse the documents and text exports, read the report headers (`exportsetup.txt`), and monitor progress from the exposure log and event log (read-only). Batch Processing can bulk-export old data to text, but only when an operator runs it in the GUI.
4. **Screen-reading limits:** Standard buttons, edit boxes and lists should be visible to Windows UI Automation (inferred). The peak and sin²ψ plots are custom-drawn and cannot be read, and captions may change with the language file. Match controls by command/control ID rather than by text where possible.
5. **Longer-term options need Proto.** The Simulation mode (a possible dry-run sandbox) and the existing robot / ISTL / IO-Link / Client-Server hooks (XrdWin as TCP client to a local helper server) look like the vendor's own integration route. Any use of them needs Proto documentation and approval; Claude should not enable them by editing the registry.

### Open questions

- Which menu captions actually appear at run time (`lang1.dat`)? Do the MFC dialogs and the progress window expose usable names to UI Automation? This needs a supervised look at the running program.
- Does XrdWin.exe accept command-line arguments (e.g. a document to open) or any start-up switches? Not determined.
- What exactly is the format of Teach Map `.map` files and the new "PointAction" column, and can a hand-written list be imported safely?
- What do Setup XLS/XML/CSV (Export menu) and "SaveAs version" in Batch Processing produce?
- The manual's channel numbers (ROI 10–500, centre channel 256) and count limits (about 2000–22 000) are for 512-channel detectors. How do they carry over to the 256-pixel MiniPIX? Current practice is 60 s × 1 exposure.
- What do Simulation mode (motor and acquisition simulation) and `bSimulation=1` (Reg 10941) actually do, and is Simulation mode safe to use with the hardware connected?
- Why did the PLC X-ray-off writes fail on 23 and 28 Sep 2026? Should "Don't move if door open" be enabled?
- XrdWin imports folder-watch functions (FindFirstChangeNotification). Which folder does it watch? It may be the detector output folder (inferred).
- What does "Number of Separate Collection Parameters" in Collection Constants mean? It is not in the manual.
