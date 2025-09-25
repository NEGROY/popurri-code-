@echo off
setlocal enabledelayedexpansion

echo ================================
echo  Inicializando WAHA en Docker...
echo ================================

:: Paso 1 - Verificar que Docker este corriendo
set RETRIES=0
:CHECK_DOCKER
docker info >nul 2>&1
if %errorlevel% neq 0 (
    set /a RETRIES+=1
    if %RETRIES% gtr 30 (
        echo [ERROR] Docker no inicio despues de 30 intentos.
        exit /b 1
    )
    echo [INFO] Esperando que Docker inicie... intento %RETRIES%
    timeout /t 5 >nul
    goto CHECK_DOCKER
)

echo [OK] Docker esta disponible.

:: Paso 2 - Validar que la imagen de WAHA exista
docker image inspect devlikeapro/waha:latest >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] La imagen devlikeapro/waha:latest no existe.
    echo [INFO] Intentando descargarla...
    docker pull devlikeapro/waha:latest
    if %errorlevel% neq 0 (
        echo [ERROR] No se pudo descargar la imagen de WAHA.
        exit /b 1
    )
)

:: Paso 3 - Verificar si el contenedor ya existe
docker ps -a --format "{{.Names}}" | findstr /i "^waha$" >nul
if %errorlevel%==0 (
    echo [INFO] Contenedor "waha" encontrado, iniciando...
    docker start waha
) else (
    echo [INFO] No existe contenedor "waha", creando uno nuevo...
    docker run -d --name waha -p 3000:3000 devlikeapro/waha:latest
)

if %errorlevel% neq 0 (
    echo [ERROR] Fallo al iniciar WAHA.
    exit /b 1
)

echo [OK] WAHA inicializado correctamente.
exit /b 0
