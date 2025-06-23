import tkinter as tk
from tkinter import messagebox
import psutil

class ProcessKillerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Process Killer")

        self.process_listbox = tk.Listbox(root, width=50, height=20)
        self.process_listbox.pack(padx=10, pady=10)

        btn_frame = tk.Frame(root)
        btn_frame.pack(pady=5)

        refresh_btn = tk.Button(btn_frame, text="Refresh List", command=self.refresh_processes)
        refresh_btn.pack(side=tk.LEFT, padx=5)

        kill_btn = tk.Button(btn_frame, text="Kill Selected", command=self.kill_selected_process)
        kill_btn.pack(side=tk.LEFT, padx=5)

        self.refresh_processes()

    def refresh_processes(self):
        self.process_listbox.delete(0, tk.END)
        self.processes = []
        for proc in psutil.process_iter(['pid', 'name']):
            try:
                proc_info = proc.info
                display_text = f"{proc_info['name']} (PID: {proc_info['pid']})"
                self.process_listbox.insert(tk.END, display_text)
                self.processes.append(proc)
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                continue

    def kill_selected_process(self):
        selection = self.process_listbox.curselection()
        if not selection:
            messagebox.showwarning("No Selection", "Please select a process to kill.")
            return
        index = selection[0]
        proc = self.processes[index]
        try:
            proc.terminate()
            proc.wait(timeout=3)
            messagebox.showinfo("Success", f"Process {proc.pid} terminated.")
            self.refresh_processes()
        except psutil.NoSuchProcess:
            messagebox.showinfo("Info", "Process already terminated.")
            self.refresh_processes()
        except psutil.AccessDenied:
            messagebox.showerror("Error", "Access denied: unable to terminate this process.")
        except psutil.TimeoutExpired:
            messagebox.showerror("Error", "Timeout: process did not terminate.")

if __name__ == "__main__":
    root = tk.Tk()
    app = ProcessKillerApp(root)
    root.mainloop()
