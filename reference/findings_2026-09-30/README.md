# iXRDmini: connecting Claude to the instrument
### Findings from 30 September 2026 (investigation paused, to be continued)

Instrument: Proto Manufacturing **iXRD Mini** (residual stress / retained austenite), system 24193/24172T. It runs from this PC with **XrdWin 2.0** (build dated 2024-11-18) and two **Advacam MiniPIX** detectors.

All work today was **read-only**. No COM port was opened, no instrument socket was connected, and XrdWin (which was running) was not touched. No settings were changed.

---

## 1. Summary: can Claude read data and control the instrument?

| Layer | Can Claude do it? | How | Confidence |
|---|---|---|---|
| **Read and analyze measurement data** | **Yes, now** | `tools/ixrd_read.py` decodes XrdWin's binary `.mt` / `.st` / `.as` documents: raw detector profiles per β tilt plus stored stress ± error, austenite %, constants and metadata. It also reads `.xye`, `.pmf`/`.dsc` and exports. Tested on ~1,500 files; stored stress matched XrdWin's printed reports exactly in 122 of 163 checked pairs. | High |
| **Control the two MiniPIX detectors** | **Yes, with conditions** | Through the existing Python TCP server on `localhost:8094` (init, bias, threshold, collect, abort), or `pypixet` directly. Only one program can own the detectors, so this must not run while XrdWin uses them. | High |
| **Run measurements (motors, X-rays, shutter)** | **Likely, via XrdWin's GUI** | XrdWin has **no remote/automation API** (no DDE, COM automation or incoming socket). Claude would operate XrdWin's standard MFC menus and dialogs through Windows UI automation plus screenshots, with a person supervising. | Medium; to be tested next session |
| Talk directly to HV supply / PLC / motors over serial | Technically possible | COM1 / COM8 / COM9 | **Not recommended.** It bypasses XrdWin's safety logic, and the protocols are undocumented. |

**Recommended design:** XrdWin stays in charge of the hardware and its safety logic. Claude gets a small tool set, possibly an MCP server, with these parts:
1. Data reading and analysis (safe; ready to extend).
2. Detector commands, used only when XrdWin isn't using the detectors.
3. Supervised XrdWin operation: status, set up measurement, start, abort, read results.

---

## 2. How the system is wired (PC side)

| PC device | Instrument subsystem | Confidence |
|---|---|---|
| **COM1**: FTDI FT231X `DM711K8H` | **X-ray high-voltage supply** (Spellman, RS-232) | High (registry + manual + logs) |
| **COM8**: FTDI FT2232H `FT6SEZFV` ch. A | **Safety PLC** (TRi FMD "Super PLC"): shutter, X-ray relays, interlocks | High |
| **COM9**: FTDI FT2232H `FT6SEZFV` ch. B | **Motor bus** (RS-485): X, Z and β motors (MDrive) | High |
| FTDI FT2232H `FTDM8KES` / `FTDM8KJE` (ch. A, no COM port; ch. B = COM5 / COM7) | **Two MiniPIX detectors** (C10-W0115, F06-W0115), on a 4-port USB hub | High |
| **COM4**: FTDI FT232R `B001DBYC` | On the detector hub; its role is not confirmed (refocus laser is disabled in config) | Low |
| COM3 | Intel AMT serial-over-LAN (not part of the instrument) | High |
| VID_0529 USB device | Sentinel HASP licence dongle for XrdWin | High |

Details: `sections/03-configuration-and-device-map.md`, `sections/01-hardware.md`.

**Tube settings actually in use** (live registry `Constants\System1\Tube`, re-checked today): Cr tube, **18 kV / 1.00 mA**, limits 20 kV / 1.00 mA / 20 W. That matches the hardware manual's Cr tube rating (20 W max). A second, older branch (`Constants\System\Tube`) holds 25 kV / 2 mA limits but isn't the one used. 1,637 of 1,649 logged exposures were at 18 kV / 1 mA.

---

## 3. Where the data is

- Live data: **`C:\XrdWin Data\<project>\...`** (projects: `24193-24172T`, `LPBF cylinder`, `PNNL-LPBF`; ~2,370 files). Files are named `DDMMMYY_NNNN.ext`. The newest real measurement is `20SEP26_0014.mt` (20 Sep 2026).
- Logs: `C:\Xrdwin Log Files\MM-YYYY.log`, including X-ray exposure records.
- Detector raw frames: `C:\temp` (`test_1_*.pmf/.png`, `test_2_*`), overwritten each collection.
- `D:\XRDWin Measurements`: 17 factory test files from Nov 2024.

Details: `sections/06-data-formats.md`.

---

## 4. Safety rules any Claude control layer must follow

1. **The hardware interlocks stay in charge.** X-rays require the key switch, the green X-Ray Enable button, closed enclosure interlocks and working beacons. E-stop and Reset are physical. Software must never try to bypass them.
2. **A person must confirm at the instrument** before any X-ray-on or motor move: enclosure closed, nobody near the beam, dosimeter worn.
3. **Go through XrdWin only.** Never write to COM1, COM8 or COM9 directly, and never open those ports while XrdWin runs (opening a port can toggle control lines).
4. Respect the tube limits (Cr: 18 kV / 1 mA recommended, 20 W max), the warm-up rules (7 / 15 / 40 min per the manual) and the ≥10 min cool-down.
5. Be aware XrdWin **acts on its own**. It homes motors at Initialize, turns X-rays on inside a collection, and automatically retries a failed collection up to 3 times. The September 2026 log shows failed X-ray-OFF relay writes to the PLC, so always confirm X-rays are off using the beacon / front panel, not the software alone.
6. Detector bridge: one client only, no authentication. `killaaa.bat` kills **all** `python.exe` processes, so Claude's own Python tools can be killed too.
7. **No safe simulation mode exists.** XrdWin's motor simulation still drives the real HV supply, so a dry run is not possible.

---

## 5. Open questions for next session

1. Can XrdWin's main controls (Initialize, High Voltage, Collect, Abort, Constants fields) be reached by Windows UI automation? This decides how easy measurement control will be.
2. Can the detector bridge be used without closing XrdWin, or does detector-only work require XrdWin to be closed?
3. The role of COM4 / COM5 / COM7.
4. Whether PIXet Pro's `remotectrl.dll` plugin is a usable, official detector interface.
5. Why 41 of the 163 checked `.mt` files didn't match their printed reports exactly (reader edge cases).
6. Whether Proto Manufacturing can provide an official automation interface (worth asking).

## 6. Plan for next session

1. Read-only UI-automation survey of XrdWin's window: list its buttons and fields without clicking anything.
2. Build the Claude tool set in this order: data analysis, then detector commands, then XrdWin status and control.
3. Test live in stages with someone at the instrument: read-only status first, then detector-only acquisition with X-rays off, then motor moves, then a full measurement at the standard settings.

---

## Package contents

| Path | What it is |
|---|---|
| `README.md` | This summary |
| `sections/01-hardware.md` | Hardware, connections, interlocks, procedures (from the 2024 hardware manual) |
| `sections/02-xrdwin-software.md` | XrdWin workflow, menus/dialogs, built-in sequencing (maps, tilt series, batch) |
| `sections/03-configuration-and-device-map.md` | Registry settings, device map, axes, safety flags, changes since shipping |
| `sections/04-detectors-and-pixet.md` | MiniPIX detectors, TCP bridge protocol, PIXet SDK |
| `sections/05-xrdwin-program-interfaces.md` | What XrdWin.exe / ClientApp.exe expose (no remote API) *(partial)* |
| `sections/06-data-formats.md` | File formats and where data is stored |
| `tools/ixrd_read.py` | Python 3.7 (stdlib only) reader for XrdWin/PIXet data files |
| `tools/ixrd_read_checks.py` | Checks of the reader against reports and frames |
| `tools/pe_inspect.py` | Read-only program-file inspector used for section 05 |
| `reference/` | Detector server script, batch files, registry key excerpts, import tables, reader test output |
| `raw/` | Everything collected today: manual text and page images, registry dumps and diffs, SDK manuals, string dumps, working notes |

**Caveats:** today's investigation was stopped early, so the cross-check verification pass did not run. Sections 01–03 and 06 were written by separate agents from the raw material and cite their sources. Sections 04–05 were completed from verified sources and are marked partial. Where sections disagree with each other, this README uses the values re-checked today.
