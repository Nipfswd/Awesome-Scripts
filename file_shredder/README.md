# Secure File Shredder

A simple Python script to securely delete files by overwriting their contents multiple times with random data before removing them.

---

## Features

- Overwrites a file with random bytes multiple times (default 3 passes)  
- Flushes and syncs data to disk to minimize recovery chances  
- Deletes the file after overwriting  
- Supports shredding multiple files at once via command line arguments

---

## Requirements

- Python 3.x  
- No external dependencies

---

## Usage

Run the script with one or more file paths as arguments:

```bash
python shredder.py <file1> [file2 ...]
```

Example:

python shredder.py secret.txt confidential.docx
