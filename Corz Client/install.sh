#!/bin/bash
# Corz Client — Terminal Installer
# Run: bash install.sh

set -e

echo "============================================"
echo "  CORZ CLIENT — ROBLOX CHEAT INSTALLER"
echo "  Xeno Executor | Universal Script"
echo "============================================"

OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "[1/4] Detected OS: ${MACHINE}"

echo "[2/4] Checking dependencies..."
if command -v lua &> /dev/null; then
    echo "  lua: $(lua -v 2>&1 | head -1)"
elif command -v luac &> /dev/null; then
    echo "  luac: $(luac -v 2>&1 | head -1)"
else
    echo "  Installing lua..."
    if [[ "${MACHINE}" == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y lua5.3
    elif [[ "${MACHINE}" == "Mac" ]]; then
        brew install lua
    fi
fi

echo "[3/4] Verifying script syntax..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if command -v luac &> /dev/null; then
    luac -p "${SCRIPT_DIR}/corz_client.lua" && echo "  Syntax OK" || echo "  Syntax check failed (may still work in executor)"
elif command -v lua &> /dev/null; then
    lua -e "loadfile('${SCRIPT_DIR}/corz_client.lua')" && echo "  Syntax OK" || echo "  Syntax check failed"
else
    echo "  Skipped (no lua installed)"
fi

echo "[4/4] Done!"
echo ""
echo "============================================"
echo "  HOW TO USE"
echo "============================================"
echo ""
echo "  1. Open Xeno executor"
echo "  2. Join any Roblox game"
echo "  3. Open corz_client.lua in Xeno"
echo "  4. Click Execute"
echo "  5. Press Right Ctrl to toggle menu"
echo ""
echo "  Features:"
echo "    - Aimbot (Camera/Mouse, smoothing, prediction)"
echo "    - Silent Aim"
echo "    - Triggerbot"
echo "    - ESP (boxes, names, health, distance, tracers)"
echo "    - FOV circle (with fill, spin)"
echo "    - Speed hack, jump boost, fly, noclip"
echo "    - Player explorer (teleport, spectate)"
echo ""
echo "============================================"
