## What the XrdWin program itself reveals (static analysis)

> Status: this section is partial. The import-table inspection finished (`reference/xrdwin_imports.txt`, produced by `tools/pe_inspect.py`). Deeper string analysis of the serial command protocols did not. Section 02 also covers the menu/dialog resources.

**Key points**

- `XrdWin.exe` is a 32-bit MFC program. Its imports show it drives serial ports directly (`SetCommState`, `BuildCommDCBA`, `EscapeCommFunction`, `WaitCommEvent` …). This matches the registry: HV supply on COM1, safety PLC on COM8, motors on COM9.
- For networking it imports WinSock 1 (`WSOCK32`): `socket`, `connect`, `send`, `recv`, `listen`, `ioctlsocket`. It does **not** import `bind` or `accept`, so it cannot accept incoming connections. In practice it acts only as a **client**, for example of the MiniPIX server on port 8094 (inferred from the imports).
- It can launch other programs (`CreateProcessA`, `WinExec`, `ShellExecuteA`, `_execl`); this is how the detector server batch file gets started. It also imports WinINet FTP functions, probably for software updates or data upload (inferred).
- We found **no DDE, COM/OLE automation or incoming-socket interface**. XrdWin offers no built-in remote API that Claude could use.
- `ClientApp.exe` is a small **.NET 4 program (2014, "ClientServer" project)** containing a TCP client with timeout, a ping, start/stop-service functions and TIFF (LibTiff) support. It belongs to Proto's internal client/server module and is **not** a control API. Its purpose is not fully confirmed.
- `Proto Alignment Camera.exe` is a .NET WPF webcam viewer (`AvCapWPF`, DirectShow).

### Evidence
| Item | Evidence (reference/xrdwin_imports.txt) |
|---|---|
| Serial port API | line 101, 167: `SetCommState, SetCommTimeouts, GetCommState, EscapeCommFunction, BuildCommDCBA, PurgeComm, SetupComm, WaitCommEvent` |
| Sockets (client) | lines 147-149, 166: `WSOCK32` ordinals `socket, connect, send, recv, listen, ioctlsocket, htons`; no `bind`/`accept` |
| Process launch | line 172: `CreateProcessA, WinExec, ShellExecuteA, _execl` |
| FTP/Internet | lines 19-20, 182: `WININET!InternetOpenA, FtpPutFileA, FtpGetFileA …` |
| ClientApp.exe | lines 189-249: .NET v4.0.30319, PDB `…\ClientServer\ClientApp\…`, `TcpClientWithTimeout.Connect`, `StartServices` |
| Alignment camera | lines 908-959: .NET v2.0, `AvCapWPF.IGraphBuilder`, `ISampleGrabber` |

### What this means for Claude control
- There is no hidden remote API to use. Motion and X-ray control can only go through **XrdWin's GUI** (supervised automation), or through direct serial control. Direct serial control bypasses XrdWin's safety logic and is **not recommended**.
- XrdWin's menus and dialogs are standard MFC resources with stable command IDs (section 02), so GUI automation should be workable.

### Open questions
- What exact serial command strings does XrdWin send to the Spellman HV supply, the TRi FMD PLC and the motor controllers? This is only needed for diagnostics, not for the recommended path.
- What server does `ClientApp.exe` connect to, and is it ever used on this system?
- Would Proto Manufacturing provide an official automation interface or SDK?
