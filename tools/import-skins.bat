@echo off
rem Put your edited PNGs back into the model (rebuilds from the pristine backup,
rem re-encodes to the engine's 16-bit format, and rescales the UVs if you drew at
rem a bigger size than the original). All PNGs in the folder must share one size.
rem   Usage:  import-skins.bat Piposh
cd /d "%~dp0\.."
if "%~1"=="" ( echo Usage: import-skins.bat ^<ModelName without .MDL^> & exit /b 1 )
python tools\mdl_tool.py import "MDL\%~1.MDL" "skins_editable\%~1"
