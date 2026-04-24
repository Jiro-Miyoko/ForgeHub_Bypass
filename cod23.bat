@echo off
TITLE Launch script - by LightningFast
color 04

echo  ______ ______ _______ _______ _______ _______ _______    _       _ _______ _     _ _______ _______ _ _______ _______ 
echo ^(_____ ^(_____ ^(_______^|_______^|_______^|_______^|_______^)  ^(_^)     ^| ^(_______^|_)   ^(_^|_______^|_______^) ^(_______^|_______^)
echo  _____^)^)____^)^)       _     _   _____   _          _       _      ^| ^|_   ___ _______    _   ^|_^|   ^|_^| ^|_     _ _   ___ 
echo ^|  ____/  __  / ^|   ^| ^|_  ^| ^| ^|  ___^) ^| ^|        ^| ^|     ^| ^|     ^| ^| ^| ^(_  ^|  ___  ^|  ^| ^|  ^| ^|   ^| ^| ^| ^|   ^| ^| ^| ^(_  ^|
echo ^| ^|    ^| ^|  \ \ ^|___^| ^| ^|_^| ^| ^| ^|_____^| ^|_____   ^| ^|     ^| ^|_____^| ^| ^|___^) ^| ^|   ^| ^|  ^| ^|  ^| ^|   ^| ^| ^| ^|   ^| ^| ^|___^) ^|
echo ^|_^|    ^|_^|   ^|_\_____/ \___/  ^|_______\)______)  ^|_^|     ^|_______)^_^|^\_____/^|_^|   ^|_^|  ^|_^|  ^|_^|   ^|_^|_^|_^|   ^|_^|\_____/
echo(




set "params=%*"
set "vbs=%~dp0getadmin.vbs"


cd /d "%~dp0"


if exist "%vbs%" del "%vbs%"
fsutil dirty query %systemdrive% >nul 2>nul || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%vbs%"
    "%vbs%"
	del "%vbs%"
    exit /B
)

set DRIVERNAME=atvi-sigrun_sr_offline
set EXENAME=cod23-cod.exe

sc query %DRIVERNAME% >nul 2>&1
if %errorlevel%==0 (
	echo AC already installed as %DRIVERNAME%
    goto startgame
) else (
    goto install_ac_driver
)

:install_ac_driver
sc.exe create %DRIVERNAME% type= kernel binPath="%CD%\Randgrid.sys"
sc.exe sdset %DRIVERNAME% D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWRPWPLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)
echo AC installed as %DRIVERNAME%

:startgame
echo Keep this window open to avoid issues!
bootstrapper.exe %EXENAME%
set BOOTSTRAPPERERRORLEVEL=%errorlevel%
sc.exe delete %DRIVERNAME%
if not %BOOTSTRAPPERERRORLEVEL%==0 (
echo.
echo Failed to launch the game, check bootstrapper.log!
pause
exit
)
rd /s /q %APPDATA%\r4v3n_steam_files
timeout 1
exit
