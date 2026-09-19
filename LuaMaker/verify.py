#!/usr/bin/env python3
"""
Lua Maker - Installation Verification Script
Run: python verify.py
"""

import sys
import subprocess
import platform

def check_cmd(cmd, name):
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ {name}: OK")
            return True
        else:
            print(f"✗ {name}: FAILED")
            return False
    except Exception as e:
        print(f"✗ {name}: ERROR - {e}")
        return False

def main():
    print("╔═══════════════════════════════════════════════╗")
    print("║      LUA MAKER - INSTALL VERIFICATION        ║")
    print("╚═══════════════════════════════════════════════╝")
    print(f"Platform: {platform.system()} {platform.release()}")
    print(f"Python: {sys.version.split()[0]}")
    print()

    checks = [
        ("g++ --version", "g++"),
        ("cmake --version", "CMake"),
        ("git --version", "Git"),
        ("python --version", "Python"),
        ("opencode --version", "opencode"),
    ]

    all_pass = True
    for cmd, name in checks:
        if not check_cmd(cmd, name):
            all_pass = False

    print()
    if all_pass:
        print("✓ All checks passed! Lua Maker is ready.")
        print()
        print("Next steps:")
        print("  opencode --skill lua-maker")
        print("  # or")
        print("  lua-maker")
        return 0
    else:
        print("✗ Some checks failed. Run install.sh / build.bat first.")
        return 1

if __name__ == "__main__":
    sys.exit(main())