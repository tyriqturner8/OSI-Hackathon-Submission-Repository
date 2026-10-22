# setup.ps1 - one-time setup for the iXRD Mini Claude package (safe to re-run).
# Creates the short path C:\Users\<you>\xrd -> <package> (a directory junction to the package ROOT, so tools that
# locate their output folders relative to themselves still land inside the package) and the output folders,
# then runs the read-only pre-flight check. It does not touch XrdWin, the instrument, or the registry.
# If the junction already points at ANOTHER copy of the package, it stops; re-run with -Force to re-point it here.
param([switch]$Force)
$ErrorActionPreference = 'Stop'
$pkg   = Split-Path -Parent $MyInvocation.MyCommand.Path
$tools = Join-Path $pkg 'tools'
$link  = Join-Path $env:USERPROFILE 'xrd'   # -> package root; tools are at C:\Users\<you>\xrd\tools
foreach ($d in 'run', 'run\shots', 'recording', 'results') { New-Item -ItemType Directory -Force (Join-Path $pkg $d) | Out-Null }
if (Test-Path $link) {
  $item = Get-Item $link -Force
  if ($item.LinkType -eq 'Junction' -and $item.Target -contains $pkg) { "junction ok: $link -> $pkg" }
  elseif ($item.LinkType -eq 'Junction') {
    if (-not $Force) { throw "$link already points to $($item.Target) (another package copy?). Re-run as: setup.ps1 -Force   to re-point it to $pkg" }
    [System.IO.Directory]::Delete($link, $false)   # removes only the junction, never the folder it points to
    New-Item -ItemType Junction -Path $link -Target $pkg | Out-Null; "junction re-pointed: $link -> $pkg"
  }
  else { throw "$link exists and is not a junction; remove or rename it, then re-run setup.ps1" }
} else { New-Item -ItemType Junction -Path $link -Target $pkg | Out-Null; "junction created: $link -> $pkg" }
$py = 'C:\Users\PROTO\AppData\Local\Programs\Python\Python37\python.exe'
"python 3.7: " + (Test-Path $py)
"pre-flight:"
& (Join-Path $tools 'xw.ps1') preflight
