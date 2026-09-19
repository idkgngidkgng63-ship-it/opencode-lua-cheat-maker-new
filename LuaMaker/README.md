# Lua Maker - Terminal Installable Package

## Quick Install

### Linux/macOS
```bash
cd LuaMakerInstall
chmod +x install.sh
./install.sh
```

### Windows
```cmd
cd LuaMakerInstall
build.bat
```

## Verify Installation
```bash
python verify.py
```

## Usage

After installation, restart your terminal and run:

```bash
# Interactive mode
lua-maker

# Direct builds
lua-maker roblox external    # Matcha-style external
lua-maker roblox internal    # Internal injector
lua-maker csgo aimbot        # CSGO/CS2 aimbot
lua-maker rust esp           # Rust ESP
lua-maker wireshark lua      # Wireshark Lua script
```

## What Gets Installed

- **opencode** - AI coding agent
- **lua-maker skill** - Hacker EXE builder workflow
- **Build tools** - g++, CMake, Python, Git
- **Python deps** - pymem, pyinstaller, lupa, etc.

## Templates Included

- `RobloxExternal/` - Real external cheat (Matcha-style)
- `RavenX/` - Roblox internal
- `HexClient/` - Advanced client
- `MatchaLua/` - Matcha Lua scripts

## Docs

- Matcha: https://doc.wabisabi.mom/matcha/
- Skill: `~/.config/opencode/skills/lua-maker/`