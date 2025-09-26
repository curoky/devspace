#!/usr/bin/env python3
import os


def find_duplicates(path_env):
    """Find all duplicate executables in PATH"""
    paths = path_env.split(":")
    seen = {}
    locations = {}

    for d in paths:
        if not os.path.isdir(d):
            continue
        try:
            for f in os.listdir(d):
                full_path = os.path.join(d, f)
                # Consider only executable regular files
                if os.access(full_path, os.X_OK) and os.path.isfile(full_path):
                    if f not in seen:
                        seen[f] = 0
                        locations[f] = []
                    seen[f] += 1
                    locations[f].append(full_path)
        except PermissionError:
            # Skip directories without read permission
            continue

    # Keep only duplicates
    duplicates = {cmd: loc for cmd, loc in locations.items() if len(loc) > 1}
    return duplicates


def main():
    path_env = os.environ.get("PATH", "")
    duplicates = find_duplicates(path_env)

    if not duplicates:
        print("No duplicate binaries found ✅")
        return

    print("Duplicate binaries found in PATH:")
    for cmd, locs in sorted(duplicates.items()):
        print(f"  {cmd}:")
        for i, path in enumerate(locs, 1):
            print(f"    [{i}] {path}")


if __name__ == "__main__":
    main()
