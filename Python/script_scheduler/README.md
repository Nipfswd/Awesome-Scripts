# Script Scheduler

A simple Python Tkinter application to schedule and run scripts periodically with real-time output logging.

---

## Features

- Add multiple scripts to schedule  
- Set individual run intervals (in minutes) for each script  
- Start and stop scheduled execution per script  
- View live output and error logs in the GUI  
- Runs scripts asynchronously without freezing the UI

---

## Requirements

- Python 3.x  
- No external dependencies (uses standard `tkinter`, `subprocess`, and `threading` modules)

---

## Usage

Run the app:

```bash
python scheduler.py
```

## How to use

- Click Add Script and select a script file to schedule
- Enter the run interval in minutes (default 1 minute)
- Select the script from the list
- Click Start to begin periodic execution
- Click Stop to halt execution
- View script output and errors in the scrolling log area

## Implementation details

- Scripts run in separate background threads to keep the UI responsive
- Script output and errors are captured and displayed live in the GUI
- Scheduling interval countdown runs per second to allow graceful stopping
- Uses subprocess.Popen with shell=True to execute scripts, so it supports any executable type recognized by your OS

## Notes

- Make sure scripts are executable and have proper permissions
- Interval minimum is 1 minute to avoid excessive CPU load
- This tool is intended for simple local automation tasks
