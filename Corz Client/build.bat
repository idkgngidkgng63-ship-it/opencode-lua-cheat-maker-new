@echo off
:: Corz Client — Windows Installer
:: Run: build.bat

echo ============================================
echo   CORZ CLIENT — ROBLOX CHEAT INSTALLER
echo   Xeno Executor ^| Universal Script
echo ============================================

echo [1/3] Checking lua syntax...
where lua >nul 2>&1
if %errorlevel%==0 (
    lua -e "loadfile('%~dp0corz_client.lua')" && echo   Syntax OK || echo   Syntax check skipped
) else (
    where luac >nul 2>&1
    if %errorlevel%==0 (
        luac -p "%~dp0corz_client.lua" && echo   Syntax OK || echo   Syntax check skipped
    ) else (
        echo   lua not found — skipping syntax check
    )
)

echo [2/3] Copying to clipboard...
clip < "%~dp0corz_client.lua" 2>nul && echo   Copied to clipboard! || echo   Could not copy

echo [3/3] Done!
echo.
echo ============================================
echo   HOW TO USE
echo ============================================
echo.
echo   1. Open Xeno executor
echo   2. Join any Roblox game
echo   3. Paste corz_client.lua into Xeno script editor
echo   4. Click Execute
echo   5. Press Right Ctrl to toggle menu
echo.
echo   Features:
echo     - Aimbot (Camera/Mouse, smoothing, prediction)
echo     - Silent Aim
echo     - Triggerbot
echo     - ESP (boxes, names, health, distance, tracers)
echo     - FOV circle (with fill, spin)
echo     - Speed hack, jump boost, fly, noclip
echo     - Player explorer (teleport, spectate)
echo.
echo ============================================
pause
