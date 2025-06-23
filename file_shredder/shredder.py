import os
import random
import sys

def shred_file(path, passes=3):
    if not os.path.isfile(path):
        print(f"Error: '{path}' is not a valid file.")
        return False

    length = os.path.getsize(path)
    try:
        with open(path, "ba+", buffering=0) as f:
            for i in range(passes):
                print(f"Pass {i+1}/{passes}: Overwriting '{path}' with random data...")
                f.seek(0)
                f.write(os.urandom(length))
                f.flush()
                os.fsync(f.fileno())
        os.remove(path)
        print(f"File '{path}' shredded and deleted securely.")
        return True
    except Exception as e:
        print(f"Failed to shred file '{path}': {e}")
        return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python shredder.py <file1> [file2 ...]")
        return

    for filepath in sys.argv[1:]:
        shred_file(filepath)

if __name__ == "__main__":
    main()
