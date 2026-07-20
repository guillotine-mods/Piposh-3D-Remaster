@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

rem ============================================================================
rem  Piposh 3D enhanced launcher
rem  Replaces the Piposh3D.exe boot/relaunch loop so that every game module is
rem  started WITH an enlarged NEXUS memory pool (-nx). The original launcher
rem  wrote a bare filename to Run.txt and could not pass -nx to the engine.
rem
rem  IMPORTANT: the boot module is named start.exe. Bare "start.exe" is eaten by
rem  cmd's START builtin, which drops our -nx args and leaves the default 40 MB
rem  nexus ("Nexus too small"). Always invoke via a full path ("%~dp0...").
rem
rem  Launcher contract (reverse-engineered from Piposh3D.exe + IO.wdl):
rem    * boot module is hard-coded to start.exe
rem    * a module hands off by writing the next module name to Run.txt and
rem      bumping Prefs\Date.txt (IO.wdl Run())
rem    * the game asks to quit by writing "0" to Prefs\Flag.txt (IO.wdl DoExit)
rem ============================================================================

rem Nexus size in MB. The module EXEs are binary-patched to default to 512 MB
rem and LARGEADDRESSAWARE (see tools\patch_nexus.ps1). -NX here is belt-and-
rem suspenders so even an unpatched copy still gets the large pool.
set "NX=512"
rem Diagnostics: set to "-diag" to make the engine write acklog.txt for
rem troubleshooting. Leave blank for normal play.
set "EXTRA="
rem Loading-screen symbol the engine expects on the command line (ifdef l1..l22 in
rem IO.wdl selects which LoadingNN.pcx is used). The original launcher passed a
rem per-module value; l1 works for every module (cosmetic only).
set "LOAD=l1"

rem Make sure the run flag is not left at "0" from a previous clean exit.
<nul set /p "=runs">"Prefs\Flag.txt"

rem Boot module (same as the original launcher).
set "NEXT=Start.exe"

:loop
	set "OLDDATE="
	if exist "Prefs\Date.txt" set /p OLDDATE=<"Prefs\Date.txt"

	rem Full path avoids cmd's START builtin swallowing start.exe + our args.
	set "EXE=%~dp0!NEXT!"
	echo Launching: "!EXE!" -d !LOAD! -NX !NX! !EXTRA!>>"%~dp0_launch_log.txt"
	"!EXE!" -d !LOAD! -NX !NX! !EXTRA!

	rem Quit if the game requested exit.
	set "FLAG="
	if exist "Prefs\Flag.txt" set /p FLAG=<"Prefs\Flag.txt"
	if "!FLAG!"=="0" goto end

	rem Quit if the module closed without requesting another one
	rem (window closed / crash): its handshake date will be unchanged.
	set "NEWDATE="
	if exist "Prefs\Date.txt" set /p NEWDATE=<"Prefs\Date.txt"
	if "!NEWDATE!"=="!OLDDATE!" goto end

	set "NEXT="
	if exist "Run.txt" set /p NEXT=<"Run.txt"
	rem Trim accidental CR / spaces from set /p
	if defined NEXT set "NEXT=!NEXT: =!"
	if "!NEXT!"=="" goto end

	goto loop

:end
endlocal
