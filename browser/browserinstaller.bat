@echo off
setlocal EnableExtensions
cd /d "%~dp0"

title bardhzzYos Browser Installer
color A

:: Admin check
fltmc >nul 2>&1
if errorlevel 1 (
    echo ERROR: Administrator privileges are required.
    echo Please right-click this script and select "Run as administrator".
    pause
    exit /b
)

:: curl check
where curl >nul 2>&1
if errorlevel 1 (
    cls
    echo ========================================================
    echo ERROR: curl.exe was not found.
    echo Windows 10/11 is required.
    echo ========================================================
    pause
    exit /b
)

curl -I -L --fail --silent --show-error --max-time 10 "https://www.microsoft.com/" >nul 2>&1
if errorlevel 1 (
    cls
    echo ========================================================
    echo ERROR: No internet connection detected.
    echo ========================================================
    pause
    exit /b
)

:: ANSI
set "Red=[91m"
set "Blue=[94m"
set "White=[97m"
set "Orange=[38;5;208m"
set "Gold=[38;5;214m"
set "Reset=[0m"

:menu
cls
chcp 65001 >nul 2>&1
echo ╔═════════════════════════╗
echo ║  Download a Browser     ║
echo ╚═════════════════════════╝
echo.
echo  %Red%[1] Google Chrome
echo  %Gold%[2] Mozilla Firefox
echo  %Orange%[3] Brave Browser
echo  %Blue%[4] Microsoft Edge
echo  %White%[5] Exit
echo.
set "ch="
set /p "ch=%White%Select an option (1-5): "

if "%ch%"=="1" goto chrome
if "%ch%"=="2" goto firefox
if "%ch%"=="3" goto brave
if "%ch%"=="4" goto edge
if "%ch%"=="5" exit /b
goto menu

:chrome
cls
color A
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════╗
echo ║  Downloading Google Chrome    ║
echo ╚═══════════════════════════════╝
taskkill /F /IM chrome.exe /T >nul 2>&1

set "FILE=%temp%\chrome.msi"
if exist "%FILE%" del /f /q "%FILE%" >nul 2>&1

echo %White%[1/2] Downloading Google Chrome...
curl -L --fail --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 600 -o "%FILE%" "https://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi"

if errorlevel 1 (
    echo.
    echo %Red%Download failed.%Reset%
    del /f /q "%FILE%" >nul 2>&1
    pause
    goto menu
)

if not exist "%FILE%" (
    echo.
    echo %Red%Download failed: installer file was not created.%Reset%
    pause
    goto menu
)

echo %White%[2/2] Installing Chrome...
start /wait "" "%SystemRoot%\System32\msiexec.exe" /i "%FILE%" /qn /norestart
set "ERR=%errorlevel%"

if "%ERR%"=="0" (
    echo.
    echo %White%Chrome installed successfully.%Reset%
) else if "%ERR%"=="3010" (
    echo.
    echo %White%Chrome installed. Restart required.%Reset%
) else if "%ERR%"=="1638" (
    echo.
    echo %White%Chrome is already installed.%Reset%
) else (
    echo.
    echo %Red%Installation failed. Error %ERR%.%Reset%
)

del /f /q "%FILE%" >nul 2>&1
timeout /t 3 >nul
goto menu

:firefox
cls
color A
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════╗
echo ║  Downloading Mozilla Firefox    ║
echo ╚═════════════════════════════════╝
taskkill /F /IM firefox.exe /T >nul 2>&1

set "FILE=%temp%\firefox.exe"
if exist "%FILE%" del /f /q "%FILE%" >nul 2>&1

echo %White%[1/2] Downloading Firefox...
curl -L --fail --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 600 -o "%FILE%" "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"

if errorlevel 1 (
    echo.
    echo %Red%Download failed.%Reset%
    del /f /q "%FILE%" >nul 2>&1
    pause
    goto menu
)

if not exist "%FILE%" (
    echo.
    echo %Red%Download failed: installer file was not created.%Reset%
    pause
    goto menu
)

echo %White%[2/2] Installing Firefox...
start /wait "" "%FILE%" -ms
set "ERR=%errorlevel%"

if "%ERR%"=="0" (
    echo.
    echo %Gold%Firefox installed successfully.%Reset%
) else (
    echo.
    echo %Red%Installation failed. Error %ERR%.%Reset%
)

del /f /q "%FILE%" >nul 2>&1
timeout /t 3 >nul
goto menu

:brave
cls
color A
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════╗
echo ║  Downloading Brave Browser      ║
echo ╚═════════════════════════════════╝
taskkill /F /IM brave.exe /T >nul 2>&1

set "FILE=%temp%\brave.exe"
if exist "%FILE%" del /f /q "%FILE%" >nul 2>&1

echo %White%[1/2] Downloading Brave...
curl -L --fail --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 600 -o "%FILE%" "https://laptop-updates.brave.com/latest/winx64"

if errorlevel 1 (
    echo.
    echo %Red%Download failed.%Reset%
    del /f /q "%FILE%" >nul 2>&1
    pause
    goto menu
)

if not exist "%FILE%" (
    echo.
    echo %Red%Download failed: installer file was not created.%Reset%
    pause
    goto menu
)

echo %White%[2/2] Installing Brave...
start /wait "" "%FILE%" /silent /install
set "ERR=%errorlevel%"

if "%ERR%"=="0" (
    echo.
    echo %Orange%Brave installed successfully.%Reset%
) else if "%ERR%"=="3010" (
    echo.
    echo %Orange%Brave installed. Restart required.%Reset%
) else (
    echo.
    echo %Red%Installation failed. Error %ERR%.%Reset%
)

del /f /q "%FILE%" >nul 2>&1
timeout /t 3 >nul
goto menu

:edge
cls
color A
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════╗
echo ║  Downloading Microsoft Edge     ║
echo ╚═════════════════════════════════╝
taskkill /F /IM msedge.exe /T >nul 2>&1

set "FILE=%temp%\MicrosoftEdgeEnterpriseX64.msi"
if exist "%FILE%" del /f /q "%FILE%" >nul 2>&1

echo %White%[1/2] Downloading Microsoft Edge...
curl -L --fail --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 600 -o "%FILE%" "https://go.microsoft.com/fwlink/?LinkID=2093437"

if errorlevel 1 (
    echo.
    echo %Red%Download failed.%Reset%
    del /f /q "%FILE%" >nul 2>&1
    pause
    goto menu
)

if not exist "%FILE%" (
    echo.
    echo %Red%Download failed: installer file was not created.%Reset%
    pause
    goto menu
)

echo %White%[2/2] Installing Microsoft Edge...
start /wait "" "%SystemRoot%\System32\msiexec.exe" /i "%FILE%" /qn /norestart
set "ERR=%errorlevel%"

if "%ERR%"=="0" (
    echo.
    echo %Blue%Microsoft Edge installed successfully.%Reset%
) else if "%ERR%"=="3010" (
    echo.
    echo %Blue%Microsoft Edge installed. Restart required.%Reset%
) else if "%ERR%"=="1638" (
    echo.
    echo %Blue%Microsoft Edge is already installed.%Reset%
) else (
    echo.
    echo %Red%Installation failed. Error %ERR%.%Reset%
)

del /f /q "%FILE%" >nul 2>&1
timeout /t 3 >nul
goto menu