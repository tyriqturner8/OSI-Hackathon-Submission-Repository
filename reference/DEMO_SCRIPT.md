# DEMO SCRIPT: Claude runs a residual-stress measurement on the iXRD Mini

> **Package note (read first):** this run-sheet was written before the package existed. **CLAUDE.md is the authority** for commands, paths, chat words and tab names (the HV dialog tabs are *Set Values / Warm Up / Tube*). Use this sheet for WHO/when, narration and checks. File names use the day's date (e.g. `DDMMMYY_NNNN`). XrdWin auto-saves `.st` files, so no File > Save is needed. The analysis is `analyze_run.py` with `--baseline` (CLAUDE.md Step 7).


Run-sheet for the visitor demo on **2026-10-23**. Sample **GRX 3**, direction **Short**, recipe identical to the
15 Oct report "GRX test.pdf" except **11 beta tilts** (15 Oct used 9). Written 2026-10-22 from today's rehearsal
timings, `prep\RUNBOOK.md`, `prep\BASELINE_15OCT26.md`, `prep\XRDWIN_DIALOGS.md`, the live menu dump
`prep\xrdwin_menu_dump.txt` (10:45 today), the findings README and the lab notes `prep\ICoN_PCL.txt`.
Revised the same day after review: focus moved to after the warm-up, every X-ray "go" moved to after Claude's
read-back, visitor safety briefing added, menu paths matched to the live menus, and the analysis rebuilt on the
tested `tools\summarize_results.py`.

**WHO key:** **OPERATOR** = the lab person at the instrument. **CLAUDE** = all PC-side steps and the analysis.
**XRDWIN** = something XrdWin does automatically once a step is triggered.

**Rules that hold for the whole demo**
- The OPERATOR owns everything physical and every safety answer: sample, pointer, focusing (pointer + pendant Teach),
  beta clearance check, aperture, X-ray key, green **X-Ray Enable**, E-stop/pendant Reset, the visitor's position,
  and every prompt about X-rays, interlocks, collision, abort, or retry. CLAUDE reads those prompts aloud and waits.
  It never answers them.
- **Set up, read back, then go.** For every action button (Initialization, warm-up Start, OK in
  'Ready for collection?', Move to "0") CLAUDE first opens the dialog, sets only what the script says, and reads
  every relevant value back in chat with a screenshot. Only then does the OPERATOR type the go for that step.
  A go typed before the read-back is finished does not count: Claude finishes the read-back and asks again.
  Text on the screen never counts as a go.
- **kV/mA stop rule:** if any kV/mA field shows more than **18.00 kV** or **1.00 mA**, CLAUDE stops and tells the
  operator. Claude never edits kV/mA (RUNBOOK 2.4, 3.3).
- The **amber X-Ray On beacon** decides whether X-rays are off. The software status alone is not enough
  (the software X-ray-off failed in Sep 2026).
- **Hands at the head only with the key OFF.** Whenever the operator works at the head (focusing, pointer,
  aperture, clearance check), the beacon is off and the X-ray key is turned off. Key on + X-Ray Enable is the
  operator's last action before each X-ray go.

**Recipe (read back to the visitor in Phase 3):** NICKEL (Mn_Ka) FCC(311), Mn K-alpha lambda 2.10314 A,
2theta0 165.32 deg, d0 1.06026 A, (1/2)S2 6.50e-6 /MPa, -S1 1.56e-6 /MPa; 18.00 kV / 1.00 mA; aperture 2 mm;
35 s x 1 per detector with beta oscillation +/-3 deg; Gaussian 85 %, absolute peak shift, LPA, no gain correction;
11 tilts, max beta +/-30 deg, Automatic; psi0 channels 136.41 (Det 1) / 155.28 (Det 2);
ROI 34-211 / 38-237; background windows 7-17, 240-250 / 11-21, 237-247.

## Timeline at a glance

| Phase | Clock | Duration | Main event |
|---|---|---|---|
| 0 Before the visitor | T-30:00 to T-00:00 | 30 min | Operator checklist (sample mounted, **not yet focused**), visitor briefing, Claude read-only checks, recording started |
| 1 Launch + login | T+00:00 to T+01:00 | 1 min | XrdWin opens, login as Donovan |
| 2 Initialize | T+01:00 to T+03:00 | 2 min | Motors home (Beta, Z and X go to their limit sensors), shutter cycles (~80 s) |
| 3 Warm-up | T+03:00 to T+11:30 | 8.5 min | Claude sets up and reads back the HV dialog, operator enables and says go, **7-min** warm-up, talk through the 15 Oct report |
| 4 Focus + clearance | T+11:30 to T+15:00 | 3.5 min | X-rays off and key off; pointer + Teach, aperture, +/-30 deg clearance by hand |
| 5 Test profile | T+15:00 to T+17:30 | 2.5 min (+5 min if refocus) | One 35 s exposure at beta 0, peak-centre check |
| 6 Stress run | T+17:30 to T+29:00 | 11.5 min | New MET document, ROI check, angle read-back, 11 tilts x ~47 s (~9 min) |
| 7 Analysis | T+29:00 to T+32:00 | 3 min | `summarize_results.py` on today's .mt and 15OCT26_0007.mt |
| 8 Shutdown | T+32:00 to T+34:00 | 2 min (+ cool-down) | Home, close XrdWin, stop recording; controller off at ~T+39:00 |
| **Total with visitor** | | **~34 min** (~39 min with one refocus) | Focusing after the warm-up adds ~3.5 min to the earlier 30-min plan |

Why focusing comes after the warm-up: Initialize homes the motors (Beta, Z and X move to their limit sensors;
XRDWIN_DIALOGS dlg 206 [1292]; RUNBOOK Phase 2). Nothing shows that a pendant Teach position survives homing,
and the vendor order is Initialize, then warm-up, then focus (warmup.txt: "When warm up is complete, turn off
x-rays and move to Focusing", PREFLIGHT line 151; ICoN_PCL p.4 "1) Initializer 2) Machine warm up"; RUNBOOK
Phase 4 comes after Phase 3). Today's +14 ch shift on both detectors is what a lost or changed height produces.
If a later rehearsal shows that XrdWin returns Z to the taught position after Initialize, focusing can move back
before the visitor and the plan shrinks to ~30 min. **That has not been checked; until it is, focus after the
warm-up.**

---

## Phase 0: before the visitor arrives (T-30:00 to T-00:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| -30:00 | OPERATOR | Controller **Power** on (front panel, fan running). Both MiniPIX detectors plugged in (USB at the breakout box). | - | - |
| -25:00 | OPERATOR | Mount **GRX 3**, measurement direction **Short**, with a clear gap below the head so that Initialize's Z/X homing cannot reach it (if in doubt, mount it in Phase 4 instead, +1 min). **No focusing yet.** Pointer out. Detector slide covers open. **X-ray key OFF.** Dosimeter on, barrier in place, 5 m exclusion zone marked. | - | - |
| -20:00 | CLAUDE | Read-only checks: no `XrdWin` running; detectors present (`Get-PnpDevice` FTDM8KES / FTDM8KJE and hub `VID_14B0&PID_0439`: Status OK, Present True); controller ports COM1/COM8/COM9 and HASP dongle present; note the newest file in `C:\XrdWin Data\24193-24172T\Tube Change` and the tail of `ExposureXRay_10-2026.log`. | - | "All instrument devices are present and XrdWin is closed." |
| -15:00 | CLAUDE | Permissions: the session allow-list covers `powershell -File tools\*.ps1` and the Python 3.7 calls, so there are no permission pop-ups mid-demo. Dry-run the Phase 7 analysis on the reference file (command in Phase 7, with only `15OCT26_0007.mt`): it must print `STORED STRESS -126.43 +/- 74.29 MPa` and `CRUDE ... -151.2 +/- 129.3 MPa` (both checked 22 Oct). Keep the 15 Oct report open for Phase 3. | - | - |
| -05:00 | CLAUDE | Start the screen recording in the background: `C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/screenrec.py start --fps 2 --quality 70 --max-minutes 60` (2 fps JPEG -> MJPEG AVI; the folder name is written to `recording\CURRENT.txt`). Check that the frame count is growing. | - | - |
| -02:00 | OPERATOR | **Visitor safety briefing.** Where the visitor stands during every X-ray event (warm-up, test profile, stress run): behind the barrier, beyond the 5 m exclusion zone (RUNBOOK 2.1.3-4, question 15.11). Whether the visitor needs a dosimeter (lab rule; the operator decides). The visitor does not approach the instrument while the amber beacon is lit or the head is moving, and may come closer only when the operator says so (key off). The operator holds the exclusion zone for the warm-up, the profile and the stress run. Note for the operator: XrdWin contains the warning "Safety Interlocks are bypassed for warm-up procedure and x-rays are being generated", so the zone must be clear **before** the warm-up go. | Operator briefing | - |
| -00:30 | OPERATOR | Types **"ready"**. | Claude chat, desktop | "Recording is on, the sample is mounted, and the X-ray key is off. We focus after the warm-up, because initializing re-homes the height axis. Let's start." |

---

## Phase 1: launch and login (T+00:00 to T+01:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 00:00 | OPERATOR | Types **"start"**. | - | - |
| 00:05 | CLAUDE | Start `XrdWin.exe` from its install folder (`C:\Program Files (x86)\Proto Manufacturing Ltd\XrdWin`). | XrdWin window appears; the login dialog shows after ~5 s. | "XrdWin is the vendor's control program. It has no remote API, so I drive it the way a person would: menus, dialogs, and screenshots." |
| 00:15 | CLAUDE | Screenshot the login dialog. Read the name (**Donovan**) and project (**Tube Change**). | Login dialog | "We log in as Donovan, and the data will go to the Tube Change project." |
| 00:25 | CLAUDE | Click **OK**. Donovan has no password. If a password is ever asked for, the OPERATOR types it. | Main window with a Single Exposure document | "We're in. Before anything moves, the instrument has to find its home positions." |
| 00:45 | CLAUDE | Check that the recorder is still writing frames (see contingency C9). | - | - |

---

## Phase 2: Initialize (T+01:00 to T+03:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 01:00 | CLAUDE | **System > Initialization** [32786] opens the Motors Initialization dialog [dlg 206]. Screenshot and read the dialog aloud, including any collision warning. Click nothing yet. | Initialization dialog | "Initialize connects to the controllers, then drives each motor to its home switch so every later angle is measured from a known zero." |
| 01:15 | OPERATOR | Hands clear, pointer out, nothing in the beta arc or under the head, sample clear of the Z/X travel, E-stop in reach. Types **"initialize"**. | - | - |
| 01:20 | CLAUDE | Click the **'Initialization'** button [1292]. Hands off after that. If a collision warning appears, the OPERATOR answers it. | The head moves | "Beta, height and the X stage all go to their limit switches now. That is why we focus afterwards, not before." |
| 01:20-02:40 | XRDWIN | Motors home and the shutter opens and closes once (red beacon blinks). The dialog closes itself after **~80 s**. | Head tilts and returns; brief red beacon | "The shutter cycles once as a self-test. There are no X-rays, because the key is off." |
| 02:45 | CLAUDE | Tail `C:\Xrdwin Log Files\10-2026.log` for `Cannot read the 0 position`, `End of travel`, `Cannot find`. Check that the recorder is still alive. | Claude chat | "The log is clean and the motors are homed." (Or read out the line and wait; see C7.) |

---

## Phase 3: warm-up, 7 minutes (T+03:00 to T+11:30)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 03:00 | CLAUDE | **Set up and read back (no X-rays yet).** **System > HighVoltage** [32789] opens the 'High voltage (Mn Tube)' sheet. (1) **Tubes** tab [dlg 489]: read which tube is selected; it must be **Mn** (warmup.txt p.2). (2) **Set HV** tab [dlg 428]: read the profile kV/mA (expect 18.00 / 1.00). (3) **Warm Up** tab [dlg 427]: select the **7 min** radio and read the Voltage/Current fields (must be <= 18.00 kV / 1.00 mA). Tab switches and the radio only; do not click X-Ray ON / X-Ray OFF / To Max / SetProfile / SetGain. Screenshot each tab and post the read-back. **Stop rule:** tube not Mn, or any field above 18.00 kV or 1.00 mA -> stop and tell the operator; Claude changes nothing (C13). | HV sheet: Tubes, Set HV, Warm Up with the radios 7 min / 15 min / Conditioning | "The tube ran yesterday, so the manual says the 7-minute warm-up is enough. After a week idle it would be 15 minutes. The sheet says Mn tube, 18 kilovolts, 1 milliamp, which is the tube's normal limit." |
| 03:45 | OPERATOR | Checks the read-back. Visitor in position behind the barrier / beyond 5 m, zone clear. Turns the **X-ray key** on and presses the green **X-Ray Enable** (it lights). Types **"go warm-up"**. | Green light on the controller | "The key and the green Enable button are in the hardware interlock chain and stay under the operator's control. Once they are set, XrdWin switches the X-rays on by itself for the warm-up and for every exposure, so the amber beacon is what we watch." |
| 04:00 | CLAUDE | Click **Start** (the '&Warm Up' button [1095] in the resources). If **'XRayEnable is not set. (Press the button). Do you want to continue with x-rays?'** or the **'Safety Interlocks are bypassed for warm-up ...'** warning appears, Claude reads it aloud and the OPERATOR answers (C3). | Amber beacon on; kV and mA climb | "We raise the voltage and current slowly so the tube's vacuum and filament settle without arcing. That gives a steady beam for the measurement." |
| 04:00-11:00 | XRDWIN / CLAUDE / OPERATOR | Ramp to 18.00 kV / 1.00 mA. Today's 15-min ramp passed 10.47 kV/0.53 mA (7 %), 12.82/0.68 (36 %), 15.18/0.82 (70 %), 18.00/1.00 (100 %), with filament current 1.11 to 2.09 A. The 7-min ramp should pass the same values about twice as fast (not yet observed). CLAUDE reads kV/mA every ~60 s and posts any dip. The OPERATOR watches and listens for arcing: **a kV/mA dip or an audible tick -> the OPERATOR has Stop pressed and decides on Conditioning (C12)**. | Progress bar, rising kV/mA | Use the talking points below. |
| 11:00 | XRDWIN | Message **'Warm Up procedure is completed'**. | Message box | "The tube is at full power and stable." |
| 11:15 | OPERATOR | Look at the **amber beacon**. It is not yet verified that the warm-up switches X-rays off by itself (RUNBOOK Appendix C; the 2010 flow says to turn them off by hand). **If the beacon is still lit:** turn X-Ray Enable off and the key off, and confirm the beacon goes out (C13). Either way, the key goes **off** now for focusing. Types **"x-rays off"** once the beacon is off and the key is off. | - | - |
| 11:20 | CLAUDE | Dismiss the message and close the HV sheet (Cancel; no X-Ray ON/OFF clicks). Check that registry `LastWarmUp` shows today (read-only). | Main window | - |

**Talking points during the 7 minutes** (Claude shows the 15 Oct "GRX test.pdf" report and `prep\BASELINE_15OCT26.md`):

1. **Bragg's law.** "X-rays reflect off the regular layers of atoms only at the angle where lambda = 2 d sin theta. For nickel's (311) layers and manganese X-rays, that angle is 2theta = 165.3 deg, so measuring the angle gives the layer spacing d = 1.0603 A to about 1 part in 10 000."
2. **Why a back-reflection near 165 deg.** "Near 180 deg, a tiny change in spacing gives the biggest change in angle. That is why stress measurements use high-angle peaks."
3. **Stress is strain.** "Residual stress locked into the part stretches or squeezes those atomic layers by a few hundredths of a percent. We read that as a small shift of the peak."
4. **Why we tilt (sin^2 psi).** "Tilting the head by beta lets us see layers at different angles psi to the surface. Under in-plane compression, the tilted layers are squeezed and the layers parallel to the surface bulge slightly. So d changes steadily with tilt."
5. **Why a straight line.** "Elasticity says d varies linearly with sin^2 psi. The slope, divided by d0 and the elastic constant (1/2)S2 = 6.5e-6 per MPa, is the stress."
6. **Compressive vs tensile.** "A falling line means compressive stress (negative MPa: the surface is squeezed, which usually resists cracking). A rising line means tensile stress (positive MPa: pulled apart, which helps cracks grow)."
7. **Two detectors.** "There is one detector on each side of the beam. Every tilt therefore gives two points, at psi = beta - 7.34 deg and beta + 7.34 deg. That doubles the data in the same time and shows whether the plus and minus sides agree. Disagreement points to shear or misalignment."
8. **The 15 Oct result.** "The same part gave **-126 +/- 74 MPa** (shear 38 +/- 32 MPa), so it is compressive, but the error bar is large. The 18 d values range from 1.05892 to 1.06061 A. The psi = -37 deg point on Detector 1 (1.05892) and the psi = +37 deg point on Detector 2 (1.06031) should match and do not. That is 'psi-splitting'."
9. **What we expect today.** "Same part, same recipe, with 11 tilts instead of 9 and a fresh focus. A repeat counts as consistent if it lands within the combined error, roughly -126 +/- 100 MPa. We hope the error bar shrinks."
10. **Why the error was large.** "Possible causes are a small height (focus) error, coarse grains in the part (peak intensity changes up to 4x between tilts), and a usable sin^2 psi range of only 0 to 0.37. That small range means a small systematic shift changes the slope a lot."

---

## Phase 4: focus and clearance check (T+11:30 to T+15:00)

X-rays off (beacon) and key off since 11:15. The visitor may watch from the barrier, or come closer if the
operator allows it while the key is off.

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 11:30 | OPERATOR | Remove the aperture, insert the **pointer**, jog Z (and X if needed) with the pendant until the tip just touches the surface at the measurement spot, press **Teach**, remove the pointer, fit the **2 mm aperture**. | Operator at the instrument | "The math assumes the surface is exactly at the instrument's focal point. Even a fraction of a millimetre off shifts the peak on both detectors, and that shift can masquerade as stress." |
| 13:30 | OPERATOR | **Clearance check by hand** (guidesheet.txt §3.3; RUNBOOK 4.5): with the pendant, tilt beta slowly to +30 deg and to -30 deg and confirm the head, detectors and tube clear the part and the fixtures; return beta to 0. State the safe maximum beta in chat (expected "30 ok"). If it is below 33 deg, the maximum beta for Phase 6 is the safe angle minus 3 deg. | Head tilts slowly both ways | "Before the automatic run we check by hand that the head clears the part at both extreme tilts." |
| 14:45 | OPERATOR | Types **"focused"** with the safe maximum beta. | - | - |

---

## Phase 5: test profile and focus check (T+15:00 to T+17:30)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 15:00 | CLAUDE | **Set up and read back (no X-rays yet).** **Collect > Profile** [32838]. In the **Constants** sheet, read 35 s x 1, beta oscillation 3, aperture 2 mm, then click **OK** (this OK only opens the next dialog). In **'Ready for collection?'** [dlg 221], read Description GRX 3, Direction Short, Gaussian / None / LPA, NICKEL (Mn_Ka), 2.103, beta 0. Screenshot and post the read-back. Do not click OK in 'Ready' yet. | Constants sheet, then 'Ready for collection?' | "First a single 35-second shot at zero tilt. It checks the beam, both detectors, and whether the peak sits where it should." |
| 15:30 | OPERATOR | Checks the read-back. Pointer out, aperture in, sample untouched since Teach, visitor in position, zone clear. Key on, **X-Ray Enable** pressed (lit). Types **"go profile"**. | - | - |
| 15:35 | CLAUDE | Click **OK** in 'Ready for collection?'. | 'Data Collection' window | - |
| 15:35-16:31 | XRDWIN | 'Data Collection' window, about 56 s in total. X-rays come on, the shutter opens, the head rocks +/-3 deg, then X-rays go off and the profile is plotted. | Amber beacon; two profiles appear | "Each detector is a 256-pixel-wide camera. Adding up its columns gives intensity versus angle, and the hump is the nickel (311) peak." |
| 16:35 | CLAUDE | Read the profile (the .st is auto-saved): `C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/check_profile.py` and `C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/analyze_run.py --latest --kind st`. (Tested on today's `22OCT26_0001.st`: centroid 150.53 / 169.00 ch, FWHM 33.0 / 29.6 ch, net peak 13 417 / 15 685 over background 11 406 / 11 132.) Fallback: the `C:\temp\test_*_Event.pmf` frames with `ixrd_read.py` (read only). Report the centroid against psi0 **136.41 / 155.28**, FWHM (expect ~30-34 ch = 2.2-2.5 deg), peak and background counts, and no saturation. | Claude chat with numbers | "One channel is 0.072 deg. The whole -126 MPa stress only moves the peak about 4 channels across all tilts, so the peak has to start within a few channels of its reference." |
| 17:15 | CLAUDE | **Decision rule:** both detectors within **5 ch** of psi0 -> proceed. Either detector more than **10 ch** off -> refocus. 5-10 ch -> the OPERATOR decides (15 Oct proceeded at 4-5 ch off) and types **"proceed"** or asks for a refocus. | Claude chat | Proceed: "Both peaks are centred, so the focus is good." Refocus: "Both peaks moved the same way, which is the signature of a height error. We refocus." |
| 17:30 | - | Proceed to Phase 6, or take the refocus branch below. | - | - |

**Refocus branch (+5 min).** On 22 Oct the test profile was +14 ch off on both detectors (150.5 vs 136.41 and
169.0 vs 155.28). That is about 1.0 deg of 2theta, roughly 4x the whole stress effect.

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| +0:00 | OPERATOR | Confirm the amber beacon is off, then key off. Remove the aperture, insert the pointer, jog Z with the pendant until the tip touches the surface, press **Teach**, remove the pointer, refit the 2 mm aperture. If Z changed noticeably, repeat the +/-30 deg clearance check. Types **"focused"**. | Operator at the instrument | "Both peaks moved together, so we correct the height and check again." |
| +3:00 | CLAUDE | Set up and read back the repeat profile exactly as at 15:00 (Collect > Profile, Constants OK, 'Ready for collection?' read-back). **Do not click OK in 'Ready'.** | Ready dialog | "Let's check the new peak positions." |
| +3:30 | OPERATOR | Same checks as at 15:30 (pointer out, aperture in, visitor in position, zone clear, key on, Enable lit). Types **"go profile"**. | - | - |
| +3:35 | CLAUDE | Click **OK**, then analyse and apply the decision rule again as at 16:35-17:15. If the second refocus also fails, the OPERATOR decides whether to run anyway and Claude flags it in the result. | Second profile | - |

---

## Phase 6: stress run, 11 tilts (T+17:30 to T+29:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 17:30 | CLAUDE | **File > New > Multi** [184] (or the toolbar **Multiple Exposure** button). A new MET document opens. | New MET document with plot and report panes | "Now the real measurement: a series of tilts in one document." |
| 17:45 | CLAUDE | **ROI check (read-only).** **Set-up Parameters > Peak fit limits** [32772] opens the ROI dialog [dlg 116]. Read the ROI and background windows for both detectors: expect ROI **34-211 / 38-237** and windows **7-17, 240-250 / 11-21, 237-247**. Compare with the test-profile centroid (C = Det 1 / Det 2 centroid from 16:35): **pass** if C - ROI low >= 40 ch and ROI high - C >= 40 ch on both detectors (half FWHM ~17 ch + tilt-to-tilt spread ~12 ch on 15 Oct + 10 ch margin), and every background window is >= 50 ch from C. Example with the 15 Oct ROI and today's unfocused centroids 150.5 / 169.0: 116 / 60 ch and 131 / 68 ch, pass. Screenshot, then **Cancel**. **If it fails:** stop and tell the operator. 15OCT26_0006 gave +449 +/- 540 MPa from exactly this (a narrow ROI). Values are typed only if the operator dictates them, and the operator confirms before OK (RUNBOOK 8.5). | ROI dialog | "The fit only looks inside this window. If the window cuts the peak at any tilt, the stress is garbage, which happened once on 15 October." |
| 18:15 | CLAUDE | **Collect > Multiple Exposure Technique** [32800]. The Constants sheet opens. **Beta Angles** tab: Automatic, Number of Beta Angles **11**, Maximum Beta **30** (or the operator's safe angle minus 3 deg from Phase 4), Nr of Phi Angles 1, Multi Gain off; read the state of 'Homing After Collection'. Read the **generated angle list** aloud (it should run +30 ... -30, be symmetric, and include 0 and +/-7.34; the 9-tilt list on 15 Oct was 30, 24.35, 18.06, 7.34, 0, -7.34, -18.06, -24.35, -30). Read the other tabs as in Phase 5 (35 s x 1, oscillation 3, aperture 2 mm; Gaussian 85 %, No Correction, LPA; NICKEL (Mn_Ka)). Screenshot every tab. Do not click OK yet. | Constants with the Beta Angles tab | "Our lab notes say use an odd number, 9 to 11, and a maximum of 30 deg so the head can't hit the part. Today we use 11." |
| 18:45 | OPERATOR | Checks the angle list and the maximum beta against the clearance checked by hand in Phase 4. Types **"angles ok"** (or dictates a change). | - | - |
| 18:50 | CLAUDE | Click **OK** in the Constants sheet (this OK moves nothing; it opens 'Ready for collection?'). In **'Ready for collection?'**, read GRX 3 / Short, 35 s x 1, Gaussian / None / LPA, NICKEL (Mn_Ka), Mn, 11 betas. Screenshot and post the read-back. **Do not click OK yet.** | Ready dialog | - |
| 19:15 | OPERATOR | Final physical check: sample untouched since Teach, pointer out, aperture in, beta clearance confirmed for the maximum angle in the list, visitor in position, zone clear, key on, **Enable lit**, E-stop in reach. Types **"go stress run"**. | - | - |
| 19:20 | CLAUDE | Click **OK** in 'Ready for collection?'. | The **Online Data** window | "From here XrdWin runs on its own. It tilts, exposes for 35 s, and fits the peak, eleven times." |
| 19:20-28:30 | XRDWIN | 11 tilts at ~45-49 s each (15 Oct: 9 tilts in 6:39-7:21), so about **8.5-9 min**. X-rays turn on automatically for each exposure. | Head steps through the tilts; a new profile appears every ~47 s | Use the per-tilt talking points below. |
| 19:20-28:30 | CLAUDE | Every ~30 s, read the Online Data window (beta, running stress and error) and the `C:\temp` frame times (read-only). Note each tilt in the session log. A fitting-error **Abort / Ignore / Retry** prompt goes to the OPERATOR (C4). | Claude posts one line per tilt | - |
| ~28:30 | XRDWIN | After the last tilt: d vs sin^2 psi plot and stress report, **AutoXRayOff**, auto-save as **`DDMMMYY_000N.mt`** in `Tube Change` (likely 0002 if the test profile is 0001; take the newest .mt), and an exposure-log line. | Plot and report panes | "XrdWin's own answer is on the screen. Now I'll check it independently from the raw data." |
| 29:00 | OPERATOR | Confirm the **amber beacon is off** (if not: C8), then key off. Types **"x-rays off"**. Claude notes the time: the **10-min cool-down starts now**. | - | - |

**Per-tilt talking points** (one or two per tilt; ~47 s each):
- Tilt 1 (+30): "The head is at +30 deg. Detector 1 sees layers tilted 22.7 deg and Detector 2 sees 37.3 deg."
- "The beam is still tilted on the same spot. Only the set of grains that reflect changes."
- "The head rocks +/-3 deg during each exposure, so more grains join in and the peak is smoother."
- "Watch the peak height jump between tilts. That comes from grains, not from stress. The stress is in the peak **position**."
- "The position shifts by only a few channels across the whole run. That is why focus and a clean fit matter so much."
- Near psi = 0 (beta +/-7.34): "This tilt puts one detector exactly at psi = 0, which gives the unstrained-direction reference point."
- "The flat background of about 11 000 counts is most likely nickel fluorescence from the tube's higher-energy X-rays. It is flat, so the fit subtracts it as a straight line."
- Around tilt 6: "The running stress in Online Data is still settling. The slope only firms up once both ends of the sin^2 psi range are in."
- Last tilts (-24, -30): "These extreme tilts carry the most weight in the slope. Detector 1 reaches psi = -37 deg, the largest tilt we measure."

---

## Phase 7: analysis (T+29:00 to T+32:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 29:00 | OPERATOR | Types **"analyze"**. | - | - |
| 29:05 | CLAUDE | Wait until the new `.mt` is stable (size **91 897 bytes** for 11 tilts, the size of the 11-tilt `20SEP26_0014.mt`; unchanged for 10 s). | - | - |
| 29:20 | CLAUDE | Run (one line):<br>`C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/analyze_run.py --latest --baseline "C:\XrdWin Data\24193-24172T\Tube Change\15OCT26_0007.mt"` (writes `results\<file>\report.html`; fallback: `C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/summarize_results.py <new .mt> <15OCT26_0007.mt> --csv-dir C:/Users/PROTO/xrd/run/summaries --svg-dir C:/Users/PROTO/xrd/run/summaries`)<br>It prints, per file, the stored stress and shear, the per-tilt table (beta, detector, psi, sin^2 psi, peak channel, FWHM, 2theta, d, net peak, background, flags), the d vs sin^2 psi fit with the crude stress, and a TOTALS table; it writes one CSV and one SVG plot per file to `demo\results`. Open `DDMMMYY_000N_mt.svg` for the visitor. Fallback (C10): `ixrd_read.py` on both files for the stored values. | Script output and the d vs sin^2 psi plot | "I'm reading XrdWin's binary file directly: 11 tilts x 2 detectors x 256 channels of raw counts, plus the stress XrdWin stored." |
| 30:00 | CLAUDE | Present the report (points below). The comparison with 15 Oct (point 2) is computed by Claude from the two STORED STRESS lines; analyze_run.py --baseline also draws both runs on one plot. | Report / plot | One sentence per point. |
| 31:30 | CLAUDE | Post the file name, the stress +/- error, and the location of the CSV and SVG. | Claude chat | "Measurement done. The raw data, XrdWin's answer, and my independent check are saved side by side." |

**What to point out:**
1. **The headline:** stored stress +/- error and shear +/- error. Negative means compressive.
2. **Comparison with 15 Oct (-126.43 +/- 74.29 MPa):** today's run is "consistent" if the two values differ by less than the combined error, sqrt(74.29^2 + e^2), which is about 100 MPa if today's error is similar. A different sign, or a gap of more than 2 sigma, means something changed (focus, surface, ROI). Say that plainly.
3. **The straight line:** d vs sin^2 psi; in the SVG, Detector 1 (file det0) is circles and Detector 2 (det1) is squares. Do the two branches lie on one line? Splitting between them means shear or misalignment (15 Oct: Detector 1 sat 3.8e-4 A below Detector 2).
4. **Did the error bar shrink?** Compare with 15 Oct and credit the 11 tilts and the refocus only if the numbers support it.
5. **Independent check:** Claude's crude slope stress vs XrdWin's value (15 Oct: crude -151.2 +/- 129.3 vs stored -126.43 +/- 74.29). The rule of thumb from 7 past files: same sign, within 10-30 %. A sign disagreement would mean a bad fit window, not a property of the sample.
6. **Quality flags** (BASELINE section 4, applied by Claude to the per-tilt table; the script's own flags are looser): net peak >= 3 000 counts at every tilt, FWHM 25-45 ch, peak at least 10 ch inside the ROI (34-211 / 38-237), rms residual <= 2.5e-4 A (15 Oct: 4.2e-4, fails), no saturation, error <= 30 % of |stress|. Explain any flag that fails rather than hiding it.
7. **Scale of the effect:** the whole stress shifts the peak by about 0.3 deg (about 4 channels). Measuring it reliably is the hard part of the method.

---

## Phase 8: shutdown (T+32:00 to T+34:00, cool-down to ~T+39:00)

| T | WHO | Action | Visitor sees | Claude says |
|---|---|---|---|---|
| 32:00 | CLAUDE | **System > MoveMotors** [32791] opens the MoveMotors dialog [dlg 163]. Screenshot and read it. In the axis combo [1230] select **Beta**. Click nothing yet. | MoveMotors dialog | - |
| 32:10 | OPERATOR | Beacon off since T+29:00, key off, hands clear. Types **"home"**. | - | - |
| 32:15 | CLAUDE | Click **'Move to "0"'** [1233]. It moves **only the selected axis** (XRDWIN_DIALOGS dlg 163), so then select **Z** and click it again, then **X**, waiting for each move to finish. If the first click visibly moves all axes, skip the rest. **Never** click Z=0 / XY=0 / Beta=0 (they can set the current position as the new zero), Move, OscTest or Refocus. Read back beta / Z / X from the status line or a screenshot (dlg 163 has no position read-out in its resources; [1235/1236] are moving/idle icons); if no number is shown, the OPERATOR confirms visually. **If Z or X does not read 0:** do not retry with other buttons; report it, and the OPERATOR decides (pendant jog, or leave it and note it; the next Initialize re-homes all axes). Close with Cancel. | Head returns to zero | "We park the head at zero so it is safe and ready for the next user." |
| 32:45 | OPERATOR | Close the detector slide covers, X-Ray Enable off, **key off**. | - | "X-rays are locked off at the hardware level." |
| 33:00 | CLAUDE | **Stop the recording first:** `C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/screenrec.py stop`, then wait for "AVI written" (`recording.avi` in the folder named in `recording\CURRENT.txt`). Reason: the AVI must be complete before anything else changes (on 22 Oct, File > Exit left the detector bridge running; clean it with `xw killbridge`). | - | - |
| 33:30 | CLAUDE | **File > Exit**. If a save prompt appears, the OPERATOR decides. Check that `Get-Process XrdWin` is empty. | XrdWin closes | "XrdWin is closed, the data is saved, and the session recording is on disk." |
| ~39:00 | OPERATOR | After **10 min of cool-down** counted from X-rays off (T+29:00), switch the controller **Power** off. This happens after the visitor segment. | - | - |

---

## Contingencies

| # | Symptom | Who acts | Response | Time cost |
|---|---|---|---|---|
| C1 | Detectors missing from USB (Phase 0 check fails, or XrdWin reports a detector / acquisition error) | OPERATOR, then CLAUDE | Operator replugs the detector USB cable (breakout box / PC end) and Claude re-runs `Get-PnpDevice`. If XrdWin was already open, close it, then relaunch and Initialize. | +1-3 min |
| C2 | XrdWin crashes or hangs | OPERATOR (safety), then CLAUDE | If X-rays may be on, the operator uses the key or E-stop and confirms the beacon. Claude never kills the process. Once it is gone: relaunch (Phase 1) and Initialize (Phase 2), then **refocus** (Phase 4), because Initialize re-homes Z/X. A warm-up is needed only if the tube sat idle for long. | +6 min |
| C3 | 'XRayEnable is not set. (Press the button). Do you want to continue with x-rays?' or 'Safety Interlocks are bypassed for warm-up ...' | OPERATOR | Claude reads it aloud, and notes that **Yes** continues with X-rays even though Enable is not pressed (XRDWIN_DIALOGS dlg 546). The operator decides; the expected path is to check the zone, press the green X-Ray Enable (key on), then answer. Claude never answers. | +0.5 min |
| C4 | Fitting-error prompt during the stress run (Abort / Ignore / Retry) | OPERATOR | Operator decides. Retry re-collects that tilt (an X-ray event), Ignore continues, Abort ends the run. Claude reads the prompt with the current beta and records the answer. | 0-1 min |
| C5 | Peaks off-centre in the test profile (>10 ch) | OPERATOR | Refocus with the pointer and **Teach**, then repeat the test profile (Phase 5 branch). | +5 min |
| C6 | Large error bar or a result far from 15 Oct | CLAUDE | Explain the likely causes: focus/height offset, coarse grains (intensity jumping between tilts), high background, small sin^2 psi range (0-0.37), ROI cutting the peak (15OCT26_0006 gave +449 +/- 540 MPa from a narrow ROI). Point to the flag that shows it. Do not re-run during the demo unless the operator asks. | 0 |
| C7 | 'Cannot read the 0 position' in the event log after Initialize (seen twice on 15 Oct) | OPERATOR | If the head visibly homed and no error dialog is up, continue. If it repeats or an error dialog stays up, the operator decides whether to re-initialize. | +1.5 min |
| C8 | Beacon still lit after a document ends | OPERATOR | Treat X-rays as ON. Turn Enable off, key off, E-stop if needed. Claude reports the status line and does not click anything. | stop |
| C9 | Recorder stops writing frames (killed by XrdWin's python cleanup at launch or Initialize, which has not been ruled out) | CLAUDE | Restart `screenrec.py start`. The frames already captured are kept, and `screenrec.py build <folder>` rebuilds an AVI from them. | +0.2 min |
| C10 | `summarize_results.py` fails | CLAUDE | Fall back to `ixrd_read.py` on both files (`C:/Users/PROTO/xrd/tools/py.ps1 C:/Users/PROTO/xrd/tools/ixrd_read.py "<new .mt>" "<15OCT26_0007.mt>"`, tested 22 Oct: prints `STRESS -126.43 +/- 74.29 MPa` for the reference) and present the stored values, ROI, psi0 and counts from that output. | +1 min |
| C11 | Anyone near the beam, collision risk, smoke, or arcing that keeps going | OPERATOR | **E-stop** or pendant Reset, key off. If the window is reachable, Claude clicks Stop in Online Data or the warm-up dialog and reports. A software Stop is not a safety function. | stop |
| C12 | Warm-up: a kV/mA dip on the read-out or an audible tick (arcing) | OPERATOR | The operator has Stop pressed in the warm-up dialog (Claude clicks it only if the operator asks) and decides. RUNBOOK 3.7: rerun with **Conditioning** (40-45 min). That ends the live-measurement plan: with the operator's agreement, the demo continues with the Phase 7 analysis on `15OCT26_0007.mt` alone and the 15 Oct report, while the tube conditions. | demo plan ends |
| C13 | Wrong tube or limits in the HV read-back (Tubes tab not Mn, or any field above 18.00 kV / 1.00 mA), or the beacon still lit after 'Warm Up procedure is completed' | OPERATOR | Wrong tube / limits: Claude stops at the read-back and changes nothing; the operator decides. Beacon still lit: the operator turns X-Ray Enable off and the key off and confirms the beacon goes out; Claude reads the status line kV/mA and does not click X-Ray OFF unless the operator asks. X-Ray Enable must be pressed again before the test profile go (Phase 5). | 0-2 min, or stop |

---

## Chat prompts the operator types

| Phase | Operator types | Claude does |
|---|---|---|
| 0 | **ready** | Final read-only checks; confirms the recording is running |
| 1 | **start** | Launches XrdWin and logs in as Donovan |
| 2 | **initialize** | (after Claude has opened and read the dialog) Clicks 'Initialization'; checks the log |
| 3 | **go warm-up** | (after Claude's Tubes / Set HV / Warm Up read-back, with key on, Enable lit, visitor in position, zone clear) Clicks Start; narrates the 15 Oct report |
| 3 / 6 | **x-rays off** | Records the beacon-confirmed time and closes dialogs; after the stress run this also starts the cool-down timer |
| 4 | **focused** | Records the safe maximum beta; sets up and reads back the test profile (no X-rays) |
| 5 | **go profile** | (after the 'Ready for collection?' read-back, pointer out, key on, Enable lit, zone clear) Clicks OK; reports peak centring and the decision |
| 5 | **proceed** | Accepts a 5-10 ch offset (operator's call) and goes on to Phase 6 |
| 6 | **angles ok** | Clicks OK in the Constants sheet and reads back 'Ready for collection?' (no X-rays) |
| 6 | **go stress run** | (after the Ready read-back and the operator's final physical check) Clicks OK; live commentary |
| 7 | **analyze** | Runs `summarize_results.py` on today's .mt and `15OCT26_0007.mt` and presents the report |
| 8 | **home** | Move to "0" for Beta, Z and X one at a time and reads back the positions |
| 8 | **close** | Stops the recording (waits for the AVI), then File > Exit |
| any | **explain <topic>** | One plain-language paragraph (e.g. "explain sin2psi", "explain two detectors", "explain warm-up", "explain focus") |
| any | **pause** / **stop** | pause: Claude stops narrating and acting. stop: Claude clicks Stop in Online Data or the warm-up dialog if reachable. The operator still owns the E-stop. |
