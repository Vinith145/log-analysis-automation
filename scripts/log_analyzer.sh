#!/bin/bash
# log_analyzer.sh - Analyze log files for errors, warnings, and patterns
# Author: Balakumar K T
# Usage: ./log_analyzer.sh <logfile>

set -euo pipefail

LOG=${1:?Usage: log_analyzer.sh <logfile>}

if [ ! -f "$LOG" ]; then
  echo "[ERROR] File not found: $LOG"
  exit 1
fi

echo "==========================================="
echo " Log Analysis Report"
echo " File:      $LOG"
echo " Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

TOTAL=$(wc -l < "$LOG")
echo "Total lines: $TOTAL"
echo ""

# Helper: strip syslog prefix and kernel timestamp
# Handles:
#   Oct  2 10:20:00 server sshd[1234]: Failed password...
#   Oct 2 10:20:00 server kernel: [12345.6] ERROR: Disk I/O error...
strip_prefix() {
  sed -E \
    -e 's/^[A-Z][a-z]{2} +[0-9]+ [0-9:]+ [^ ]+ [^:]+: +//' \
    -e 's/^\[[0-9]+\.[0-9]+\] +//'
}

# --- Top ERROR patterns (grouped) ---
echo "--- Top 10 ERROR patterns ---"
grep -i "error" "$LOG" 2>/dev/null \
  | strip_prefix \
  | sort | uniq -c | sort -rn | head -n 10 \
  || echo "No errors found"
echo ""

# --- Top WARNING patterns (grouped) ---
echo "--- Top 10 WARNING patterns ---"
grep -i "warn" "$LOG" 2>/dev/null \
  | strip_prefix \
  | sort | uniq -c | sort -rn | head -n 10 \
  || echo "No warnings found"
echo ""

# --- Failed login attempts ---
echo "--- Failed login attempts ---"
FAILED=$(grep -ci "failed password" "$LOG" 2>/dev/null || echo 0)
echo "Count: $FAILED"
echo ""

# --- Top IP addresses ---
echo "--- Top 10 IP addresses mentioned ---"
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG" 2>/dev/null \
  | sort | uniq -c | sort -rn | head -n 10 \
  || echo "No IPs found"
echo ""

# --- Top services/components ---
echo "--- Top 10 services/components ---"
grep -oE '[a-z]+\[[0-9]+\]|systemd|kernel|sshd|cron|nginx' "$LOG" 2>/dev/null \
  | sed -E 's/\[[0-9]*\]//' \
  | sort | uniq -c | sort -rn | head -n 10 \
  || echo "No services found"
echo ""

echo "==========================================="
echo "Report complete."
echo "==========================================="