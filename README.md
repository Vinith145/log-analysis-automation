# Log Analysis Automation

A Bash toolkit that analyzes Linux log files to surface error patterns, warning clusters, failed login attempts, and IP activity — reducing manual log review time during incident investigation.

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## Overview

During incident response, engineers often need to triage log files quickly to identify root causes. This tool automates that triage by extracting the signal from the noise: it groups errors, warns, detects brute-force patterns, and highlights suspicious IPs.

## Architecture

```
                     Log File
                        |
                        v
              +---------------------+
              |  log_analyzer.sh    |
              +----------+----------+
                         |
     +-------------------+-------------------+
     |         |         |         |         |
     v         v         v         v         v
  Error    Warning   Failed    Top IPs   Services
  groups   groups    logins    mentioned mentioned
     |         |         |         |         |
     +---------+---------+---------+---------+
                         |
                         v
              Console Report (structured)
```

## Tech Stack

- **Shell:** Bash
- **Text processing:** grep, awk, sed, sort, uniq, wc
- **OS:** Linux, macOS, Windows Git Bash

## Features

- Top 10 error pattern grouping
- Top 10 warning pattern grouping
- Failed login attempt counter (brute-force detection)
- Top 10 IP address frequency analysis
- Top 10 services/components mentioned
- Structured, timestamped console report

## Project Structure

```
log-analysis-automation/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   └── log_analyzer.sh
├── samples/
│   └── auth.log.sample
├── docs/
└── screenshots/
```

## Setup

```bash
git clone https://github.com/Vinith145/log-analysis-automation.git
cd log-analysis-automation
chmod +x scripts/log_analyzer.sh
```

## Usage

```bash
# Analyze the included sample
./scripts/log_analyzer.sh samples/auth.log.sample

# Analyze a real system log
./scripts/log_analyzer.sh /var/log/syslog
./scripts/log_analyzer.sh /var/log/auth.log
```

## Sample Output

```
===========================================
 Log Analysis Report
 File:      samples/auth.log.sample
 Generated: 2026-10-02 21:30:00
===========================================
Total lines: 20

--- Top 10 ERROR patterns ---
      4 ERROR: Disk I/O error on /dev/sda
      2 ERROR: Out of memory - killing process
      2 ERROR: upstream timeout to backend 10.0.0.10:8080
      1 ERROR: 502 Bad Gateway

--- Failed login attempts ---
Count: 5

--- Top 10 IP addresses mentioned ---
      3 192.168.1.5
      2 10.0.0.10
      1 192.168.1.100
      1 10.0.0.4
      1 10.0.0.9
      1 10.0.0.20
```

## What I Learned

- Automating log triage to accelerate incident response
- Bash text processing for structured analysis
- Extracting security-relevant signals from auth logs
- Designing scripts that work portably across Linux, macOS, and Windows Git Bash

## Future Improvements

- Parse JSON-formatted logs (systemd-journald)
- Add severity scoring to prioritize incidents
- Ship metrics to Elasticsearch / OpenSearch
- Support incremental analysis (only new lines since last run)

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.