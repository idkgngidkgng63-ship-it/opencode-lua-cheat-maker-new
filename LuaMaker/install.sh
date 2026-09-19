#!/bin/bash
# Lua Maker Installer - Terminal Installable Package
# Run: bash install.sh

set -e

echo "============================================"
echo "  LUA MAKER - HACKER EXE BUILDER"
echo "  Real, No Demo - Terminal Install"
echo "============================================"

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "[1/5] Detected OS: ${MACHINE}"

# Install dependencies
echo "[2/5] Installing dependencies..."
if [[ "${MACHINE}" == "Linux" ]]; then
    sudo apt-get update && sudo apt-get install -y g++ make cmake git python3 python3-pip
elif [[ "${MACHINE}" == "Mac" ]]; then
    brew install gcc make cmake git python3
elif [[ "${MACHINE}" == "Windows" ]]; then
    echo "Windows detected - use build.bat instead"
    exit 0
fi

# Clone Lua Maker skill
echo "[3/5] Setting up Lua Maker..."
SKILL_DIR="${HOME}/.config/opencode/skills/lua-maker"
mkdir -p "${SKILL_DIR}"
cp -r ./* "${SKILL_DIR}/" 2>/dev/null || true

# Verify installation
echo "[4/5] Verifying installation..."
if command -v opencode &> /dev/null; then
    echo "opencode found: $(opencode --version)"
else
    echo "Installing opencode..."
    curl -fsSL https://opencode.ai/install.sh | bash
fi

# Create launcher
echo "[5/5] Creating launcher..."
cat > "${HOME}/.local/bin/lua-maker" << 'EOF'
#!/bin/bash
opencode --skill lua-maker "$@"
EOF
chmod +x "${HOME}/.local/bin/lua-maker"

echo ""
echo "============================================"
echo "  INSTALLATION COMPLETE!"
echo "============================================"
echo ""
echo "Usage:"
echo "  lua-maker                    # Start interactive mode"
echo "  lua-maker roblox external    # Build Roblox external"
echo "  lua-maker csgo aimbot        # Build CSGO aimbot"
echo ""
echo "Add to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""