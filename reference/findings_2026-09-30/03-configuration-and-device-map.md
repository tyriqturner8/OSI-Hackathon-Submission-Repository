## Configuration (registry) and PC device map

**Key points**

- The PC talks to the iXRD Mini over three instrument serial ports and two detector USB links. **COM1** goes to the X-ray high-voltage (HV) supply (Spellman, RS-232), **COM8** to the safety PLC (shutter, X-ray relays, interlocks) and **COM9** to the three motors (X, Z and Beta on an RS-485 bus). The two MiniPIX Timepix3 detectors sit on their own USB hub. The registry, the Windows device tree, the hardware manual and XrdWin's own logs all agree on this.
- XrdWin keeps all its settings in the *current Windows user's* registry (HKCU). It is set up as a "dual Laboratory/Portable" install run as **Portable only**, and in practice it uses **two configuration branches**. The COM ports for the HV supply and the PLC come from `Constants\System`. The tube kV/mA settings and the motor setup come from `Constants\System1`.
- **Correction to the earlier report:** the tube actually runs at **18 kV / 1.00 mA** (limits 20 kV / 1.00 mA / 20 W; Cr and Mn tubes), as set in `System1\Tube`. It does not run at the 20 kV / 1.8 mA (25 kV / 2 mA limit) in `System\Tube`: 1,637 of 1,649 logged exposures (Nov 2024 to Sep 2026) were 18 kV / 1.00 mA.
- Safety automation is switched on. XrdWin turns X-rays on inside a collection (`AutoXRayInCollectThread=1`), turns them off automatically (`AutoXRayOff=1`), checks X-ray state (`CheckForXRay=1`) and retries a failed collection up to 3 times (`AutoRetryCollXRayOff=1`, `AutoRetryCount=3`).
- **No simulation mode is ready to use.** `bSimulation=1` and `"Simullation Check"` are legacy values that the current XrdWin.exe never reads. The switches it does read (`XrdWin\System\Simulation`, `SimulationInit`) are both 0. Its motor-only simulation still drives the *real* HV supply.
- The hardware configuration (ports, tube, shutter, motors, safety flags) has **not changed** since shipping (10 Dec 2024). Between snapshots, only measurement recipes, detector serial labels, one Beta limit and user profiles changed.

### 1. PC port / USB device map

The USB tree is: PC port HS07 → Realtek hub `0BDA:5411` → (a) hub `1A40:0101`, which carries COM1 and COM8/COM9, and (b) 4-port hub `14B0:0439`, which carries both MiniPIX and COM4 (pnp_props.txt, `DEVPKEY_Device_Children` / `LocationInfo`). The FTDI chip types come from the USB `bcdDevice` revision: 0x0500 is FT2232C/D, 0x0600 is FT232R, 0x0700 is FT2232H and 0x1000 is FT-X (live_enum_usb_*.txt `HardwareID ...REV_xxxx`).

| PC port / USB device | Chip, serial no., channel, USB description | Instrument subsystem | Evidence | Confidence |
|---|---|---|---|---|
| **COM1** | FT-X series (REV_1000), SN DM711K8H, "Fast USB to RS-232 Adapter", hub 1A40 port 1 | X-ray HV power supply (Spellman serial; `HiVoltageControl=5`, probably the "MINI-SPELLMAN" entry (inferred); `SpellmanMFX50W=1`) | `System\Tube\COMPort=1`, `SpellmanSerial=1` (parsed_live_hkcu.txt L11255, L11266); `C:\Xrdwin Log Files\text11.txt` (10,895 W:/R: pairs; the "ps cmd" strings next to it in XrdWin.exe suggest it is the power-supply traffic log (inferred)); manual p.42 §9.2.1 ("3 separate communication channels … PLC, intelligent motors and X-ray power supply") | High |
| **COM8** | FT2232D (REV_0500), SN FT6SEZFV **channel A**, "USB to RS-422/485 Adapter", hub 1A40 port 2 | Safety PLC: shutter solenoid, X-ray on/off relays, beacons, key and interlock inputs | `System\Shutter\COMPort=8`, `UseTrilogi_PLC=1`, `FMDSUPERPLC=1` (L11195, L11238, L11200); log line `PLC_Read2: Sent: @01RO0000*` (Xrdwin Log Files\*.log); manual p.42 §9.2.2 | High |
| **COM9** | Same FT2232D, **channel B** | Motion: 3 integrated stepper motors on the RS-485 bus (X, Z, Beta) | `System1\...\Controllers General Configuration\COMPort0..2 = 9` (L3965-3967); `System\...COMPort=9` (L6676); log `Cannot Open \\.\COM9` on the days the controller was unplugged (07-2025.log, 10-2025.log); manual p.43 §9.2.3 ("RS485 industrial bus") | High |
| COM3 | Intel AMT Serial-over-LAN (motherboard) | None. The registry still points an unused strain-cell option at it (`Strain\COMPort=3`, `UseCellStrainDevice=1`) | Get-PnpDevice (Ports class); L11249-11252 | High (not part of the instrument) |
| COM4 | FT232R (REV_0600), SN B001DBYC, "FT232R USB UART", **detector hub port 4** | Unknown. The only registry reference is `RefocusLaserOADM\COMPort=4`, and that option is disabled (`UseRefocusLaserOADM=0`) | pnp_props.txt; L11190, L11235 | Low |
| COM5 / COM7 | FT2232H (REV_0700) **channel B** of SN FTDM8KES / FTDM8KJE | Second (serial) channel of each MiniPIX board. Nothing in the registry refers to it (inferred unused) | pnp_props.txt `BusReportedDeviceDesc` "WidePIX MiniPIX T3WA sn: 2012" / "sn: 2013" | High (identity); Low (use) |
| FTDM8KES / FTDM8KJE **channel A** (no COM number) | FT2232H "USB Serial Converter A", FTDIBUS (D2XX) driver only | MiniPIX data links used by Pixet/pypixet: **sn 2012 (hub port 3)** and **sn 2013 (hub port 1)** | pnp_props.txt (no Ports child on MI_00); PixetPro configs `MiniPIX-2012.xml`, `MiniPIX-2013.xml` | High |
| HASP dongle | USB VID 0529 / PID 0003 "Sentinel HL" (HID), PC port HS06, first seen 2025-07-15 | XrdWin licence key | XrdWin.exe strings "HASP not found !", `hasp_windows_62423.dll` in the install folder | High (dongle); Medium (required at start-up) |
| Hub `1A40:0101` | "USB 2.0 Hub"; its only children are DM711K8H and FT6SEZFV. First seen 2025-10-01 15:45 | The controller's internal 3-channel USB hub, i.e. the "Controller USB cable" (inferred) | pnp_props.txt; manual §9.2.1 | Medium-High |
| Hub `14B0:0439` (+ USB3 twin `0438`) | "USB2.0 4 Port HUB", with FTDM8KJE on port 1, FTDM8KES on port 3 and B001DBYC on port 4 | Detector hub in the goniometer breakout box, i.e. the "Detector USB cable" (inferred) | manual p.15 §2.4 "USB HUB: Combines both detector µUSB-A cables" | Medium-High |
| Hub `0BDA:5411` / `0BDA:0411` | Realtek USB 2.1/3.2 hub on PC port HS07. It also carries the SanDisk stick that is drive **D:** | External hub or dock between the PC and *both* instrument cables (inferred) | pnp_props.txt; Get-Disk (D: = "USB SanDisk 3.2Gen1") | Medium |
| Camera | Only the Dell integrated webcam (`0BDA:557B`) | The Proto alignment camera (AvCapWPF) is **not connected**, and none has ever been enumerated | Get-PnpDevice Camera/Image (present and non-present); `System\Cameras\Camera1/2` empty (L6671) | High |

All six FTDI ports have the same driver settings (`LatencyTimer=16`, identical default `ConfigData`), so no custom baud aliasing is set up (live_enum_ftdibus.txt; "default" is inferred).

### 2. Which registry branch is live: `System` vs `System1`

`Constants\System` has `DualSystem=1`, `OnlyPortable=1` and `SystemType=1` (L3950-3955). XrdWin's tooltips say "Enabled: dual system: LABORATORY and PORTABLE" and "Check this if you want only the portable system" (registry-config\xrdwin_exe_strings.txt, near 0x615c3f). Three independent checks show that **`System1` holds the active portable (iXRD Mini) settings for the tube and the motors**:

- **Motors.** XrdWin's logs show moves on axes `(Table,Z)` and `(Head1,Beta)` at **28,500 counts/mm** and **1,825 counts/degree**. Those are exactly the `System1` scale factors. The `System` records use 500 (Xrdwin Log Files\*.log `MoveMotorAutoCorrect … DesiredPos -142499(-5.00)`).
- **Tube.** The exposure logs record 18.00 kV / 1.00 mA with Cr or Mn targets (`ExposureXRay_*.log`). Only `System1\Tube` has those values and has Mn enabled. Each `.mt` data file also stores 1.0 and 18.0 as numbers at header offsets 0x0D/0x15 (read as mA and kV; inferred).
- **Write times.** `System1\Tube` was last written on 2026-09-20, the last measurement day. Most `System` hardware keys have not been written since 2025-02-27 (read-only `winreg.QueryInfoKey`, `_synth\config\reg_lastwrite.py`).

The COM-port keys are an exception: XrdWin reads them only from fixed paths `Constants\System\Tube` and `Constants\System\Shutter` (literal strings next to "COMPort" in XrdWin.exe, 0x614b7c-0x614bb8). So the **effective configuration is a mix of the two branches**.

### 3. Axis table (active `System1` configuration, all MDrive-type, all on COM9)

| XrdWin axis | Controller index / port | Scale (counts per unit) | Software limits | Speeds min / max / run | Run / hold current | Encoder, microsteps | Notes |
|---|---|---|---|---|---|---|---|
| Table **X** | 2 / 0 | 28,500 per mm (inferred, same as Z) | −100 … +100 mm | 5,000 / 25,000 / 25,000 | 80 / 10 | 512 lines, 256 | `Direction=1` |
| Table **Z** | 1 / 0 | 28,500 per mm (confirmed by log) | −100 … +100 mm | 500 / 40,000 / 25,000 | 70 / 5 | 512, 256 | pendant can jog X and Z |
| Head1 **Beta** | 0 / 0 | 1,825 per degree (confirmed by log) | −45 … +55 ° | 500 / 40,000 / 4,000 | 67 / 5 | 512, 256 | `MaxPositive` 48.0 → 46.5 at install; `Backwards=1` |

Sources: `System1\Motors Configuration` (`Controller101=2`, `Controller103=1`, `Controller204=0`, `SelectedController1-3=4`, L6441-6557) and the `5.MDrive\1..3` records 01204 / 02103 / 03101 (axis_table.txt, System1 section). Several points are inferred. The name "MDrive" comes from `SelectedController=4`, read as a zero-based index into `PosibleController1-6`, and it matches the manual's "intelligent stepper motor … 512 lines … RS485". The group codes (1 = Table, 2 = Head1) are confirmed by the log axis names. Speed units are not known.

The global `Constants\Motor Axis Limits` are Beta ±50°, X ±130, Y ±100, Z ±250 and Phi ±180 (L3622-3632). The manual gives Beta ±45° and Z 0-255 mm. The `System` branch (and the `1.Mycom MAC-300` subkeys) hold different, stale assignments that do not match this hardware (inferred).

### 4. Tube / HV and shutter / PLC settings

| Setting | `Constants\System\Tube` (L11254) | `Constants\System1\Tube` (L6587) | Comment |
|---|---|---|---|
| COM port, protocol | `COMPort=1`, `SpellmanSerial=1`, `HiVoltageControl=5` | no COM value; `HiVoltageControl=5` | only `System` supplies the port |
| UI limits `MaxKV` / `MaxmA` / `MaxKW` | 25 kV / 2.00 mA / 0.05 kW | **20 kV / 1.00 mA / 0.02 kW** | manual p.16: 20 W tube, recommended ≤ 18 kV and 1 mA |
| `HardwareMaxkV` / `HardwareMaxmA` | 50 / 2.00 | 50 / 2.00 | a tooltip calls these the 0-4095 scaling for the supply, "not used to limit" the user interface |
| Tubes enabled, set-points | slot 1 Cr at 20 kV / 1.8 mA | slots 1 **Cr** and 3 **Mn**, 18 kV / 1.00 mA | the logs match `System1` |
| Gain-collection kV / mA | 15 / 1.5 | 18, 14, 13, 11 kV at 1.00 mA | a few 13 kV entries appear in the exposure logs |
| Filament limit / preheat | 1.90 / 0.50 | 0.07 / 0.25 | which pair applies is unknown |

The legacy block `Configuration\System Configuration` ("XRayTube HVControiller"=KEVEX, MaxmA 5.0, `XRayTube=0`) is not referenced by name in the current XrdWin.exe (byte search, `_synth\config\binsearch.py`), so it is inferred unused.

**Shutter / PLC (`System\Shutter`, L11192-11239):** `COMPort=8`, `UseTrilogi_PLC=1`, `FMDSUPERPLC=1`, `UsePLC_T100MD_1616=0`, `NoShutter=0`, `OldShutter=0`, `DelayShutter=333` (units not known), `DoorInterlockTriggerDontMove=0`, `DontResetRelays=0`, `XRayTracking=0`, `ResetXRayLED=0` and `PLCUseOnlyRelaySystemBit_Prototype=0` (tooltip: "use 2 new outputs: initialize and xenable"). `UseTimer=1`; its tooltip reads "for … Trilogi_PLC: software auto timer (5 min)". `HV_MSB1=2` and `HV_LSB1-4=3` are probably PLC bit assignments (inferred). `System1\Shutter` has no PLC or COM values, and it has `UseTimer=0` and `XRayTracking=1`, so which timer and tracking values apply is unknown. The logs show recurring PLC and HV communication errors (215 × "PLC_Read: WriteFile failed", 58 × "Error HV (cmd:20/22 communication error)").

### 5. Detector settings and MiniPIX calibration files

| Item | Value | Evidence |
|---|---|---|
| Detector branch | `CardNumber=7` (probably the "XISL Camera" entry; "Simulation" would be 4) (inferred), `bMinipix=1`, `NumberOfDetectors=2` | L55, L10229, L58 |
| Bias, threshold | 200 V, 3.00 keV (`lflMinipixBias`, `lflMinipixThreshold`) | L10347-10348 |
| Detector 1 / 2 | `strSerialDet1` = MiniPIX **C10-W0115**, left (`DetectorSide1L=1`, `Flipped=1`); `strSerialDet2` = **F06-W0115**, right | L10386-10387, L2836-2865 |
| Geometry | 256 px, 0.055 mm pixel, half-width 7.04 mm (= 128 × 0.055), `Ro=44.0` | L2860, L2911, L2886, L2919 |
| Acquisition mode | `Detector\CAMERA\bEvents=1` (matches `aaa_Events.bat`), `bT3pa=0`, `m_bWaitForHV=1`; exposure 60 s × 1 per detector | L10035, L10041, L10360, L2715 |
| Python paths | `strPythonExe` exists. `strPythonServer` (`C:\Users\Proto\Desktop\iXRD Mini\XrdWin\…`) and `PixelMask` (`C:\Program Files\…\8#2020_1pF_PxlMask.his`) **do not exist** | Test-Path |

The calibration files `D:\MiniPIX-C10-W0115.xml` and `D:\MiniPIX-F06-W0115.xml` (Pixet 1.7.2, 28 Nov 2024) hold, for each chip: a 500 µm Si sensor, 55 µm pitch, 200 V bias, per-pixel calibration arrays (`caliba/b/c/t`), a pixel configuration and a threshold DAC. The DACs (1540 and 1599) convert to **2.99 and 3.01 keV** with the file's own coefficients, (DAC − B)/A, which agrees with the 3 keV in the registry (`_synth\config\xmlcompare.py`). The working copies in `%LOCALAPPDATA%\PixetPro\configs` (Pixet 1.8.0, 27 Feb 2025) are **identical in all 62 shared elements** except version and timestamps. They add new default parameters, such as `MaxAllowedChipTemp=55`. `MiniPIX-2012.xml` contains the C10-W0115 chip section, so USB sn 2012 is probably C10-W0115 and sn 2013 is F06-W0115 (inferred). The same folder also holds configs for four other chips (C08/E08/F08/G08-W0109, July 2023) that the registry never references.

### 6. Safety and automation flags (live values; names confirmed as literal strings in XrdWin.exe)

| Flag (key) | Value | Meaning (tooltip or name) |
|---|---|---|
| `AutoXRayInCollectThread` (XrdWin\System) | 1 | "enables the AutoXRay in CollectThread (… iXRD … PowerSupplySerial, TrilogiPLC)": a collection can switch X-rays on itself |
| `AutoXRayOff`, `CheckForXRay`, `BypassCheckXRayON` (Constants\Detectors) | 1, 1, 0 | X-rays off automatically; X-ray state is checked; the check is *not* bypassed |
| `AutoRetryCollXRayOff`, `AutoRetryCount`, `CollectAutoRepeats` | 1, 3, 5 | automatic re-collection; `retry_reason.txt` logs it |
| `ShutterOpenCloseOnce`, `RetriesShutter`, `RetriesRead`, `SoftwareAutoCorrect`, `RetriesSoftwareAutocorrect` | 1, 1, 4, 1, 5 | shutter and motion-correction retries ("couldn't reach the pos after 10 retries" appears in the logs) |
| `InterlockResetMemory`, `TryRecoveryCOMPorts`, `DisablePhiLimits` | 0, 0, 0 | no automatic interlock reset, no COM recovery, Phi limits active |
| `HomingAxis9and10InInit`, `HomingAxisPowderDiff` | 1, 1 | homing of axes 9 and 10 during init. These appear to be auxiliary R-axes that are not assigned on this unit (inferred) |
| `AutoInit`, `AutoScanPortsInInitThread` (XrdWin\System) | 0, 1 | no automatic initialisation at start-up; COM ports are scanned during init |
| `LockCollectionConstants`, `AdminAccess` | 1, 0 | collection settings locked; no admin mode |

### 7. Simulation / dry-run options (checked carefully)

| Place | Live value | Is it real? |
|---|---|---|
| `XrdWin\System\Simulation`, `SimulationInit` | 0, 0 | **Yes.** These are the only simulation switches the current XrdWin.exe reads (literal strings 0x6405f0-0x640614). The motor dialog has two check boxes: "Simulation" ("Simulates all the hardware other than the acquisition board") and "Sim Motors" ("Simulates the motors, but use the real power supply"). Which check box maps to which value is not confirmed |
| `Configuration\System Configuration\"Simullation Check"` / `"Simullation Password"` | 0 / empty | **No.** Present since shipping, but not referenced in XrdWin.exe, XRDWIN Configuration.exe or ClientApp.exe (byte search) (inferred legacy) |
| `Constants\System\Miscellaneous\bSimulation` / `SimulationPassword` | 1 / "0" | **No.** Copied from the 2019 `x.reg` template and not referenced by the current binary. Despite `bSimulation=1`, the instrument is clearly running real hardware (exposure and HV logs) |
| Detector type "Simulation" (`Constants\System\Detector\Simulation`) | not selected (`CardNumber=7`) | Synthetic detector with parameters Stress −60, Width 75, Intensity 1000. Needed together with the hardware simulation for "Data Analysis access" (tooltip: "needs both simulations enabled: motors and acquisition card") |
| Menu "Simulate" (`XrdWin\Simulation`) | parameters only | Generates synthetic diffraction profiles (stress −600, noise, spikes). Data only (inferred) |
| Licence flag `JoyCardSim_` ("Simulation-Enabled.") | **absent** | The simulation module may not be enabled on this licence (inferred) |

A Pixet "FileDevice" (a virtual detector) was used in PixetPro on 2026-04-23 (`configs\devcontrol_0.ini`). The MiniPIX TCP server treats a FileDevice as "none", so it gives no XrdWin dry run.

### 8. What changed between snapshots

| Period | Changes (diff_*.txt) |
|---|---|
| Ship 2024-12-10 → install 2025-02-25 | Measurement recipe only (ROI, background windows, exposure 15 → 10 s, 2 → 1 exposures, refocus distance 15 → 5), fitted peak positions, `FocusBacklash`, and `System1` Beta `MaxPositive` 48 → 46.5. No port, tube, shutter or safety changes |
| Install → backup 2025-02-27 (end of training) | `JoyCardS_` (SquareMap licence) removed; Beta angles 11 → 1; two-peak fitting on; material changed; **`strSerialDet2` changed to C10-W0115, so both detectors had the same name** (inferred error) |
| Backup → live 2026-09-30 | 292 new keys, all of them user profiles (19 operator profiles; names not reproduced); `JoyCardS_=5` back; **`strSerialDet2` restored to F06-W0115** (`Detector\XISL` last written 2025-05-12); `nQuickGain` 3 → 0; 11 Beta angles (±30°); exposure 60 s; new material C103 (BCC 220 at 155°); `System1\Tube` Mn slot enabled and gain kV 13 → 18; `CalculateNormalToSurface` and `PromptMsgForPhi` 1 → 0. **No change** to COM ports, `System\Tube`, the shutter, the controllers, motor assignments or safety flags |

Hardware events outside the registry diff (PnP dates, logs; inferred causes):
- **2025-07-14/15:** COM9 missing; the HASP dongle was first enumerated, and `System1\5.MDrive\1` was last written, on 07-15. Probably a service visit.
- **2025-10-01:** COM9 missing at 15:42, then the controller hub was re-enumerated on a new USB path at 15:45.
- **2026-02-02:** FTDI driver 2.12.36.20 reinstalled for all ports.

### What this means for Claude control

- COM1, COM8 and COM9 belong to XrdWin. Its log shows `Cannot Open \\.\COM1, error=5` on 2024-12-04. Error 5 is "access denied", which usually means another program already had the port open. Opening any of these ports would disrupt XrdWin and bypass its PLC and HV safety logic, so Claude must never open them.
- Any tool that reads the configuration must use **`System1` for tube limits and axes**: 20 kV / 1 mA / 20 W; X and Z ±100 mm; Beta −45…+55°. It should take the COM ports from `System`. Relying on `System\Tube` alone would overstate the allowed current by 2×.
- Passive monitoring is possible now, read-only: the HKCU registry (current recipe, material, data path), `C:\Xrdwin Log Files\ExposureXRay_MM-YYYY.log` (every exposure with target, kV, mA and duration), the monthly logs, and `text11.txt` (the HV serial dialogue, useful for the protocol section). XrdWin rewrites its keys while it runs (`XrdWin\System` was written today at 18:33 UTC), so Claude should **not write the registry**. Backup and restore already exist in `XRDWIN Configuration.exe` and in XrdWin itself (`regedit /e`, `regedit /s`), for a human to use.
- Pressing Collect in the GUI can probably energise the tube on its own (inferred from the `AutoXRayInCollectThread` tooltip), and XrdWin can retry automatically. Any GUI automation must therefore be treated as an X-ray-generating action, with an operator present.
- There is no ready safe dry-run mode. The cleanest option is a *separate Windows user account*: HKCU is per user, so its own XrdWin settings could be created with `Simulation` on and the Simulation detector selected. This would need the HASP dongle, lab-manager approval and a human to set it up (inferred; untested).

### Open questions

- Which of `Simulation` / `SimulationInit` is the "Sim Motors" check box? Is the simulation module licensed (`JoyCardSim_` is absent)?
- Which shutter settings (`UseTimer`, `XRayTracking`) and which filament limits (`System` 1.90 vs `System1` 0.07) does the portable mode actually use?
- What is on COM4 (the FT232R on the detector hub)? Is it the pendant, a laser sensor or something unused?
- What do `DelayShutter=333`, `HV_MSB/LSB`, `MaxNegative/MaxPositive` and the speed units mean?
- Confirm the USB sn ↔ chip mapping (2012 = C10-W0115?) and that Det1 = left (L1).
- Why were `strPythonServer` and `PixelMask` left pointing at non-existent paths, and how does XrdWin find the server script anyway?
- What triggers XrdWin's built-in `regedit /s x.reg` (the 2019 template)? Could it overwrite this configuration?
