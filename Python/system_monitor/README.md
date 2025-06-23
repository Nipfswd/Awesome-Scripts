# PySysMon

📊 **PySysMon** is a real-time system monitor dashboard implemented in Python.  
It displays CPU, memory, disk, network usage, and top processes by CPU and memory usage.

---

## Features

- Overall CPU usage and per-core CPU usage  
- RAM and Swap usage  
- Disk usage for all mounted partitions  
- Network bytes sent and received  
- Top N processes sorted by CPU and memory usage (default top 5)  
- Simple terminal dashboard updating every second

---

## Usage

Make sure you have [`psutil`](https://pypi.org/project/psutil/) installed:

```bash
pip install psutil
```

Run the script:

```bash
python py_sysmon.py
```
The dashboard will refresh every second. Press Ctrl+C to exit.
