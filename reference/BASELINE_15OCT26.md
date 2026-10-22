# Baseline for judging today's run (reference: 15 Oct 2026 Mn-tube session)

Written 2026-10-22 from read-only analysis of `C:\XrdWin Data\24193-24172T\Tube Change\*` and
`C:\XrdWin Data\24193-24172T\Donovan Cr Tube\20SEP26_0014.mt` with
`experiment-2026-10-22\tools\summarize_results.py` (per-file CSV + SVG in `prep\baseline\`).
All numbers below come from the raw 256-channel profiles stored in the files (counts, not the gain
curve) plus the results XrdWin itself stored. The "crude" stress is a plain d-vs-sin²ψ line with a
linear background and no LPA / gain / Gaussian-fit corrections, so it is a sanity figure only; XrdWin's
own number is the one that counts.

## 1. Session facts (15 Oct 2026, operator Donovan, tube changed Cr -> Mn)

| File | Time | What | Stored result | Notes |
|---|---|---|---|---|
| 15OCT26_0001.st | 09:53 | TiN (Cr_Ka) single exposure, 0 kV | profiles all zero | aborted/never collected (still Cr material selected) |
| 15OCT26_0003.st | 11:03 | Ni(311) Mn_Ka single exposure 35 s, 2 mm | peaks at ch 208 / 189 | psi0 still 163.00/169.84 (old); peak far from psi0 -> alignment pass |
| 15OCT26_0004.st | 11:10 | same | peaks at ch 206 / 184 | same |
| 15OCT26_0005.st | 11:17 | same | peaks at ch 132 / 150 | sample now near focus; these channels match the later psi0 |
| 15OCT26_0006.mt | 11:19-11:28 | 9 betas +/-30, 35 s x1 | **+448.9 +/- 540.0 MPa**, shear -178 +/- 236 | ROI [[121,234],[131,237]] CUT the Det0 peak (centroid 128-134, within 10 ch of ROI edge) -> garbage |
| 15OCT26_0007.mt | 11:33-11:41 | 9 betas +/-30, 35 s x1 | **-126.4 +/- 74.3 MPa**, shear +38.3 +/- 32.2 | ROI widened to [[34,211],[38,237]], psi0 136.41 / 155.28 |

Exposure log rows (ExposureXRay_10-2026.log): 15OCT26_0003..0007, target Mn, 18.00 kV, 1.00 mA,
aperture "2 mm", user Donovan; .st rows take ~45 s, the 9-beta .mt rows 6:39-7:21 wall time.
Event log 10-2026.log that day: 10:53 benign refocus message; **11:01:30 and 11:01:44
"InitializeThread: ReadMotor(head:1,axis:3) Beta Axis. return FALSE-START: Cannot read the 0 position"
(pos=2.23 then -2.25)**; 11:16 refocus message. The beta-axis home read failed twice during
Initialize, ~20 min before the two stress runs.

Material record in the files: NICKEL (Mn_Ka) FCC(311), 2theta0 165.32 deg, d0 1.06026 A,
lambda 2.10314 A, S2/2 6.5e-6 /MPa, -S1 1.56e-6 /MPa. With 2theta0 = 165.32 the detector offset is
(180-165.32)/2 = 7.34 deg, so psi = beta -/+ 7.34 (Det0 / Det1) and sin²psi only reaches 0.37 at
beta = +/-30 (steel 311 with Mn reaches 0.48, Al 222 with Cr 0.45).

## 2. Typical numbers (per beta, per detector)

| Quantity | Ni 311 / Mn, 2 mm, 35 s (15OCT26_0007) | Aust. steel 311 / Mn, 1 mm, 30 s (29/30JAN26) | Al 222 / Cr, 1 mm, 60 s (20SEP26_0014) |
|---|---|---|---|
| Background level (mean of bg windows), counts/ch | **11 400 - 16 900** | 2 300 - 4 050 | 1 160 - 1 590 |
| Net peak max above linear bg, counts | **9 700 - 42 200** (strongly beta-dependent) | 3 050 - 10 100 (BROAD file 29JAN26_0003: 1 300 - 1 900) | 690 - 1 410 (all but 4 points flagged WEAK < 1000) |
| Peak / background ratio | 0.6 - 2.8 | 1.1 - 2.9 | 0.5 - 1.2 |
| FWHM, channels (x 0.0719 deg/ch) | **26 - 40** (1.9 - 2.9 deg) | 28 - 33 (2.0 - 2.4 deg); 29JAN26_0003: 55 - 70 | 31 - 45 |
| Peak centroid, channels Det0 / Det1 | 113 - 137 / 143 - 153 | 119 - 137 / 126 - 146 | 120 - 127 / 134 - 141 |
| psi0 channels stored (Det0 / Det1) | 136.41 / 155.28 | 122.27 / 130.71 (29JAN); 118.9 / 128.3 (30JAN) | 128.53 / 141.27 |
| Total counts per detector frame | 3.4 M - 5.1 M (35 s) | 0.73 M - 1.17 M (30 s) | 0.35 M - 0.43 M (60 s) |
| Raw max pixel in C:\temp frame | 322 (F06) / 355 (C10) in 35 s, 0 saturated | - | - |
| d-vs-sin²psi rms residual, A | **4.2e-4** | 0.5e-4 - 2.3e-4 | 2.5e-4 |
| Det0-mean d minus Det1-mean d, A | **-3.8e-4** | -1.3e-4 (29JAN26_0002) | ~0 |

Stored vs crude stress for every file analysed (crude = (slope/intercept)/(S2/2), no corrections):

| File | Material | n_beta | Stored (MPa) | Crude (MPa) | Comment |
|---|---|---|---|---|---|
| 15OCT26_0006.mt | Ni 311 Mn | 9 | +448.9 +/- 540.0 | -23.9 +/- 67 | ROI cut Det0 peak; stored value meaningless (error 120 % of value) |
| 15OCT26_0007.mt | Ni 311 Mn | 9 | **-126.4 +/- 74.3** | -151 +/- 129 | same sign, same magnitude; both fits have ~4e-4 A scatter |
| 29JAN26_0002.mt | SS 311 Mn | 7 | -3.1 +/- 6.2 | -4.6 +/- 33 | near-zero sample; crude agrees |
| 29JAN26_0003.mt | SS 311 Mn | 7 | -570.4 +/- 10.9 | -678 +/- 29 | BROAD peaks (FWHM 55-70 ch), weak 1.3-1.9 k counts; crude 19 % high |
| 30JAN26_0002.mt | SS 311 Mn | 3 | +102.9 +/- 3.8 | +74 +/- 39 | only 3 betas -> crude slope poorly determined |
| 30JAN26_0003.mt | SS 311 Mn | 7 | +342.9 +/- 27.9 | +319 +/- 51 | agrees within 7 % |
| 20SEP26_0014.mt | Al 222 Cr | 11 | -54.3 +/- 11.5 | -71 +/- 18 | weak peaks (< 1000 net) but 11 betas and 60 s give a decent fit |

Rule of thumb from these seven: the crude figure lands within ~10-30 % of XrdWin's value and always
with the same sign when the data are good. A sign disagreement or a factor-of-2 difference means the
file (or the fit window) is bad, not the sample.

## 3. Why 15OCT26_0007 has such a large error (-126 +/- 74 MPa), and what it suggests

What the raw profiles show:

1. **Not a weak-peak problem.** Net peak maxima are 9.7 k - 42 k counts, 5-10x the steel runs that
   gave +/- 4-11 MPa. Counting statistics would support an error of a few MPa.
2. **Huge background.** 11-17 k counts/channel, 4-5x the steel runs, mostly because the aperture was
   2 mm instead of 1 mm (4x area). Mn K-alpha (5.9 keV) cannot excite Ni K fluorescence, but the
   18 kV bremsstrahlung above the Ni K edge (8.33 keV) can, and the Timepix3 threshold is 3 keV, so a
   flat Ni fluorescence floor is expected (inferred). High background widens the fit uncertainty but
   does not by itself explain 74 MPa.
3. **The peak position scatter is far bigger than the stress effect.** On Det0 the centroid moves
   from ch 113 (beta -30) to ch 137 (beta -7), i.e. 24 channels = 1.7 deg 2theta, while -126 MPa on
   Ni 311 should move the peak by only about 0.3 deg over the whole psi range. The d-vs-sin²psi
   residual is 4.2e-4 A (steel: 0.5-2.3e-4 A), and the +psi and -psi branches do not lie on one line:
   Det0 at psi = -37 deg gives d = 1.05839 A while Det1 at psi = +37 deg gives 1.05987 A
   (1.5e-3 A apart). That is classic **psi-splitting**, and the Det0 points sit 3.8e-4 A below the
   Det1 points on average.
4. **Likely causes, in order (all inferred, not proven):**
   - **Sample not at the focal point / wrong Z (height) or beta zero offset.** A height error shifts
     2theta by an amount that changes with beta and differs between the two detectors: exactly the
     pattern seen. The beta home read failed twice at 11:01 ("Cannot read the 0 position"), the
     .st alignment exposures 0003/0004 still had the peak 50-70 channels from psi0, and the psi0
     assignment (136.41/155.28) was made on this session's data. A fresh single exposure at beta = 0
     with the peak centred on psi0 on BOTH detectors is the first thing to check today.
   - **Coarse grain / texture in the sample ("GRX 3").** Net peak height varies 4x with beta on
     each detector (Det0: 9.7 k at beta 0 vs 42 k at beta -18), which is what spotty rings do. The
     beta oscillation is on (OscBeta = 3 deg), but if the grains are large a bigger oscillation or more
     betas (NrBetaAngles is set to 11; the file has 9) would help.
   - **Ni 311 with Mn K-alpha at 2theta0 = 165.3 deg** is a very high-angle, very stress-sensitive
     reflection, but with only a 7.34 deg detector offset the usable sin²psi range is small (0.37), so
     any psi-dependent systematic error is amplified into the slope.
   - **Few tilts**: 9 betas is fine in itself (the Jan steel runs used 7 and got +/- 4-11 MPa), so the
     number of tilts is not the main problem.
5. **15OCT26_0006 is a separate, simpler failure**: its ROI started at channel 121 and the Det0 peak
   is centred at 128-134, so the fit window cut off the low-channel half of the peak on Det0 at every
   beta. XrdWin reported +449 +/- 540 MPa. The operator then widened the ROI for 0007. Check the ROI
   against the peak on both detectors before every run.

## 4. What good data looks like (checklist with numbers)

Compare each new file against these before trusting a stress value (the summarize tool prints every
quantity and flags the bad ones):

- [ ] **Exposure log row** present with the expected target (Mn), 18.00 kV, 1.00 mA, aperture and
      user; no "WriteFile failed" / "Cannot" / "End of travel" line in `<MM-YYYY>.log` during the run.
- [ ] **Net peak max >= 3 000 counts** on every beta and both detectors (steel/Mn 1 mm 30 s gave
      4-10 k; Ni/Mn 2 mm 35 s gave 10-42 k). Below 1 000 the tool flags WEAK (the Al/Cr file was
      marginal at 700-1 400 and still needed 11 betas x 60 s for +/- 11 MPa).
- [ ] **Peak / background >= 1**; if the background is above ~10 k counts/channel consider a smaller
      aperture or shorter exposure rather than more counts.
- [ ] **FWHM 25-45 channels (1.8-3.2 deg)**. > 60 channels (as in 29JAN26_0003) means a broad or
      doubled peak and the crude stress drifts by ~20 %.
- [ ] **Peak centroid at least 10 channels inside the ROI on both detectors at every beta** (EDGE
      flag). For 15OCT26_0007 the Det0 peak wandered between ch 113 and 137; the ROI must cover that.
- [ ] **Psi0 check**: on a beta = 0 single exposure the peak should sit within a few channels of
      psi0 on both detectors (15OCT26_0005 had 132 vs 136.4 and 150 vs 155.3, i.e. 4-5 channels off;
      the Jan steel .st files were within 2-3 channels).
- [ ] **Peak position shift across beta should be of the order the stress predicts**: for Ni 311 a
      few channels, not 24. If Det0 and Det1 give mean d values that differ by more than ~2e-4 A,
      suspect height/zero alignment before suspecting the sample.
- [ ] **d-vs-sin²psi rms residual <= 2.5e-4 A** and the +/-psi branches on one line (psi-splitting
      means shear or misalignment).
- [ ] **Stored error <= 30 % of |stress| and <= 50 MPa**; shear error similar. 15OCT26_0007 fails
      both (59 %, 74 MPa); the Jan steel runs pass easily (6 %, 3 %, 8 %).
- [ ] **No saturation**: no profile value above 60 000 (max seen 56 488 on Det0 of 15OCT26_0007 -
      close; a 2 mm aperture at 35 s on Ni is near the comfortable top), no flat-topped peaks, no
      pixel above a few hundred counts per 35 s frame (max seen 355).
- [ ] **Sign sanity**: the crude stress from the tool has the same sign and roughly the same magnitude
      as XrdWin's; a disagreement in sign is a red flag for the fit window or psi0.
- [ ] **File stable**: .mt size = 32 + 8 192 bytes per beta after the header (75 434 bytes for 9
      betas, 59 014 for 7, 91 897 for 11) and mtime unchanged for 2 polls before reading.

## 5. Live-state notes from today (2026-10-22, before the run)

`watch_measurement.py --once` at 10:29 and 10:35: registry Data Path = `C:\XrdWin Data\24193-24172T\Tube Change`,
LastData 10152026 / LastIndex 7 (the next file today will be `22OCT26_0001`, index restarts with the date,
inferred), LastWarmUp "October 15, 2026 11:34:19". No python.exe bridge and nothing listening on
TCP 8094 at either time. XrdWin.exe was NOT running at 10:29 but WAS running (PID 10552) at 10:35 - it
was started by someone at the PC, not by these tools. The C:\temp frames are still the last beta
(-30 deg) of 15OCT26_0007 (start Thu Oct 15 11:40:21 2026, 35.0 s, threshold 3.0 keV, HV 200 V):
Det1/F06 4 761 752 counts, max pixel 322, profile max 28 207 at ch 147, FWHM ~27 ch;
Det0/C10 3 789 063 counts, max pixel 355, profile max 25 076 at ch 114 (reversed), FWHM ~41 ch.
These totals equal the last-beta totals stored in 15OCT26_0007.mt exactly (4 761 752 / 3 789 063),
confirming the frame-to-profile mapping (test_1 = Det1, test_2 reversed = Det0).
