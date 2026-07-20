@echo off
rem Temporary test harness: launches the Town level directly so we can judge
rem image sharpness without playing through the whole game.
rem Town.wdl is at native video_mode = 6 (640x480); dgVoodoo.conf is set to
rem render the 3D at 4x internal resolution (supersampling) + 4x MSAA.
rem Delete when done testing.
cd /d "%~dp0"
Town.exe -d l1 -NX 512 -diag
