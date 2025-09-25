#!/usr/bin/env python3
"""
Log Collector Service
This script collects logs from various system log files and prints them with prefixes.
In a real implementation, you might want to send them to a central log server.
"""

import time
import os
import sys
import threading

def tail_file(log_file):
    if not os.path.exists(log_file):
        print(f"Log file {log_file} does not exist.", file=sys.stderr)
        return

    try:
        with open(log_file, 'r') as f:
            # Seek to the end of the file
            f.seek(0, 2)
            while True:
                line = f.readline()
                if line:
                    print(f"[{os.path.basename(log_file)}] {line.strip()}")
                time.sleep(0.1)  # Poll frequently for multiple files
    except Exception as e:
        print(f"Error reading {log_file}: {e}", file=sys.stderr)

def collect_logs():
    log_files = [
        '/var/log/syslog',
        '/var/log/auth.log',
        '/var/log/daemon.log',
        '/var/log/debug',
        '/var/log/kern.log',
        '/var/log/Xorg.0.log'
    ]

    threads = []
    for lf in log_files:
        t = threading.Thread(target=tail_file, args=(lf,))
        t.daemon = True
        t.start()
        threads.append(t)

    # Keep main thread alive
    while True:
        time.sleep(1)

if __name__ == '__main__':
    collect_logs()