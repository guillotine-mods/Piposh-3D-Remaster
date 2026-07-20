@echo off
rem AI-upscale a model's editable skins in place using Real-ESRGAN (anime model),
rem then shrink to a safe 2x so the engine is happy. Run extract-skins first.
rem   Usage:  upscale-skins.bat Piposh
cd /d "%~dp0\.."
if "%~1"=="" ( echo Usage: upscale-skins.bat ^<ModelName^> & exit /b 1 )
set NAME=%~1
if exist "_tmp_up" rmdir /s /q "_tmp_up"
mkdir "_tmp_up"
tools\realesrgan\realesrgan-ncnn-vulkan.exe -i "skins_editable\%NAME%" -o "_tmp_up" -n realesrgan-x4plus-anime -s 4 -f png
python -c "import glob,os;from PIL import Image;[Image.open(p).resize((640,400),Image.LANCZOS).save(os.path.join('skins_editable','%NAME%',os.path.basename(p))) for p in glob.glob('_tmp_up/skin*.png')]"
rmdir /s /q "_tmp_up"
echo Done. Now run: tools\import-skins.bat %NAME%
