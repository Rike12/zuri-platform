#!/bin/bash
URL="${1:-http://localhost:3000/health}"
REPORT="${2:-$HOME/health_report.txt}"
TS=$(date '+%Y-%m-%d %H:%M:%S')
CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$URL")
if [ "$CODE" = "200" ]; then echo "$TS | $URL | UP ($CODE)" >> "$REPORT"
else echo "$TS | $URL | DOWN ($CODE)" >> "$REPORT"; fi
