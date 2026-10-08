# Health Check Evidence

## Deployment
- Host: AWS EC2 (Amazon Linux 2023)
- Endpoint checked: `http://localhost/health`
- Script: `/home/ec2-user/health-check.sh`
- Report: `/home/ec2-user/zuri-health-report.log`

## Successful test
The health-check script ran successfully on 8 October 2026.

Example report entry:
`2026-10-08 22:34:13 - HEALTHY - http://localhost/health`

## Automated schedule
Cron service: `crond` — active

Schedule: Daily at 00:00 UTC

```cron
0 0 * * * HEALTH_URL=http://localhost/health HEALTH_REPORT_FILE=/home/ec2-user/zuri-health-report.log /home/ec2-user/health-check.sh
```

## Verification
- [x] Script copied to EC2 and made executable
- [x] Manual health check returned `HEALTHY`
- [x] Timestamped report created
- [x] Cron service active
- [x] Daily cron entry installed

Note: The example above records the successful manual test. Verify the report after the next scheduled run to capture evidence of automated execution.
