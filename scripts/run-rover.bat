@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "REPOSITORY=%MARS_ROVER_REPOSITORY%"
if not defined REPOSITORY set "REPOSITORY=NavinKarra/mars_rover"
if "%REPOSITORY%"=="OWNER/REPOSITORY" (
    echo Set MARS_ROVER_REPOSITORY to the public GitHub owner/repository. 1>&2
    exit /b 1
)
echo(%REPOSITORY%| findstr /r /x /c:"[A-Za-z0-9][A-Za-z0-9_.-]*/[A-Za-z0-9][A-Za-z0-9_.-]*" >nul
if errorlevel 1 (
    echo Invalid GitHub repository. 1>&2
    exit /b 1
)

if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" if not "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
    echo Unsupported processor architecture. Only Windows x86-64 is published. 1>&2
    exit /b 1
)

set "INSTALL_DIR=%MARS_ROVER_INSTALL_DIR%"
if not defined INSTALL_DIR set "INSTALL_DIR=%LOCALAPPDATA%\mars-rover"
set "BINARY=%INSTALL_DIR%\mars-rover.exe"
set "LOCK_DIR=%INSTALL_DIR%\.update-lock"
set "ASSET=mars-rover-windows-x86_64.exe"
set "URL=https://github.com/%REPOSITORY%/releases/latest/download/%ASSET%"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%" 2>nul
if not exist "%INSTALL_DIR%\" (
    echo Could not create the installation directory. 1>&2
    exit /b 1
)
mkdir "%LOCK_DIR%" 2>nul
if errorlevel 1 (
    echo Another launcher is updating the application. 1>&2
    exit /b 1
)

set "TEMP_DIR=%INSTALL_DIR%\.download-%RANDOM%-%RANDOM%"
mkdir "%TEMP_DIR%" 2>nul
if errorlevel 1 goto update_failed

where curl.exe >nul 2>nul
if errorlevel 1 goto update_failed
where certutil.exe >nul 2>nul
if errorlevel 1 goto update_failed

curl.exe --fail --silent --show-error --location --proto "=https" --proto-redir "=https" --connect-timeout 10 --max-time 120 "%URL%" --output "%TEMP_DIR%\rover.exe"
if errorlevel 1 goto update_failed
curl.exe --fail --silent --show-error --location --proto "=https" --proto-redir "=https" --connect-timeout 10 --max-time 30 "%URL%.sha256" --output "%TEMP_DIR%\checksum"
if errorlevel 1 goto update_failed

set "EXPECTED="
for /f "tokens=1" %%H in ('type "%TEMP_DIR%\checksum"') do if not defined EXPECTED set "EXPECTED=%%H"
if not defined EXPECTED goto update_failed

certutil.exe -hashfile "%TEMP_DIR%\rover.exe" SHA256 > "%TEMP_DIR%\hash.txt" 2>nul
if errorlevel 1 goto update_failed
set "ACTUAL="
for /f "skip=1 tokens=*" %%H in ('type "%TEMP_DIR%\hash.txt"') do if not defined ACTUAL set "ACTUAL=%%H"
if not defined ACTUAL goto update_failed
if /i not "%EXPECTED%"=="%ACTUAL%" (
    echo Downloaded application failed checksum verification. 1>&2
    goto update_failed
)

if not exist "%BINARY%" goto install_new
certutil.exe -hashfile "%BINARY%" SHA256 > "%TEMP_DIR%\installed-hash.txt" 2>nul
if errorlevel 1 goto install_new
set "INSTALLED="
for /f "skip=1 tokens=*" %%H in ('type "%TEMP_DIR%\installed-hash.txt"') do if not defined INSTALLED set "INSTALLED=%%H"
if /i "%ACTUAL%"=="%INSTALLED%" (
    echo Application is up to date.
    goto update_succeeded
)

:install_new
move /y "%TEMP_DIR%\rover.exe" "%BINARY%" >nul
if errorlevel 1 goto update_failed
echo Installed the latest application.

:update_succeeded
rd /s /q "%TEMP_DIR%" 2>nul
rd "%LOCK_DIR%" 2>nul
"%BINARY%" %*
exit /b %ERRORLEVEL%

:update_failed
if defined TEMP_DIR rd /s /q "%TEMP_DIR%" 2>nul
rd "%LOCK_DIR%" 2>nul
if not exist "%BINARY%" (
    echo Installation failed. Check your connection and published release assets. 1>&2
    exit /b 1
)
echo Update failed; launching the previously installed application. 1>&2
"%BINARY%" %*
exit /b %ERRORLEVEL%
