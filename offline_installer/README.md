## How to use this
```bash
python offline_installer_builder.py MyApp offline_installer.bat
```

- Run the installer .bat:
- It will prompt for extraction path (default is current folder)
- Verify every extracted file’s SHA256 checksum
- Warn and stop if mismatch
- Run optional post-extract commands if provided
- Use /S or /silent flag for silent extraction (no prompts or echo)
