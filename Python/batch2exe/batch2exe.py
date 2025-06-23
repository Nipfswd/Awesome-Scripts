import os
import sys
import tempfile
import subprocess

C_TEMPLATE = r'''
#include <windows.h>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
    // Create temp file
    char tempPath[MAX_PATH];
    char tempFile[MAX_PATH];
    GetTempPathA(MAX_PATH, tempPath);
    GetTempFileNameA(tempPath, "bat", 0, tempFile);

    // Write batch commands to temp file
    const char* batContent = 
%s
    ;
    FILE *f = fopen(tempFile, "w");
    if (!f) return 1;
    fputs(batContent, f);
    fclose(f);

    // Run batch file hidden
    SHELLEXECUTEINFOA sei = { sizeof(sei) };
    sei.fMask = SEE_MASK_NOCLOSEPROCESS;
    sei.hwnd = NULL;
    sei.lpVerb = "open";
    sei.lpFile = "cmd.exe";
    char params[1024];
    sprintf(params, "/c \"%s\"", tempFile);
    sei.lpParameters = params;
    sei.nShow = SW_HIDE;
    if (!ShellExecuteExA(&sei)) {
        DeleteFileA(tempFile);
        return 1;
    }

    // Wait for batch to finish
    WaitForSingleObject(sei.hProcess, INFINITE);
    CloseHandle(sei.hProcess);

    // Delete temp batch file
    DeleteFileA(tempFile);
    return 0;
}
'''

def escape_c_string(s):
    # Escape backslashes, double quotes, newlines for embedding in C string literal
    s = s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n"\n"')
    return '"' + s + '"'

def main():
    if len(sys.argv) != 3:
        print("Usage: python bat2exe.py input.bat output.exe")
        return

    bat_path = sys.argv[1]
    out_path = sys.argv[2]

    if not os.path.isfile(bat_path):
        print(f"Error: {bat_path} not found.")
        return

    with open(bat_path, "r", encoding="utf-8") as f:
        bat_code = f.read()

    bat_code_c = escape_c_string(bat_code)
    c_code = C_TEMPLATE % bat_code_c

    with tempfile.TemporaryDirectory() as tmpdir:
        c_file = os.path.join(tmpdir, "launcher.c")
        with open(c_file, "w", encoding="utf-8") as f:
            f.write(c_code)

        # Compile with gcc
        print("Compiling...")
        cmd = ["gcc", c_file, "-o", out_path, "-mwindows"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print("Compilation failed:")
            print(result.stderr)
            return

    print(f"Created executable: {out_path}")

if __name__ == "__main__":
    main()
