#!/bin/bash

URL="${HEALTH_URL:-http://localhost:5000/health}"
REPORT_FILE="${HEALTH_REPORT_FILE:-/var/log/zuri-health-report.log}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

if curl -fsS --max-time 10 "$URL" > /dev/null; then
  echo "$TIMESTAMP - HEALTHY - $URL" >> "$REPORT_FILE"
else
  echo "$TIMESTAMP - UNHEALTHY - $URL" >> "$REPORT_FILE"
fi
