@echo off
REM Lua Maker Installer - Windows Terminal Installable Package
REM Run: build.bat

echo ============================================
echo   LUA MAKER - HACKER EXE BUILDER
echo   Real, No Demo - Terminal Install
echo ============================================

echo [1/5] Detected OS: Windows

echo [2/5] Checking dependencies...
where g++ >nul 2>nul && echo g++ found || (echo g++ not found - install MinGW-w64 & exit /b 1)
where cmake >nul 2>nul && echo cmake found || (echo cmake not found - install CMake & exit /b 1)
where git >nul 2>nul && echo git found || (echo git not found - install Git & exit /b 1)
where python >nul 2>nul && echo python found || (echo python not found - install Python & exit /b 1)

echo [3/5] Setting up Lua Maker...
set SKILL_DIR=%USERPROFILE%\.config\opencode\skills\lua-maker
mkdir "%SKILL_DIR%" 2>nul
xcopy /E /I /Y . "%SKILL_DIR%\" >nul

echo [4/5] Verifying opencode...
where opencode >nul 2>nul && (echo opencode found) || (
    echo Installing opencode...
    powershell -Command "irm https://opencode.ai/install.ps1 | iex"
)

echo [5/5] Creating launcher...
set LAUNCHER=%USERPROFILE%\.local\bin\lua-maker.bat
mkdir "%USERPROFILE%\.local\bin" 2>nul
echo @echo off > "%LAUNCHER%"
echo opencode --skill lua-maker %%* >> "%LAUNCHER%"

setx PATH "%PATH%;%USERPROFILE%\.local\bin" >nul

echo.
echo ============================================
echo   INSTALLATION COMPLETE!
echo ============================================
echo.
echo Usage:
echo   lua-maker.bat                    ^<-- Start interactive mode
echo   lua-maker.bat roblox external    ^<-- Build Roblox external
echo   lua-maker.bat csgo aimbot        ^<-- Build CSGO aimbot
echo.
echo Restart terminal for PATH changes.
pause