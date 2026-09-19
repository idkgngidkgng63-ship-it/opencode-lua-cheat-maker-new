@echo off
title Lua Maker - modded opencode
set "NPM_BIN=%APPDATA%\npm"
set "PATH=%NPM_BIN%;%PATH%"
cd /d "%~dp0LuaMaker"
echo ============================================
echo  LUA MAKER - modded opencode
echo ============================================
echo  [1] Local app (no login, python lua_maker.py)
echo  [2] Modded opencode (full hacker build mode)
echo ============================================
set /p MODE="pick 1 or 2: "
if "%MODE%"=="2" goto OPENCODE
python lua_maker.py
goto END
:OPENCODE
where opencode.cmd >nul 2>nul
if errorlevel 1 (
  echo opencode not on PATH, trying npm location...
  if exist "%NPM_BIN%\opencode.cmd" (
    "%NPM_BIN%\opencode.cmd"
  ) else (
    echo missing opencode. Run: npm install -g --allow-scripts=opencode-ai opencode-ai
  )
) else (
  opencode
)
:END
echo.
pause
