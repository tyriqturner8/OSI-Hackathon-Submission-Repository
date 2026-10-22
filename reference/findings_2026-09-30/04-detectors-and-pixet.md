## MiniPIX detectors, PIXet SDK and the TCP bridge

> Status: this section was written from verified sources after the detailed section writer was stopped. The PIXet SDK manuals were extracted but not yet summarized; see `raw/pixet-detector/SDKPythonManual.txt`.

**Key points**

- There are two Advacam MiniPIX (Timepix3) detectors, **C10-W0115** and **F06-W0115**. Each is 256 × 256 pixels at 55 µm, run at 200 V bias and a 3 keV threshold (registry `Constants\System\Detector\XISL`; calibration XMLs `D:\MiniPIX-*.xml`, `<Bias>200</Bias>`).
- XrdWin does not talk to the detectors directly. It starts a small **Python TCP server** (`reference/tcpserverMiniPix2D_Event.py`) through `aaa_Events.bat`, then acts as its client on **localhost:8094**. The server drives both detectors through PIXet Pro's `pypixet` module (Python 3.7).
- The server controls **only the detectors**. It has no X-ray, shutter or motor commands. It serves one client at a time and has no authentication.
- **Only one program can own the detectors.** While XrdWin is using the server, Claude cannot use it or `pypixet` at the same time.
- A "profile" in XrdWin data files is the column sum of the MiniPIX Event frame. This was checked exactly against the frames in `C:\temp` (see section 06).

### TCP bridge protocol (verified from source)

Messages are ASCII with fields separated by `;`. The server reads at most 1024 bytes per read, and messages have no length prefix or end marker.

| Command | Arguments | Reply | Notes |
|---|---|---|---|
| `ping` | none | `ok.` | Server then closes the connection |
| `init` | none | `ok. init` or `ok. done` | Starts `pypixet` in a background thread |
| `is_init` | none | `True` / `False` | |
| `initdevice` | none | `ok;<n>;<dev1>;<dev2>;` or `none` | Replies `none` if no detectors are found or a simulated "FileDevice" is present |
| `getdevice` | none | `ok. initdevice;<dev1>;<dev2>` | |
| `startcollect` | `;<frames>;<dwell_s>` | `ok` | Two threads call `doSimpleIntegralAcquisition(frames, dwell, 2, c:/temp/test_N.pmf)` |
| `is_collecting` | none | `<bool>;<frame1>;<frame2>` | |
| `abort` | none | `ok` | Calls `abortOperation()` on both detectors |
| `getbias` / `setbias` | `;<V>` for set | value / `ok` | Set applies to both detectors |
| `getthreshold` / `setthreshold` | `;<keV>` for set | value / `ok` | Set applies to both detectors |
| `getframe` | none | frame index of detector 1 | |
| `outdir`, `filename`, `getoutdir`, `getfilename` | `;<value>` for set | echo | **Not used.** Save paths are hard-coded to `c:/temp` |
| `destroy` | none | `ok.` | Only clears a flag |
| `exit` | none | `ok. exit` | Shuts down pypixet and the server |
| `help` | none | command list | |
| anything else | | echoed back | |

Operation mode is set to 2 (event + iToT). After each acquisition the server saves `c:/temp/test_1_<i>.png` / `test_2_<i>.png`. The `.pmf` frame files and their `.dsc` descriptors are also written to `C:\temp`.

### Quirks and risks found in the bridge
- `killaaa.bat` runs `taskkill /f /im python.exe`, which kills **every** Python process on the PC. Any tooling Claude runs with the same `python.exe` would be killed too.
- `aaa.bat` and `aaa_t3pa.bat` point to scripts that don't exist (`tcpserverMiniPix2D.py`, `tcpserverMiniPix_new2D.py`). The registry value `strPythonServer` also points to a path that doesn't exist.
- The `pixet` object is assigned inside a function without a `global` statement, but other code relies on it (inferred to work only because pypixet sets it up). Test this before reusing the script.
- `startcollect` sets its "collecting" flags inside threads without declaring them global, so `is_collecting` may not report the end of a collection reliably (inferred from code reading).

### PIXet Pro installation
- Location: `C:\Program Files\PIXet Pro`. It includes `pypixet.pyd`, `python37.dll`, `hwlibs\`, `plugins\` and `scripts\`. It matches the installed **Python 3.7.9 x64**.
- SDK archives and manuals are in `D:\Software\Pixet`. The extracted C header (`pxcapi.h`), a sample `main.cpp`, and the SDK / Python / PxProc manuals (PDF and text) are in `raw/pixet-detector/`.
- PIXet's plugin folder contains a `remotectrl.dll` remote-control plugin (strings in `raw/pixet-detector/remotectrl.dll.strings.txt`). Its protocol and whether it is enabled were **not analyzed**.

### What this means for Claude control
- **Detector-only control is straightforward.** Claude can talk to the same TCP server with a few lines of Python, or call `pypixet` directly. It must never do this while XrdWin owns the detectors, and should only do it in a supervised session with XrdWin closed or idle.
- X-ray, shutter and motion are **not** reachable through this path.

### Open questions
- Can the bridge be run safely alongside XrdWin, for example with XrdWin's detector connection released? Or does detector work require closing XrdWin?
- Is PIXet's `remotectrl.dll` a usable, officially supported control interface?
- Which pypixet calls does XrdWin rely on beyond those in the script (operation modes, trigger modes)?
