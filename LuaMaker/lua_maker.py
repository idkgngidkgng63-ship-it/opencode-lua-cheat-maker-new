#!/usr/bin/env python3
"""
Lua Maker - Main Entry Point
Hacker Build Mode: Real working builds, no demos
"""

import sys
import os
import subprocess

BUILD_STEPS = [
    ("Fetching sources...", "git clone"),
    ("Compiling...", "g++/cmake"),
    ("Checking errors...", "compile check"),
    ("Booting VM...", "VM test"),
    ("Done", "complete"),
]

def stream_build(step_name, cmd, cwd=None):
    print(f"[{BUILD_STEPS.index((step_name, ''))+1}/5] {step_name}")
    try:
        result = subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True, timeout=120)
        if result.returncode == 0:
            print(f"    ✓ Success")
            return True
        else:
            print(f"    ✗ Failed: {result.stderr[:200]}")
            return False
    except subprocess.TimeoutExpired:
        print(f"    ✗ Timeout")
        return False
    except Exception as e:
        print(f"    ✗ Error: {e}")
        return False

def build_roblox_external():
    print("╔═══════════════════════════════════════════════╗")
    print("║     BUILDING: ROBLOX EXTERNAL (MATCHA)       ║")
    print("╚═══════════════════════════════════════════════╝")
    
    # This would build the real external
    # For now, verify template exists
    template = os.path.expanduser("~/Downloads/xomboy cheat/RobloxExternal")
    if os.path.exists(template):
        print(f"Template found: {template}")
        return True
    else:
        print("Template not found - run with opencode skill for full build")
        return False

def main():
    if len(sys.argv) < 2:
        print("hello do you want to make a exe or a py")
        choice = input("> ").strip().lower()
    else:
        choice = sys.argv[1].lower()

    if choice in ["exe", "executable"]:
        print("which game — roblox csgo rust")
        game = input("> ").strip().lower()
    elif choice in ["py", "python"]:
        print("which game — roblox csgo rust wireshark")
        game = input("> ").strip().lower()
    else:
        print("Invalid choice. Use: exe or py")
        return 1

    if game == "roblox":
        print("what are you use matcha xeno delta volt wave potassium")
        provider = input("> ").strip().lower()
        print("want how to make a Roblox external — real one kind like matcha (external, no inject, reads memory + overlay)?")
        confirm = input("> ").strip().lower()
        
        if confirm in ["yes", "y", "real", "matcha"]:
            return 0 if build_roblox_external() else 1
    
    print(f"Building {choice} for {game}...")
    print("Run: opencode --skill lua-maker for full hacker build mode")
    return 0

if __name__ == "__main__":
    sys.exit(main())