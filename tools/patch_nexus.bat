@echo off
rem Re-apply the A5 nexus unlock to all module exes (565248-byte acknex copies).
rem Safe to re-run. Requires PowerShell.
cd /d "%~dp0\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch_nexus.ps1"
pause
