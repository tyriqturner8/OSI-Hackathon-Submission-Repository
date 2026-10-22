## Measurement data files and how to read them

**Key points**

- XrdWin saves every measurement as a **binary "document"** named `DDMMMYY_NNNN.<ext>` (for example `20SEP26_0014.mt`) in the current project folder. It is `C:\XrdWin Data\24193-24172T\Donovan Cr Tube` right now. The newest real measurement is `20SEP26_0014.mt` (20 Sep 2026 16:04:57). The only measurement-type file written today is an empty square-map placeholder, `30SEP26_0001DataMap00.s3d` (14:01:42), whose stress values are all zero. `D:\XRDWin Measurements` holds byte-identical copies of 17 files from Nov 2024.
- The binary `.mt` (multiple exposure: stress), `.st` (single exposure) and `.as` (retained austenite) files are now **partly decoded and checked against independent sources**. Two kinds of content can be read reliably. The first is the **raw detector profiles**: 256 channels × 2 detectors × each β tilt, plus a background ("gain") curve. The second is the **stored results**: normal and shear stress ± errors, austenite volume fraction, material constants, β list, exposure, ROI and background windows, operator, sample description and start time.
- A profile is simply the **column sums of the MiniPIX "Event" (hit-count) frame**. This was checked exactly against the last frames left in `C:\temp`. XrdWin "Det 0" is the MiniPIX C10-W0115 frame reversed left to right (`test_2_*`), and "Det 1" is F06-W0115 (`test_1_*`).
- The text files are simple. `.xye` holds 2θ and intensity with the wavelength on the first line. Pixet `.pmf` is a 256×256 text matrix, with its metadata in the `.pmf.dsc` file. XrdWin's own *File → Export* files (`.Profile`, `.ProfileGain`, `.Gain`) describe their own layout.
- A stdlib-only reader, `tools/ixrd_read.py`, handles all of the formats above. It was run on every sample file and on all ~1,520 data files under `C:\XrdWin Data`. It decoded the data blocks in 1,260 of 1,265 `.mt`, 213 of 214 `.st` and all 10 `.as` files. The stored stress matched the printed XrdWin report **exactly in 122 of 163** report/file pairs (`reference/ixrd_read_test_output.txt`).

### 1. Where the files are and how they are named

| Item | Value | Evidence |
|---|---|---|
| Current data folder | `C:\XrdWin Data\24193-24172T\Donovan Cr Tube` (`Data Path`); project root `C:\XrdWin Data\24193-24172T` (`Projects Path`) | registry `HKCU\...\XrdWin\System` (data-formats\xrdwin_reg_query.txt L11510-11513) |
| Index counter | `LastIndex=0xe` (14), `LastData=09202026`. This matches the newest file `20SEP26_0014.mt` | same key, L11514, L11519; file listing |
| Recent files | `20SEP26_0004.mt`, `17SEP26_0004.mt`, `28APR26_0004.tm`, ... | `Recent File List` L11467-11471 |
| Newest files on the PC | `20SEP26_0002…0014.mt`, mostly 11 β tilts, operator "Donovan", sample "Al sample 20", Al(222) with Cr Kα. `30SEP26_0001DataMap00.s3d` holds 5 zero stress values (a map was set up today and nothing was collected (inferred)) | directory search by modification time; test output §2 |
| Naming | "SET, MET, TRI, SM, TM … followed by the date number and the file index … incremented automatically" | sw-manual\xrdwin_manual.txt L206-209 |
| D:\ copies | All 17 files in `D:\XRDWin Measurements` have the same SHA-256 as `C:\XrdWin Data\24193-24172T\Cr Tube\*`. Their times are 1 h earlier because D: is FAT32, which stores local time (inferred) | Get-FileHash comparison |
| Detector scratch | `C:\temp\test_{1,2}_{Event,iToT}.pmf(.dsc)` and `test_{1,2}_1_{Event,iToT}.png` are overwritten on every exposure. The current set is from 20 Sep 2026 16:03:49 (61 s), i.e. the last β of `20SEP26_0014.mt` | .dsc "Start time"; tcpserverMiniPix2D_Event.py L51, L125, L150; XrdWin strings L8113-8140 |

File types the manual lists (xrdwin_manual.txt L210-238): `st` single exposure, `mt` multiple exposure, `tr` triaxial, `sm` square map, `tm` teach map, `map` teach-map coordinates, `as` austenite, `xls`/`doc` reports, `Gain` background.

### 2. Format summary

| File | Text/binary | What it holds | Confidence | Reader |
|---|---|---|---|---|
| `.mt` | Binary (MFC serialisation, version 87, tag "XrdWin32") | Stress measurement: settings, **stored σ, τ ± errors**, β list, and raw profiles for each β × 2 detectors × 256 channels (counts and gain) | Medium-high (fields listed in §3 checked) | yes |
| `.st` | Binary, same prefix | One exposure: settings plus a single 256-channel profile for each detector; no stress | Medium-high | yes |
| `.as` | Binary, same prefix | Austenite: peak table (integrated intensity I and R factor per peak), **V_γ**, and four 256-channel windows | Medium-high | yes |
| `<name>.xye` | Text | One 256-point window (2θ, I, "1") in MiniPIX style | High | yes |
| `<name>_xrdwin.xye` | Text | The four austenite windows joined into 1024 points (2θ, I) | High | yes |
| `.pmf` / `.pmf.dsc` | Text | Raw MiniPIX 256×256 frame (Event counts or iToT) plus metadata (chip ID, bias, threshold, start time, acquisition time) | High | yes |
| `.png` | Binary image | 8-bit greyscale preview of a frame; not usable for counting | High | header only |
| `.Profile`, `.ProfileGain`, `_2th_.ProfileGain`, `.Gain`, `M.Gain` | Text (XrdWin export) | The same profiles as the binary file, optionally with a 2θ column | High | yes |
| `.sm`, `.tm`, `.tr`, `.s3d`, `.map`, `*backup.txt`, `*exportsetup.txt`, `*DataNPhiX.txt` | Mixed | Maps, triaxial runs, map results, coordinates, export setups, triaxial result tables | Low (seen, not decoded) | prefix only / no |

### 3. The binary documents (.mt / .st / .as)

**Structure.** XrdWin writes its documents with the Microsoft MFC library's standard file-saving method, so each file is a sequence of little-endian int32 numbers, float64 numbers and length-prefixed text strings. Because the strings have variable length, the byte offsets change from file to file. The reader therefore walks through the strings in order and uses other fields as anchors. Only fields that were checked are given names; everything else is returned raw.

| Field (in file order) | How it is located | Example (`10DEC25_0016.mt`) | Checked against |
|---|---|---|---|
| Archive version, app tag | int32 at 0, then a string | 87, "XrdWin32" (all ~1,690 binary documents) | survey of every `.mt/.st/.as/.sm/.tm/.tr` file |
| Tube mA, kV | float64 ×2 right after the tag | 1.00 mA, 18.0 kV (13 and 19 kV also seen) | 224/224 PDF reports agree |
| Operator, start date/time, sample description | string, 6 × int32, int32, string | "Langdon", 2025-12-10 14:54:09, "CHN_unpeened" | PDF "User/Date/Description" (EI-35.pdf) |
| 7 strings; the 6th is **Direction** | strings | "Short" | PDF "Direction: Short" |
| `result_mode` (unknown int) | E+0x39 (E = end of the 7 strings) | 3 (almost all files); 2 (17 files) | — |
| **Stress, shear, stress error, shear error** (MPa) | 4 × float64 at E+0x79 (mode 3 only) | −443.65, 7.36, 7.40, 3.67 | PDF "Stress = −443.65 ± 7.40 MPa, Shear 7.4 ± 3.7" |
| n_β, then the β list (deg) | int32 after the result block, then n × float64 | 5: 30, 11.8, 0, −11.8, −30 | PDF table; text export β list |
| Background channels, each detector | 4 × int32 at n_β+0x150 / +0x160 | [31,41,223,233], [29,39,216,226] | PDF "Backgr. fit" |
| Exposure time and number of exposures, each detector | n_β+0x190… | 30 s × 1, 30 s × 1 | PDF |
| Material record | 5 × float64 (2θ₀, d₀, 1/(½S₂), 1/(−S₁), λ), 2 × int32, then strings hkl, lattice, name, radiation | 156.41°, 1.1702087 Å, 168918.92, 781250 MPa, 2.291 Å, "211", "BCC", "STEEL - FERRITIC (Cr_Ka)", "Cr_K-Alpha" | MATERIAL.CFG row; PDF (½S₂ = 5.92e-6, −S₁ = 1.28e-6 /MPa) |
| **Psi-zero channel** for each detector, peak-fit %, Aperture, Filter | 40 bytes after the 3rd material record | 131.39, 132.88; 85 %; "2 mm"; "NA" | PDF "Psi Zero Assignment", "Gaussian 85%", "Aperture", "Filters" |
| ROI for each detector | int32 pairs after the Filter string | [34,230], [23,218] | PDF "Region of Interest" |
| "XrdWin2" string, then n_β × 32 bytes of int flags (meaning unknown) | string | — | size rule below |
| **Profiles** | n_β × 256 × [det0 counts, det0 gain, det1 counts, det1 gain] as float64, to end of file | — | text export equal value for value (§5) |

The material records across the `.mt` files are:

| Material | Radiation | Plane | Files |
|---|---|---|---|
| Austenitic stainless | Mn Kα | 311 | 1,008 |
| Ferritic steel (two MATERIAL.CFG entries) | Cr Kα | 211 | 233 |
| Aluminium | Cr Kα | 222 | 9 |
| Others | | | ≤5 each |

Elastic constants are stored in MPa even when MATERIAL.CFG gives them in ksi: Al 7814.26 ksi is stored as 53,879 MPa.

Size rule (checked on 1,260 `.mt` and 213 `.st` files): file size = end of "XrdWin2" + n_β × (32 + 8192). An 11-β `.mt` is therefore about 91.9 kB, and a `.st` (n_β = 1, stored β = 0) is about 9.6 kB.

**What the profile numbers are.**
- Channel 0 is the **high-2θ end**. Counts are summed MiniPIX hits. For the last β of `20SEP26_0014.mt`, Det 1 equals the column sums of `test_1_Event.pmf` exactly, and Det 0 equals the reversed column sums of `test_2_Event.pmf` exactly (test output §2). This matches the export header `Flip Status:1 0`. The PDF reports call file Det 0 "Detector 1" and Det 1 "Detector 2": the psi-zero values 131.39 and 132.88 sit in that order.
- With several exposures per β the stored values are averages; values ending in .5 appear in the 2-exposure files (inferred).
- The **2θ of a channel** is not stored per channel. XrdWin's `_2th_` exports follow `2θ = 2θ₀ + (psi0_channel[det] − channel) × 0.07193°` to within 0.005° (the rounding of the export) for two files. The 0.07193°/channel slope is **empirical**: the header also contains 7.04 mm, 0.055 mm and 44.0, which look like detector geometry (inferred), but they have not been connected to the slope.
- **ψ for each point** is β − (180° − 2θ₀)/2 for Det 0 and β + (180° − 2θ₀)/2 for Det 1 (±11.80° for Fe 211 with Cr Kα, matching every row of the EI-35.pdf table; −13.60 at β = 0 for Mn Kα 311).
- Per-β peak positions, FWHM and so on were **not found** as float64/float32 numbers in the header of `10DEC25_0016.mt`, so XrdWin probably recomputes them when a file is opened (inferred).
- As a check, a quick re-fit from the raw profiles (linear background, Gaussian over the top 15 %, no LPA or gain correction) gave −442.6 MPa for `10DEC25_0016.mt` against the stored −443.65. For `21NOV24_0015.mt` the same check gave −512.7 against −474.9, so a proper re-analysis needs XrdWin's corrections (`_synth\data\recompute_stress.py`).

**.as (austenite) specifics** (`25NOV24_0003.as`, standard "PRA 19085 (5.1)"):
- The file contains int n_α, then n_α × (I, R, label), then int n_γ, then n_γ × (I, R, label), then float64 **V_γ**.
- In this example the labels are BCC(211), BCC(200), FCC(220) and FCC(200), R = 201.36, 22.07, 57.64 and 38.21, and V_γ = 0.0507. The mean of I/R per phase reproduces V_γ **exactly** in all 7 distinct complete files (test output §1). The other 3 `.as` files (`Proto Training\27FEB25_0001-0003`) have zero intensities or NaN and are incomplete runs (inferred).
- Four windows follow, each 256 × (counts, gain) as float64, stored in the order of the registry settings `Mini2Theta1..4` = 156°, 128°, 106°, 79° (xrdwin_reg_query.txt L651-661). The rest of the 132 kB file is zero padding.
- The fractional parts of the counts (.5, .25, .5, .25) match `NrExpMini1..4` = 2, 4, 2, 4, so each window is an average over its exposures (inferred).

**Limits.** One `.mt` file is empty (0 bytes). Four `.mt` files and one `.st` file (`RV\30APR25_0014-0016`, `RV\01MAY25_0023`, `Farshad\16FEB26_0035`) contain extra embedded file-path strings, possibly for powder correction (inferred), or an unknown `result_mode`. For these the reader returns only the header, with warnings. In the 17 `result_mode = 2` files the profiles are read but the stress block is returned raw. The reader does not decode `.sm`, `.tm` or `.tr` beyond the common prefix.

### 4. Text formats

| Format | Layout | Evidence |
|---|---|---|
| `<name>.xye` | Line 1: wavelength `%.4lf` (2.2910 = Cr Kα mean). Then 256 × `2θ\tI\t1`; the third column is a constant 1, not an error. Its intensities equal the 156° window of `_xrdwin.xye`, with 2θ offset by about one channel (+0.07°) | XrdWin strings L8146-8149 (`.xye`, `%.4lf`, `%.2lf\t1`); RADTYPE.CFG; compare script |
| `<name>_xrdwin.xye` | Line 1: `%.6lf` (2.289700 = Cr Kα1). Then 1024 × `%15.4lf\t%15.4lf` in four windows (70.5-88.9, 97.5-115.9, 119.5-137.9, 147.5-165.9°). It is the `.as` window array fully reversed, so 2θ increases | strings L24592-24595 (class `CXrdWinDocAustenite`); test output |
| `.pmf` | 256 text lines × 256 integers per frame (a line is a detector row). `Event` = hit counts (u32); `iToT` = integrated time-over-threshold (u64). A multi-frame file stacks the frames | SDKPythonManual.txt L484-486, L538-541; tcpserver L120 (op mode 2 = Event + iToT) |
| `.pmf.dsc` | Starts with `A000000001`, then `[F0]`, `Type=u32 matrix width=256 height=256`, then items in the form `"Name" ("Description"):` / `type[count]` / value. Items include Acq time 60.997 s, ChipboardID F06-W0115 or C10-W0115, HV 200 V, Threshold ≈3.0 keV, Mpx type 4 (Timepix3), Pixet 1.8.0, start time | C:\temp\*.dsc; SDK manual L495, L520 |
| XrdWin export (`.Profile`, `.ProfileGain`, `.Gain`) | The header gives the number of map points, φ, β (with list), channels (256) and detectors (2), then Active/LeftRight/Flip status. Each (point, φ, β) block has columns `[2Theta] Prof [Gain]` per detector and ends with `*****` | format strings L6473-6503; export files in `C:\XrdWin Data\...\RV2`, `PNNL project`, `Farshad` |

### 5. The reader and its test

- `tools/ixrd_read.py` (Python 3.7, standard library only, read-only) provides `read_xye`, `read_pmf`, `read_pixet_dsc`, `read_png_info`, `read_xrdwin_export`, `read_xrdwin_binary`, `pmf_column_profile` and `approx_two_theta`, with command-line modes for summary, `--json`, `--csv` and `--selftest`.
- `tools/ixrd_read_checks.py` regenerates `reference/ixrd_read_test_output.txt`, which contains:
  1. A summary of every sample file.
  2. The newest `.mt` and the exact frame cross-check.
  3. Binary versus text export: counts and gain identical for 7-β and 9-β files, the gain columns identical to `16FEB26_0034M.Gain`, and the 2θ approximation within 0.0051°.
  4. The PDF stress comparison: 122 of 163 exact. All 14 in `EI_Projects` match. The 41 misses are all in `PNNL project`, and most differ by tens of MPa (up to about 100). The likeliest reason is that the report was printed after re-fitting without re-saving (inferred).
  5. The robustness counts.

### What this means for Claude control

- **Claude can get results without touching XrdWin or the instrument.** It can watch the `Data Path` folder (registry) for a new `DDMMMYY_NNNN.mt` and wait until the file's modification time stops changing. It can then read the stored stress ± error, the settings and the raw profiles with `ixrd_read.py`. All of this is read-only file access.
- **Live progress** can be followed from `C:\temp\test_*_Event.pmf(.dsc)`. These files are rewritten for every exposure, and their column sums *are* XrdWin's profile. Claude must only read them after the `.dsc` time has updated, and must never delete or lock them, because XrdWin probably reads them back to build the profile (inferred).
- A stored stress is **the result at the last save**. Printed reports can differ (41 of 163 here). An automated pipeline should record which file and time a number came from, and for critical work re-analyse the raw profiles. That needs XrdWin's LPA and gain corrections, which are not yet reproduced.
- For hand-off to other software, XrdWin's own *File → Export* output and the `.xye` files are the safest formats, because they describe their own layout. The binary decoding is reverse-engineered for archive version 87. The reader checks the size rule and gives a warning instead of guessing, and it should be re-validated after any XrdWin update.

### Open questions

- What does `result_mode` (2 versus 3) mean, and how is the stress block laid out for mode 2 (17 files)? What are the unknown values after the four stress numbers (for example 157.0, 158.0, 730.29)?
- Where does the 0.07193°/channel dispersion come from? How does it relate to the 7.04 mm, 0.055 mm and 44.0 values in the header, and does it change if the detectors are re-aligned?
- Why do 41 PNNL reports disagree with the stored stress? Were they re-fitted without saving, or is there a second result that the reader is not locating?
- What are the extra path strings in the five partly decoded files? What do the per-β int flags mean? What are the layouts of `.sm`, `.tm`, `.tr` and `.s3d`?
- Is the 3-column `.xye` written only for the first austenite window? Why is its 2θ axis about one channel off from `_xrdwin.xye`?
- Does the running XrdWin (PID 4492) hold an unsaved document behind today's `30SEP26_0001DataMap00.s3d`?
