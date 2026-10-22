## Instrument hardware, connections and safety

**Key points**

- The iXRD Mini has three parts: a **controller box** (high-voltage supply, safety PLC, motion electronics), a **goniometer head** (X-ray tube, shutter/collimator, two MiniPIX detectors, beta/Z/X motors, breakout box with warning beacons), and the **PC** running XRDWin 2.0. The PC talks to the instrument over **two USB cables**, one for the detectors and one for the controller (HW p.11).
- On this PC the controller cable shows up as **three FTDI serial ports**: **COM1** = X-ray high-voltage supply (Spellman), **COM8** = safety/shutter PLC, **COM9** = RS-485 motor bus. The detector cable goes to a 4-port USB hub, probably the one in the breakout box (inferred), that holds the two MiniPIX detectors, which are FTDI-based. (PnP + registry evidence below.)
- X-rays can only come on after a person has closed the hardware interlock chain: X-ray lock **key**, the green **X-Ray Enable** button, tube-in-place and thermal sensors, the enclosure-interlock plug and intact beacon bulbs. The **Emergency Stop** and the pendant **Reset** button cut X-rays and motion. None of these is a software function, and none may be bypassed (HW p.5, p.20, p.42).
- Operator duties apply every session: dosimeter, shielding or a 5 m exclusion zone, warm-up (7 or 15 min, or 40 min conditioning), and at least 10 min cool-down before power-off. The registry's last warm-up is **2026-09-20**, so under the manual's rule the next session should use the **15-min** warm-up (inferred).
- **Tube power conflict:** the 16 mm Cr tube is rated **20 W max, with 18 kV / 1 mA recommended** (HW p.16; factory certificates were run at 18 kV / 1 mA). The live "System\Tube" registry, however, caps at 25 kV / 2 mA / 50 W and stores 20 kV / 1.8 mA (36 W) for tube 1. Confirm this with Proto before anyone automates HV settings.

Sources and citation style: **HW p.N** = *iXRD Mini Hardware Manual v1.0, May 2024* (D:\Manuals), by PDF page (= `hwmanual.txt` "PAGE N" / `img\hw_pNN.png`). **SW** = *XRDWIN 2.0 Software Manual (2010)*, cited by line of `sw-manual\xrdwin_manual.txt`. **reg** = live HKCU export `registry-config\parsed_live_hkcu.txt` (written 2026-09-30), key under `HKCU\Software\Proto Manufacturing Ltd\XrdWin`. **PnP** = `live-system\pnp_props.txt`. The *Proto XRD Guide Sheet* (`guidesheet.txt`) and *Proto XRD Alignment Guide* (`alignguide.txt`) were written for the **LXRD**, not the iXRD Mini. They are used here only as supplementary guidance.

### 1. Components

| Component | What it is / does | Evidence |
|---|---|---|
| Controller | Portable box that holds the HV power supply, safety PLC and motion electronics. Front panel: Power button, X-Ray Lock key, X-Ray Enable button, Emergency Stop. Back panel: HV cable port, Motor COM port, DB25 "Controller" port, USB-B, AC inlet with rocker switch, fans | HW p.13 (Figs 3-4), p.42 |
| HV power supply (HVPS) | Built into the controller. DC high voltage, **max 50 W**; software limits the power to suit the tube. Digitally programmed from the PC. Registry: Spellman serial, hardware max 50 kV / 2 mA | HW p.13, p.43; reg `Constants\System\Tube` SpellmanSerial=1, HardwareMaxkV=50.00, HardwareMaxmA=2.00 |
| Safety PLC | Monitors the interlocks. Drives the shutter solenoid and both beacons. Disables X-ray power on any interlock failure. Registry: TRi FMD "Super PLC" | HW p.11, p.42; reg `System\Shutter` UseTrilogi_PLC=1, FMDSUPERPLC=1 |
| X-ray tube | 16 mm, air-cooled, permanently attached HV cable and fan. Thermal sensor in the manifold. Mounted in an adjustable cartridge. This unit: **Cr, S/N 10116sCrT24004** | HW p.16 (Fig 7); D:\Certificates\Pre-Shipping ASTM E915 Cr Fe.pdf |
| Collimator + shutter solenoid | Collimator is fixed perpendicular to the tube window. Apertures fit on its end. The shutter is solenoid-driven through the breakout box. A brass seal over the tube window limits leakage | HW p.14 (Fig 5 items 2-3), p.15, p.22 |
| Apertures | Round 0.5, 1.0 and 2.0 mm. Rectangular 0.5x3, 1x3 and 2x5 mm, which can be mounted parallel or perpendicular to the scan plane (perpendicular is standard) | HW p.17 |
| Detectors | Two **MiniPIX TPX3** (Timepix3) area detectors, **L1** (left) and **R2** (right), each on the 2θ-marked detector arc with one thumbscrew. Micro-USB 2.0. Sliding steel cover over the Si sensor. Snap-on K-beta filter (for Cr: V filter, per the RA certificate) | HW p.16-17, p.23-24; reg `System\Detector\XISL` strSerialDet1=MiniPIX C10-W0115, strSerialDet2=MiniPIX F06-W0115, bias 200 V, threshold 3 keV |
| Motion axes | **Beta** (tilt/oscillation arc), **Z** (focus height), **X** (mapping). **Aux** port for options (austenite arc, phi table, 4-point bend). "Intelligent" steppers with built-in controller, driver and 512-line encoder on an RS-485 bus. Photos show **MDrive 14 Plus** motors | HW p.14, p.15, p.42-43; `img\crop_mdrive.png`, hires_p34 (Fig 28) |
| Breakout box | Mounted on the back of the goniometer. Collects all head cables. Carries the red **Shutter Open** and amber **X-Ray On** beacons on top and a built-in USB hub (1 USB-B up, 4 USB-A 5 Gbps) | HW p.15 (Fig 6); `img\crop_bbox.png`, `crop_usbhub.png` |
| Pendant | Handheld unit. Axis knob (only X and Z active on the Mini), JOG -/+, **Reset** (emergency: stops motors and X-rays), **Teach** (auto-focus, defocus/refocus, register map points). The Headlight and Spotlight switches are not used on the Mini | HW p.19 (Fig 11) |
| Focusing pointers | Manual *alignment* pointer (sharp carbide tip, for alignment only), manual *measurement* pointer (dull tip), optional *auto-focus* pointer | HW p.18 |
| Alignment camera | USB microscope (up to 150x) that plugs into the PC only for concentricity alignment. Used from XRDWin Utilities > Alignment Camera ("Proto Alignment Camera" = .NET WPF app AvCapWPF). **Not plugged in now** (PnP lists only the laptop's integrated webcam) | HW p.29-30; PnP |
| Options | Retained-austenite arc, manual or motorized, **79°-160°**, set up by Proto. Enclosures (basic or large, door interlocks) or a portable barrier screen. Phi turntable. X-Y stage | HW p.12, p.36-38 |
| Licence key | Sentinel HL (HASP) USB dongle. XrdWin will not run without it | PnP VID_0529 "Sentinel HL"; HW p.40 |

### 2. How everything connects to the PC

The manual describes an internal "USB 2.0 communication hub" in the controller that gives **3 separate channels**: PLC, motors and X-ray supply (HW p.42). Today's PnP enumeration matches that exactly:

```
PC (Dell; USB-C root port) ── external USB 3 hub (Realtek 0BDA:5411/0411)          (inferred: dock or adapter)
   ├─ port 1: USB 2.0 hub 1A40:0101  = controller's internal comm hub                   (inferred)
   │    ├─ FT231X  DM711K8H  "Fast USB to RS-232 Adapter"   → COM1  → HV supply (Spellman)
   │    └─ FT2232H FT6SEZFV  "USB to RS-422/485 Adapter"    → COM8 (ch A) → safety/shutter PLC
   │                                                         → COM9 (ch B) → RS-485 motor bus
   └─ port 2: 4-port USB 3 hub 14B0:0438/0439 = breakout-box detector hub               (inferred)
        ├─ port 1: FT2232H FTDM8KJE "WidePIX MiniPIX T3WA sn: 2013"  (ch B also = COM7)
        ├─ port 3: FT2232H FTDM8KES "WidePIX MiniPIX T3WA sn: 2012"  (ch B also = COM5)
        └─ port 4: FT232R  B001DBYC "FT232R USB UART"  → COM4  → role unknown
```
(PnP: parent/LocationInfo chains. COM↔device mapping: `registry-config\live_serialcomm.txt`. Roles: reg `System\Tube` COMPort=1, `System\Shutter` COMPort=8, `System\Controllers General Configuration` COMPort=9.)

**Component -> how it connects -> notes**

| Component | How it connects | Notes |
|---|---|---|
| HV supply | Inside controller → USB-serial (FT231X) → **COM1** | Spellman serial protocol (not yet decoded). HV output goes through the tube's HV cable into the controller's HV port. Do not hot-plug (HW p.24) |
| Safety PLC (shutter, beacons, interlocks) | Inside controller → FT2232H ch A → **COM8** | The same USB device carries the motor channel. Registry DelayShutter=333 (units unknown, probably ms, inferred) |
| Motors (Beta, Z, X, Aux) | FT2232H ch B → **COM9** → controller "Motor COM" 12-pin → breakout "Comm Port" → axis 12-pin connectors | RS-485 bus (HW p.42). 24 VDC, 2 A per motor (HW p.44). **Never plug or unplug a motor cable with power on**, because that damages motors (HW p.24, p.40). Registry holds both "1.Mycom MAC-300" and "5.MDrive" controller entries |
| Breakout box ↔ controller | DB25 "Control Interface" → controller "Controller" port, plus 12-pin Comm Port → "Motor COM" | Carries all power, interlock and communication lines except HV and USB (HW p.15, p.24) |
| Shutter / collimator | DB15 → breakout box "Collimator" | Shutter is driven by the PLC (HW p.15, p.42) |
| Enclosure / door interlock | DB9 → breakout box "Enclosure Interlock" | The **bypass plug must be fitted** if there is no enclosure (HW p.15, p.20) |
| Pendant | 12-pin → breakout box "Pendant" | Reset button = emergency stop for motion and X-rays (HW p.19) |
| X-ray tube fan + thermal sensor | 4-pin connector on the tube | Unplugging it raises an alarm and disables X-rays (HW p.20, p.43). Where the other end plugs in is not stated |
| Detectors L1 / R2 | Micro-USB → breakout-box hub → **USB-B cable to PC** | Use the 5 Gbps ports with the battery symbol (HW p.15). Driven by Pixet / pypixet, not by XrdWin's serial ports. Each detector also exposes an unused-looking COM port (COM5, COM7) (inferred) |
| Controller USB | USB-B on controller back → PC | USB 2.0 A-B, **max 3 m** (HW p.43). "Cannot find motors/PLC" fix: try other ports, prefer USB 2.0, set COM-port latency to 1 ms (HW p.40) |
| Alignment camera | Directly into a PC USB port, only during alignment | HW p.29 |
| AC power | IEC inlet with rocker switch on the back, Power button on the front | 100-240 VAC, 6 A, 50/60 Hz (HW p.11). The appendix gives 100-260 VAC, 6.3-10 A (HW p.44). The two statements differ |

### 3. Power-up, warm-up, X-ray on/off, shutdown

1. **Before power-up:** check shielding (enclosure, barrier, or cordon), wear a dosimeter, check the HV cable for damage and kinks, confirm the tube is firmly anchored and the fan airflow is clear (HW p.21 Fig 12 step 4; p.25).
2. Turn on the PC and start **XRDWin 2.0**. Switch on the enclosure mains if there is an enclosure, then press **Power** on the controller front (HW p.25).
3. **Initialize** in XRDWin. **The shutter opens and closes during initialization** (HW p.25), and motors home (reg `Constants\Detectors` HomingAxis9and10InInit=1; `XrdWin\System` AutoScanPortsInInitThread=1).
4. Close every interlock: turn the **key**, fit the door interlock or bypass plug, seat the tube. Then press **X-Ray Enable**. It lights **green** when the chain is closed, and it is "the last physical confirmation before allowing X-rays" (HW p.25, p.20).
5. **Warm-up:** High Voltage > Warm-up tab, enter max kV/mA, then start (HW p.25; `warmup.txt`). Use **7 min** if the tube was used "within the last few days", otherwise **15 min**. If the tube arcs (audible tick plus kV/mA dip), use the **40-min "Conditioning"** routine. Persistent arcing means contact Proto (HW p.26). The LXRD guide sheet uses a ">7 days → 15 min" rule. Registry `XrdWin\System` LastWarmUp = "September 20, 2026 15:51:56".
6. **During measurements:** on the iXRD, once X-Ray Enable is pressed, the X-rays come on only when a collection or warm-up is started (SW line 847). Registry flags agree: AutoXRayInCollectThread=1, AutoXRayOff=1, CheckForXRay=1, AutoRetryCollXRayOff=1 with AutoRetryCount=3. So **XrdWin itself can re-energize X-rays to retry a collection** (inferred from flag names plus `retry_reason.txt`). If the key is off or Enable was not pressed, XrdWin shows a warning dialog (SW lines 867-872).
7. **Shutdown:** turn X-rays off and allow **at least 10 min** for the tube to cool before turning the unit off (HW p.26). Close the detector slide covers for storage. Warm the tube up at least every 3-4 months, even when it is not in use (HW p.26).

### 4. Safety systems and operator duties

| Item | Behaviour | Evidence |
|---|---|---|
| X-Ray Lock key | Locked/unlocked. Must be unlocked for X-rays | HW p.13, p.20 |
| X-Ray Enable button | Press after init once all interlocks are closed. Green LED = enabled | HW p.20, p.25 |
| Emergency Stop | Red mushroom switch on the controller front. Figure 2 and `crop_estop.png` also show an E-STOP on the goniometer-side box that carries the beacons, but the text does not describe it (from images) | HW p.12-13 |
| Pendant Reset | "Immediately stop motor movements and X-ray production" | HW p.19 |
| Tube-in-place sensor | X-rays blocked unless the tube is seated on the goniometer | HW p.20 |
| Thermal sensor / fan | Over-temperature **or** an unplugged 4-pin fan connector gives an audible alarm and disables X-rays. The water-flow monitor applies only to water-cooled systems, and the Mini is air-cooled | HW p.20, p.43 |
| Beacon interlock | **Amber "X-Ray On"** lights when HV is on. **Red "Shutter Open"** lights when the shutter is open. If a bulb filament is missing, X-rays cannot be generated and the shutter cannot open | HW p.5, p.15, p.42 |
| Enclosure / door interlock | Door switches stop X-rays when a door is open. With no enclosure, the bypass plug is required | HW p.5, p.15, p.20 |
| Dead-man switch | Optional. Not known whether it is installed here | HW p.5 |
| Limit switches / proximity sensors | Hardware travel limits on each axis | HW p.43 |

**Operator rules (manual):** wear a film badge or dosimeter. Operate only with the tube in a shielded enclosure (at least 0.025 in steel or 0.5 in Al equivalent), or, in open-beam mode, with shielding or a cordoned beam and scatter zone. When unshielded, the console must be **at least 5 m** from the tube and nobody else may be closer than 5 m. The shutter is normally open only **3-60 s** per exposure. Check the warning devices before every use, and **never defeat an interlock**. The equipment must be used under supervision of a qualified person and in line with local regulations (NBS HB111 / ANSI N43.2 are cited). Before servicing, disconnect power and discharge residual HV. Keep everything earth-grounded. The Be window is fragile and toxic if scratched. Do not touch the detector sensor window (HW p.2, p.4-6, p.17, p.25).

### 5. Limits and ratings

| Quantity | Value | Evidence |
|---|---|---|
| HVPS | 50 W max. Hardware 50 kV / 2 mA | HW p.13; reg `System\Tube` |
| 16 mm tube rating | **20 W max at 30 °C ambient. Recommended ≤18 kV and ≤1 mA** | HW p.16 |
| Factory-certified operating point | Cr, 18 kV, 1 mA (stress and RA certificates, 2024-11-26) | D:\Certificates |
| Software caps, live `System\Tube` | MaxKV=25.00, MaxmA=2.00, MaxKW=0.05 (50 W). Tube1 Cr TubeVoltage1=20.00, TubeCurrent1=1.80 (36 W). Gain setting 15 kV / 1.5 mA (meaning of the fields inferred) | reg lines 11254-11306 |
| Parallel `System1\Tube` set | MaxKV=20, MaxmA=1.00, MaxKW=0.02. Cr 18 kV / 1 mA. `System` has DualSystem=1, and which set is live is unconfirmed | reg lines 6587-6653; `Constants\System` DualSystem=1 |
| Legacy config values | "XRayTube HVControiller"=KEVEX, MaxKV=25, MaxmA=5.0 (probably unused, inferred) | reg `Configuration\System Configuration` |
| Beta axis | Hardware range ±45°. Alignment oscillation ±35°. Registry MaxBetaAngle=30. LXRD guide: ≤33° for stress, with a manual collision check first | HW p.43, p.30; reg `Angles Beta Constants`; guidesheet p.3 |
| Z and X axes | 0-255 mm each ("may vary") | HW p.43 |
| Motors | 51 200 microsteps/rev, repeatability 0.0005°, 512-line encoder, 2-phase, 24 VDC 2 A | HW p.43-44 |
| Ambient | 0-30 °C for air-cooled systems | HW p.44 |
| Detectors | 256 x 256 px, 55 µm pixels, bias 200 V, threshold 3 keV | reg `System\Detector\XISL` |

Note: the 2010 SW manual says 16 mm tubes are "nominally run at 18 kV and 2 mA" (SW line 719). That is 36 W, which conflicts with the 2024 HW manual's 20 W rating.

### 6. Alignment and calibration (all manual, done by a trained person)

The manual requires the steps in this order, and says operators need Proto training for a full calibration (HW p.27).

1. **Pointer length:** zero a caliper on the measurement block. The measurement pointer must be **0.89 in ± 0.005 in (stated as 22.61 mm ± 0.01 mm)**. Adjust with a 0.7 mm hex key (HW p.27). Note that 0.005 in is 0.13 mm, so the imperial and metric tolerances disagree.
2. **Beam alignment:** focus the alignment pointer on the fluorescent-puck cross-hair, then Defocus. Fit a 2 mm aperture. **Open the shutter manually** (Configuration > User Configuration) and turn on X-rays at normal power. The green spot should sit on the cross-hair. If it does not, shift the tube in its cartridge: front/back by sliding it with the locking screws underneath loosened (the tube must be removed for this), left/right with the adjustment screw. Directions are in Table 1 (HW p.27-29).
3. **Beta concentricity:** put the USB microscope on the alignment pointer tip (about 2.5 cm away, zoom to 150x). Tick "Oscillation Test Enabled", then Move Motors > Beta 35 > OscTest, which oscillates ±35°. Alignment is satisfactory if the tip stays inside the 3rd circle. Otherwise adjust the left/right slide first, then up/down, following Table 2 (HW p.29-35).
4. **Standards check:** measure the low- and high-stress standards. The LXRD alignment guide also describes trimming up/down against the normal-stress sign and left/right against shear, with a maximum of 8 rings of adjustment (alignguide p.4-5). Factory results: LSS PFe21118 gave +0.4 to +8.3 MPa. HSS SFe24413 (-492 ± 35 MPa) gave -471.9 to -485.3 MPa. RA standard PRA19085 (5.1 ± 0.4 %) gave 5.07 % and 5.14 % (D:\Certificates).
5. **Auto-focus calibration:** calibrate against the manual pointer and a gain shim at least every 3 months, or monthly with heavy use (`Auto Focus Calibration.pdf`).
6. **Maintenance:** the user checks pointer length, auto-focus calibration, interlocks, enclosure leakage, fuses (yearly), connectors and cables. Proto or trained staff recalibrate to a standard every year and lubricate the slides with high-pressure molybdenum grease (HW p.39).

### What this means for Claude control

- **A person is always the first safety gate.** Key, X-Ray Enable, E-stop, pendant Reset, tube-in-place, thermal and beacon interlocks are hardware in the PLC chain. Claude cannot and must not operate or emulate them. Any automated session needs an operator at the console, wearing a dosimeter, who has turned the key and pressed Enable, and who keeps a hand near the E-stop.
- **All control of X-rays, shutter and motors goes through COM1, COM8 and COM9, and XrdWin holds those ports.** Opening them from another program would conflict with XrdWin and could toggle PLC lines. The realistic route is to drive XrdWin itself, supervised, and not to talk to the serial devices directly. A software "abort" from Claude is not a safety function.
- **XrdWin acts on its own.** It homes motors and opens and closes the shutter during Initialize, turns X-rays on inside collections, and can auto-retry with X-rays. Any automation plan should treat "Initialize" and "Collect" as X-ray and motion events that need an explicit go-ahead from the operator.
- **Many steps are physical only:** apertures, pointer swaps, detector R2 positioning (the manual arc), detector slide covers, filters, alignment screws, cable changes (never hot-plug), and the enclosure bypass plug. Claude's useful role here is checklists and verification: warm-up choice from LastWarmUp, 10-min cool-down timer, beta collision check before multi-tilt runs, and reviewing results.
- **Detectors are a separate USB path** (breakout-box hub, MiniPIX/Pixet), so reading detector data does not touch the X-ray or motion hardware. Both instrument USB links do run through one external hub, which is a single point of failure behind "Cannot find motors/PLC" errors.
- **Resolve the kV/mA question before automating HV settings.** The software caps allow up to 50 W, more than the tube's 20 W rating.

### Open questions

1. Which tube settings are actually used, and which registry set is live ("System": 25 kV / 2 mA / 50 W, Cr 20 kV / 1.8 mA; or "System1": 20 kV / 1 mA / 20 W)? Is 1.8 mA acceptable for this 20 W tube? Ask Proto.
2. Does the Purdue unit have an enclosure with door interlocks, or does it run with the bypass plug and barrier screens? Is a dead-man switch fitted?
3. Is there a second E-stop on the goniometer box, as the photos suggest? What does it cut?
4. Is the retained-austenite arc motorized on the Aux axis, and which axes are physically installed (is X present)?
5. What is the FT232R device on COM4 (B001DBYC) attached to the detector hub? The registry lists RefocusLaserOADM on COM4, but disabled.
6. Does X-Ray Enable stay latched between collections until power-off or an E-stop, or does AutoXRayOff drop it?
7. Are the "Mycom MAC-300" registry entries legacy, with MDrive the real motor type? What are the serial settings on COM1, COM8 and COM9? That needs the XrdWin binary analysis, which was not done.
8. What is the actual ID tag and PLC revision on this unit? The manual photo shows the "First Article Unit IXRDMINI221109CS, PLC: IXRDUC_REV00", which may not be this unit.
9. The manual contradicts itself on mains rating (6 A vs 6.3-10 A) and pointer tolerance (±0.005 in vs ±0.01 mm). Which values are correct?
