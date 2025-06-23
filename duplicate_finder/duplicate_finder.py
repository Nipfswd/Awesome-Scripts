import os
import hashlib
from collections import defaultdict
from pathlib import Path

def sha256_file(path, chunk_size=8192):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while chunk := f.read(chunk_size):
            h.update(chunk)
    return h.hexdigest()

def find_duplicates(folder):
    folder = Path(folder).resolve()
    hash_map = defaultdict(list)

    print(f"Scanning files in: {folder}\n")

    for file_path in folder.rglob("*"):
        if file_path.is_file():
            try:
                file_hash = sha256_file(file_path)
                hash_map[file_hash].append(file_path)
            except Exception as e:
                print(f"Error reading {file_path}: {e}")

    duplicates = {h: paths for h, paths in hash_map.items() if len(paths) > 1}

    if not duplicates:
        print("No duplicate files found!")
        return

    print(f"Found {len(duplicates)} sets of duplicate files:\n")
    for i, (h, files) in enumerate(duplicates.items(), 1):
        print(f"--- Duplicate Set #{i} (SHA256: {h}) ---")
        for f in files:
            print(f"  {f}")
        print()

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python duplicate_finder.py <folder_to_scan>")
        exit(1)

    find_duplicates(sys.argv[1])
