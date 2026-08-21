@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   Discord GPU Preference Configurator (Power Saving)
echo ===================================================
echo.
echo Searching for Discord installations...
echo.

:: Initialize variables to store found paths
set "Path_Stable="
set "Path_PTB="
set "Path_Canary="
set "Update_Stable="
set "Update_PTB="
set "Update_Canary="
set "Count=0"

:: --- 1. Detect Discord Stable ---
if exist "%LocalAppData%\Discord" (
    for /d %%i in ("%LocalAppData%\Discord\app-*") do if exist "%%i\Discord.exe" set "Path_Stable=%%i\Discord.exe"
    if exist "%LocalAppData%\Discord\Update.exe" set "Update_Stable=%LocalAppData%\Discord\Update.exe"
)
if "%Path_Stable%"=="" if exist "%ProgramData%\Discord" (
    for /d %%i in ("%ProgramData%\Discord\app-*") do if exist "%%i\Discord.exe" set "Path_Stable=%%i\Discord.exe"
)
if "%Path_Stable%"=="" (
    for %%d in ("%ProgramFiles%", "%ProgramFiles(x86)%") do if exist "%%~d\Discord\Discord.exe" set "Path_Stable=%%~d\Discord\Discord.exe"
)
if not "%Path_Stable%"=="" set /a Count+=1

:: --- 2. Detect Discord PTB ---
if exist "%LocalAppData%\DiscordPTB" (
    for /d %%i in ("%LocalAppData%\DiscordPTB\app-*") do if exist "%%i\DiscordPTB.exe" set "Path_PTB=%%i\DiscordPTB.exe"
    if exist "%LocalAppData%\DiscordPTB\Update.exe" set "Update_PTB=%LocalAppData%\DiscordPTB\Update.exe"
)
if "%Path_PTB%"=="" if exist "%ProgramData%\DiscordPTB" (
    for /d %%i in ("%ProgramData%\DiscordPTB\app-*") do if exist "%%i\DiscordPTB.exe" set "Path_PTB=%%i\DiscordPTB.exe"
)
if not "%Path_PTB%"=="" set /a Count+=1

:: --- 3. Detect Discord Canary ---
if exist "%LocalAppData%\DiscordCanary" (
    for /d %%i in ("%LocalAppData%\DiscordCanary\app-*") do if exist "%%i\DiscordCanary.exe" set "Path_Canary=%%i\DiscordCanary.exe"
    if exist "%LocalAppData%\DiscordCanary\Update.exe" set "Update_Canary=%LocalAppData%\DiscordCanary\Update.exe"
)
if "%Path_Canary%"=="" if exist "%ProgramData%\DiscordCanary" (
    for /d %%i in ("%ProgramData%\DiscordCanary\app-*") do if exist "%%i\DiscordCanary.exe" set "Path_Canary=%%i\DiscordCanary.exe"
)
if not "%Path_Canary%"=="" set /a Count+=1


:: Check if any versions were found
if %Count% equ 0 (
    echo [!] No Discord installations detected.
    goto end
)

:: --- Display Menu ---
echo Found the following installations:
if not "%Path_Stable%"=="" echo  [1] Discord (Stable)  - %Path_Stable%
if not "%Path_PTB%"==""    echo  [2] Discord PTB       - %Path_PTB%
if not "%Path_Canary%"=="" echo  [3] Discord Canary    - %Path_Canary%
echo  [A] Select ALL detected versions
echo.

:menu_loop
set /p menu_choice="Choose an option to apply Power Saving (1/2/3/A): "

if /i "%menu_choice%"=="A" (
    if not "%Path_Stable%"=="" call :ApplyGpu "%Path_Stable%" "Discord.exe"
    if not "%Path_PTB%"==""    call :ApplyGpu "%Path_PTB%" "DiscordPTB.exe"
    if not "%Path_Canary%"=="" call :ApplyGpu "%Path_Canary%" "DiscordCanary.exe"
    goto ask_restart
)
if "%menu_choice%"=="1" (
    if not "%Path_Stable%"=="" ( call :ApplyGpu "%Path_Stable%" "Discord.exe" & goto ask_restart )
)
if "%menu_choice%"=="2" (
    if not "%Path_PTB%"==""    ( call :ApplyGpu "%Path_PTB%" "DiscordPTB.exe" & goto ask_restart )
)
if "%menu_choice%"=="3" (
    if not "%Path_Canary%"=="" ( call :ApplyGpu "%Path_Canary%" "DiscordCanary.exe" & goto ask_restart )
)

echo [!] Invalid selection or the chosen version was not found. Please try again.
goto menu_loop


:: --- Function to Apply Registry Key ---
:ApplyGpu
echo.
echo Setting %~2 to Power Saving...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%~1" /t REG_SZ /d "GpuPreference=1;" /f
if %errorlevel% equ 0 (
    echo [+] Successfully set %~2
) else (
    echo [X] Failed to set %~2. Please try running script as Admin.
)
exit /b


:: --- Ask to Restart ---
:ask_restart
echo.
set /p choice="Do you want to restart the applied Discord version(s) now? (Y/N): "
if /i "%choice%"=="Y" goto do_restart

echo.
echo Please manually restart your Discord client(s) later to apply changes.
goto end

:do_restart
echo.
echo Checking running status and restarting...

if /i "%menu_choice%"=="A" goto restart_all
if "%menu_choice%"=="1" goto restart_stable
if "%menu_choice%"=="2" goto restart_ptb
if "%menu_choice%"=="3" goto restart_canary
goto end

:restart_all
if not "%Path_Stable%"=="" (
    tasklist /fi "imagename eq Discord.exe" 2>nul | find /i "Discord.exe" >nul
    if !errorlevel! equ 0 ( taskkill /f /im Discord.exe >nul 2>&1 & start "" "%Update_Stable%" --processStart Discord.exe & echo [+] Discord Stable restarted. ) else ( echo [-] Discord Stable is not running, skip restart. )
)
if not "%Path_PTB%"=="" (
    tasklist /fi "imagename eq DiscordPTB.exe" 2>nul | find /i "DiscordPTB.exe" >nul
    if !errorlevel! equ 0 ( taskkill /f /im DiscordPTB.exe >nul 2>&1 & start "" "%Update_PTB%" --processStart DiscordPTB.exe & echo [+] Discord PTB restarted. ) else ( echo [-] Discord PTB is not running, skip restart. )
)
if not "%Path_Canary%"=="" (
    tasklist /fi "imagename eq DiscordCanary.exe" 2>nul | find /i "DiscordCanary.exe" >nul
    if !errorlevel! equ 0 ( taskkill /f /im DiscordCanary.exe >nul 2>&1 & start "" "%Update_Canary%" --processStart DiscordCanary.exe & echo [+] Discord Canary restarted. ) else ( echo [-] Discord Canary is not running, skip restart. )
)
goto end

:restart_stable
tasklist /fi "imagename eq Discord.exe" 2>nul | find /i "Discord.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im Discord.exe >nul 2>&1 & start "" "%Update_Stable%" --processStart Discord.exe
    echo [+] Restart command sent for Discord Stable.
) else (
    echo [-] Discord Stable is not running. No restart needed.
)
goto end

:restart_ptb
tasklist /fi "imagename eq DiscordPTB.exe" 2>nul | find /i "DiscordPTB.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im DiscordPTB.exe >nul 2>&1 & start "" "%Update_PTB%" --processStart DiscordPTB.exe
    echo [+] Restart command sent for Discord PTB.
) else (
    echo [-] Discord PTB is not running. No restart needed.
)
goto end

:restart_canary
tasklist /fi "imagename eq DiscordCanary.exe" 2>nul | find /i "DiscordCanary.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im DiscordCanary.exe >nul 2>&1 & start "" "%Update_Canary%" --processStart DiscordCanary.exe
    echo [+] Restart command sent for Discord Canary.
) else (
    echo [-] Discord Canary is not running. No restart needed.
)
goto end


:end
echo.
echo Done.
pause
