🛡️ MY RECON STATION
Status: 🟢 OPERATIONAL | Node: Home-Server-24/7
A fully automated bug bounty hunting station built on a repurposed Chromebook running Linux. Designed to run silent, deep, and continuous — generating real findings while I sleep.

⚡ THE HARDWARE ADVANTAGE
Most bug hunters rent cloud VMs. This setup costs nothing to run:

Hardware: Repurposed Chromebook running Linux (Crouton/ChromeOS Linux)
Power Draw: ~5–10W TDP — pennies per month in electricity
Built-in UPS: Internal battery provides ~10 hours of uptime during power outages — the hunt never stops
Fanless & Silent: No moving parts, no noise, sits on a shelf 24/7
Total Setup Cost: $0 (existing hardware, repurposed)


A $0 server running 24/7 automation is a legitimate edge in bug bounty hunting.


🚀 WHAT IT RUNS
The station runs multiple automated scripts on cron schedules targeting live bug bounty programs:
ScriptSchedulePurposeCross-tenant IDOR automatorEvery 30 minState-change detection across org boundariesCross-org access control testerEvery 30 minBroken access control probingPassive reconEvery 8 hoursSubdomain + endpoint harvestingNuclei scanner2am nightlyCVE and misconfiguration detectionVPN health checkEvery 5 minKill-switch enforcement via tun0
Active target types: SaaS platforms, identity providers, cloud infrastructure programs

🧠 THE CORE STRATEGY
Standard recon finds subdomains. This station goes further — it detects state changes.
The approach:

Authenticate as two separate accounts (attacker + victim)
Snapshot victim-owned resources before any action
Send attacker requests attempting cross-account access
Snapshot again and compare — alert only on confirmed impact

This eliminates false positives and produces report-ready findings with before/after proof.

🔔 ALERTING
Real-time push notifications via ntfy.sh — findings arrive on my phone the moment they're confirmed. No polling, no checking logs manually.
Alerts fire only on:

Confirmed cross-account state changes (IDOR)
Unexpected 200s on restricted endpoints
Nuclei high/critical findings


💰 EARNING POTENTIAL
Bug bounty payouts on active targets:
Target TypeAvg Payout RangeCloud infrastructure platforms$1,500–$2,000+Identity / SSO providers$500–$1,500SaaS web apps$400–$1,000Hosting / DevOps platforms$400–$1,000
A single confirmed IDOR pays for months of equivalent cloud compute time. The homeserver's advantage compounds over time — every hour it runs is free.

🛠️ TECH STACK

Shell scripting — all automation in Bash
Python — IDOR detection scripts with state-comparison logic
httpx — fast HTTP probing with custom headers
Nuclei — template-based vulnerability scanning
ntfy.sh — push notification alerting
VPN kill-switch — tun0 enforcement, auto-pause on VPN drop
cron — persistent scheduling, survives reboots


⚖️ ETHICAL STANDARDS
Every request identifies itself. All scanning runs at conservative rate limits to avoid service disruption.
X-Bug-Bounty: joshuadanielca
Rate limit: max 5 req/sec per target
Scope: strictly in-scope endpoints only
All programs tested are enrolled in active bug bounty programs on Bugcrowd or Intigriti. Out-of-scope targets are never touched.

👤 Author
Joshua Daniel Power
GitHub: joshpower32
X: @joshuadanielca
Developed by : Github JoshPower32 / X joshuadanielca
