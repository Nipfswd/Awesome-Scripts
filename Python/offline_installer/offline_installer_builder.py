import os
import base64
import hashlib
from pathlib import Path
import textwrap

CHUNK_SIZE = 1024  # base64 chars per echo line chunk

def encode_file_to_base64_chunks(filepath):
    with open(filepath, "rb") as f:
        data = f.read()
    b64 = base64.b64encode(data).decode('ascii')
    return [b64[i:i+CHUNK_SIZE] for i in range(0, len(b64), CHUNK_SIZE)]

def sha256_checksum(filepath):
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        while True:
            chunk = f.read(8192)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest().upper()

def escape_batch_line(line):
    # Escape batch special chars: ^ & < > | 
    return line.replace("^", "^^").replace("&", "^&").replace("<", "^<").replace(">", "^>").replace("|", "^|")

def generate_batch_script(src_dir, out_bat, post_extract_cmds=None):
    src_dir = Path(src_dir).resolve()
    files = [f for f in src_dir.rglob("*") if f.is_file()]
    post_extract_cmds = post_extract_cmds or []

    # Prepare hashes
    file_hashes = {str(f.relative_to(src_dir)).replace("/", "\\"): sha256_checksum(f) for f in files}

    with open(out_bat, "w", encoding="utf-8-sig") as bat:
        bat.write(textwrap.dedent(r"""
            @echo off
            chcp 65001 >nul
            title Offline Installer - Extracting Files
            setlocal enabledelayedexpansion

            :: Detect silent mode if /S or /silent passed as param
            set "silent=false"
            for %%a in (%*) do (
                if /I "%%a"=="/S" set silent=true
                if /I "%%a"=="/silent" set silent=true
            )

            if "%silent%"=="false" (
                echo *** Offline Installer Extraction ***
                echo.
                set /p DEST=Enter extraction path (default is current folder): 
                if "%DEST%"=="" set "DEST=%CD%"
                if not exist "%DEST%" mkdir "%DEST%"
                echo Extracting to: "%DEST%"
                echo.
                pushd "%DEST%"
            ) else (
                :: Silent mode: use current directory, no prompt
                set "DEST=%CD%"
                pushd "%DEST%"
            )
            """) + "\n")

        # Create directories
        folders = set(f.parent.relative_to(src_dir) for f in files)
        for folder in sorted(folders):
            if str(folder) != ".":
                bat.write(f'mkdir "{folder}" 2>nul\n')

        bat.write("\n")

        # Extract files
        for f in files:
            rel_path = f.relative_to(src_dir)
            rel_path_str = str(rel_path).replace("/", "\\")
            hash_val = file_hashes[rel_path_str]

            bat.write(f'if "%silent%"=="false" echo Writing file: {rel_path_str}\n')

            tmp_b64_file = f"{rel_path_str}.b64"
            bat.write(f'( > "{tmp_b64_file}" (\n')
            for chunk in encode_file_to_base64_chunks(f):
                bat.write(escape_batch_line(chunk) + "\n")
            bat.write(') )\n')

            bat.write(f'certutil -decode "{tmp_b64_file}" "{rel_path_str}" >nul 2>&1\n')
            bat.write(f'del "{tmp_b64_file}"\n')

            # Checksum verification
            bat.write(textwrap.dedent(f"""
                certutil -hashfile "{rel_path_str}" SHA256 | findstr /I "{hash_val}" >nul
                if errorlevel 1 (
                    echo ERROR: Checksum mismatch detected for file "{rel_path_str}"!
                    echo Extraction failed.
                    pause
                    exit /b 1
                )
            """))

            bat.write("\n")

        bat.write(textwrap.dedent(r"""
            if "%silent%"=="false" (
                echo Extraction complete!
                echo.
                popd
                echo Running post-extraction commands...
            ) else (
                popd
            )
        """))

        # Post-extract commands
        if post_extract_cmds:
            for cmd in post_extract_cmds:
                bat.write(f'{cmd}\n')

        bat.write(textwrap.dedent(r"""
            if "%silent%"=="false" (
                echo.
                echo Done.
                pause
            )
            endlocal
            """))

if __name__ == "__main__":
    import sys

    USAGE = (
        "Usage:\n"
        "  python offline_installer_builder.py <source_dir> <output_installer.bat> [post_extract_cmds...]\n\n"
        "Example:\n"
        "  python offline_installer_builder.py MyApp offline_installer.bat \"cd MyApp && setup.exe\"\n"
        "  python offline_installer_builder.py MyApp offline_installer.bat /silent\n"
    )

    if len(sys.argv) < 3:
        print(USAGE)
        sys.exit(1)

    source_folder = sys.argv[1]
    output_script = sys.argv[2]
    post_commands = sys.argv[3:]

    generate_batch_script(source_folder, output_script, post_commands)
    print(f"Offline installer batch script created: {output_script}")
