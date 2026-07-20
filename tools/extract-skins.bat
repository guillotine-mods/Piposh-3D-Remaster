@echo off
rem Extract a model's textures (skins) to editable PNGs.
rem   Usage:  extract-skins.bat Piposh
rem Creates  skins_editable\<Name>\skin0.png, skin1.png, ...
rem The pristine original .MDL is auto-backed up to _backup_mdl on first run.
cd /d "%~dp0\.."
if "%~1"=="" ( echo Usage: extract-skins.bat ^<ModelName without .MDL^> & exit /b 1 )
python tools\mdl_tool.py extract "MDL\%~1.MDL" "skins_editable\%~1"
