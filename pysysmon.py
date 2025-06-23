import psutil
import os
import time
from collections import namedtuple

ProcessInfo = namedtuple("ProcessInfo", ["pid", "name", "cpu_percent", "memory_percent"])

def bytes_to_human(n):
    symbols = ('B', 'KB', 'MB', 'GB', 'TB', 'PB')
    prefix = {s: 1 << (i * 10) for i, s in enumerate(symbols[1:], 1)}
    for s in reversed(symbols[1:]):
        if n >= prefix[s]:
            value = float(n) / prefix[s]
            return f"{value:.2f} {s}"
    return f"{n} B"

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_cpu():
    return psutil.cpu_percent(interval=None)

def get_per_cpu():
    return psutil.cpu_percent(interval=None, percpu=True)

def get_memory():
    vm = psutil.virtual_memory()
    swap = psutil.swap_memory()
    return vm, swap

def get_disks():
    disks = []
    for part in psutil.disk_partitions(all=False):
        try:
            usage = psutil.disk_usage(part.mountpoint)
            disks.append((part.device, part.mountpoint, usage))
        except PermissionError:
            continue
    return disks

def get_network():
    return psutil.net_io_counters()

def get_top_processes(n=5):
    procs = []
    for p in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']):
        try:
            procs.append(ProcessInfo(
                p.info['pid'], p.info['name'], p.info['cpu_percent'], p.info['memory_percent']
            ))
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue
    procs.sort(key=lambda p: (p.cpu_percent, p.memory_percent), reverse=True)
    return procs[:n]

def print_dashboard():
    clear()
    cpu = get_cpu()
    per_cpu = get_per_cpu()
    vm, swap = get_memory()
    disks = get_disks()
    net = get_network()
    top_procs = get_top_processes()

    print("📊 PySysMon - Real-Time System Monitor Dashboard")
    print("=" * 60)
    print(f"CPU Usage: {cpu}%")
    print("Per-core CPU Usage: " + ", ".join(f"{x}%" for x in per_cpu))
    print()
    print(f"RAM: {bytes_to_human(vm.used)} / {bytes_to_human(vm.total)} ({vm.percent}%)")
    print(f"Swap: {bytes_to_human(swap.used)} / {bytes_to_human(swap.total)} ({swap.percent}%)")
    print()
    print("Disks:")
    for device, mountpoint, usage in disks:
        print(f"  {device} mounted on {mountpoint} - {bytes_to_human(usage.used)} / {bytes_to_human(usage.total)} ({usage.percent}%)")
    print()
    print(f"Network: Sent: {bytes_to_human(net.bytes_sent)} | Received: {bytes_to_human(net.bytes_recv)}")
    print()
    print("Top Processes (CPU% / MEM%):")
    for p in top_procs:
        print(f"  PID {p.pid:<6} {p.name[:20]:<20} CPU: {p.cpu_percent:5.1f}% MEM: {p.memory_percent:5.1f}%")
    print("=" * 60)
    print("Press Ctrl+C to exit")

def main():
    try:
        while True:
            print_dashboard()
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nExiting PySysMon. Bye!")

if __name__ == "__main__":
    main()
