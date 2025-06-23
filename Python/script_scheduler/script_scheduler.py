import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import threading
import subprocess
import time
import os

class ScheduledScript:
    def __init__(self, path, interval, output_widget):
        self.path = path
        self.interval = interval * 60  # convert minutes to seconds
        self.output_widget = output_widget
        self._stop_event = threading.Event()
        self.thread = threading.Thread(target=self.run_loop, daemon=True)

    def start(self):
        if not self.thread.is_alive():
            self._stop_event.clear()
            self.thread = threading.Thread(target=self.run_loop, daemon=True)
            self.thread.start()
            self.log(f"Started scheduling '{self.path}' every {self.interval // 60} min")

    def stop(self):
        self._stop_event.set()
        self.log(f"Stopped scheduling '{self.path}'")

    def run_loop(self):
        while not self._stop_event.is_set():
            self.log(f"Running script: {self.path}")
            try:
                # Run the script and capture output
                proc = subprocess.Popen(self.path, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
                out, err = proc.communicate()
                if out:
                    self.log(out.decode())
                if err:
                    self.log(f"ERROR:\n{err.decode()}")
            except Exception as e:
                self.log(f"Exception: {e}")
            # Wait interval or stop event
            for _ in range(int(self.interval)):
                if self._stop_event.is_set():
                    return
                time.sleep(1)

    def log(self, msg):
        self.output_widget.configure(state='normal')
        self.output_widget.insert(tk.END, f"[{time.strftime('%H:%M:%S')}] {msg}\n")
        self.output_widget.see(tk.END)
        self.output_widget.configure(state='disabled')

class SchedulerApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Script Scheduler")
        self.geometry("700x500")
        self.scripts = {}

        # Script list
        self.listbox = tk.Listbox(self, height=8)
        self.listbox.pack(fill=tk.X, padx=10, pady=5)
        self.listbox.bind('<<ListboxSelect>>', self.on_select)

        # Buttons frame
        btn_frame = tk.Frame(self)
        btn_frame.pack(fill=tk.X, padx=10)
        tk.Button(btn_frame, text="Add Script", command=self.add_script).pack(side=tk.LEFT)
        tk.Button(btn_frame, text="Remove Script", command=self.remove_script).pack(side=tk.LEFT)
        tk.Button(btn_frame, text="Start", command=self.start_script).pack(side=tk.LEFT)
        tk.Button(btn_frame, text="Stop", command=self.stop_script).pack(side=tk.LEFT)

        # Interval entry
        interval_frame = tk.Frame(self)
        interval_frame.pack(fill=tk.X, padx=10, pady=5)
        tk.Label(interval_frame, text="Interval (minutes):").pack(side=tk.LEFT)
        self.interval_var = tk.IntVar(value=1)
        self.interval_entry = tk.Entry(interval_frame, textvariable=self.interval_var, width=5)
        self.interval_entry.pack(side=tk.LEFT)

        # Output log
        self.output = scrolledtext.ScrolledText(self, state='disabled', height=15)
        self.output.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

    def add_script(self):
        path = filedialog.askopenfilename(title="Select Script")
        if path:
            if path in self.scripts:
                messagebox.showwarning("Duplicate", "This script is already added.")
                return
            output_widget = self.output
            interval = self.interval_var.get()
            sched_script = ScheduledScript(path, interval, output_widget)
            self.scripts[path] = sched_script
            self.listbox.insert(tk.END, os.path.basename(path))

    def remove_script(self):
        sel = self.listbox.curselection()
        if not sel:
            return
        index = sel[0]
        script_path = list(self.scripts.keys())[index]
        self.scripts[script_path].stop()
        del self.scripts[script_path]
        self.listbox.delete(index)

    def start_script(self):
        sel = self.listbox.curselection()
        if not sel:
            messagebox.showinfo("Select Script", "Please select a script to start.")
            return
        index = sel[0]
        script_path = list(self.scripts.keys())[index]
        interval = self.interval_var.get()
        if interval < 1:
            messagebox.showerror("Invalid Interval", "Interval must be >= 1 minute.")
            return
        self.scripts[script_path].interval = interval * 60
        self.scripts[script_path].start()

    def stop_script(self):
        sel = self.listbox.curselection()
        if not sel:
            messagebox.showinfo("Select Script", "Please select a script to stop.")
            return
        index = sel[0]
        script_path = list(self.scripts.keys())[index]
        self.scripts[script_path].stop()

    def on_select(self, event):
        # Optional: could add details or preview here
        pass

if __name__ == "__main__":
    app = SchedulerApp()
    app.mainloop()
