@echo off
if "%~1"=="" (
    echo Uso: compilar_diagrama.bat archivo.mmd
    exit /b
)
set filename=%~n1
echo Compilando %1 a PDF, SVG y PNG (Fondo Negro)...
call mmdc.cmd -i "%1" -o "%filename%.pdf" -C pdf-dark.css -p puppeteer-config.json
call mmdc.cmd -i "%1" -o "%filename%.svg" -b "#000000" -p puppeteer-config.json
call mmdc.cmd -i "%1" -o "%filename%.png" -b "#000000" -s 3 -p puppeteer-config.json
echo ¡Listo!
