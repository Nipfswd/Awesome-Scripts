# Batch to EXE Converter (`bat2exe.py`)

A Python script that converts a Windows batch file (`.bat`) into a standalone hidden executable (`.exe`).  
The generated EXE runs the batch commands silently by creating and executing a temporary batch file in the background.

---

## Features

- Embeds batch script inside a minimal C launcher  
- Runs batch commands hidden without showing a console window  
- Cleans up temporary files after execution  
- Uses `gcc` to compile the generated C code (requires MinGW or similar on Windows)  

---

## Requirements

- Python 3.x  
- GCC compiler (MinGW or compatible) accessible from command line  

---

## Usage

```bash
python bat2exe.py input.bat output.exe
```
- input.bat: Path to your source batch file
- output.exe: Desired path/name for the generated EXE file

Example:
```bash
python bat2exe.py myscript.bat myscript.exe
```

## How It Works

- Reads the batch file content and escapes it to a C string literal
- Injects the batch commands into a C program template that:
- Creates a temporary batch file
- Executes it hidden using Windows API (ShellExecuteEx)
- Waits for execution to finish
- Deletes the temporary batch file
- Writes the C code to a temporary file
- Invokes GCC to compile the C launcher into a Windows GUI EXE (-mwindows flag)
- Outputs the final EXE to the specified location

## Notes

- Ensure you have GCC installed and added to your system PATH
- The generated EXE will not show a console window when running
- The batch commands run with the same privileges as the EXE
- This tool is Windows-specific
