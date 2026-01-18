# 🛡️ THE SILENT SENTINEL: RECON STATION
> **Status:** 🟢 OPERATIONAL | **Node:** Recon-Home-Server

An ultra-efficient, 24/7 automated reconnaissance node built for long-haul bug bounty hunting. This station is designed to run "silent and deep scans", gathering intelligence while maintaining a zero-footprint profile on local resources.

---

## ⚡ THE ADVANTAGE
This setup isn't just a script; it's a dedicated hardware strategy:
* **Zero-Cost Power:** Running on a repurposed, fanless Chromebook with a TDP of ~5-10W. It costs pennies to run monthly.
* **Built-in UPS:** The internal Chromebook battery acts as a 10-hour Uninterruptible Power Supply (UPS). If the house loses power, the hunt continues.
* **Silent Sentinel Logic:** Custom circuit-breaker logic monitors WAF responses in real-time to avoid IP bans and maintain ethical research standards.

## 🚀 THE TECH STACK
* **Automation:** `master_auto_pilot.sh` (The Brain)
* **Probing:** `httpx` with custom identification headers.
* **Safety:** Automated VPN Kill-switch (`tun0` check).
* **Intelligence:** Regex-based filtering for secrets, `.env` files, and high-value management portals.
* **Monitoring:** Real-time push notifications via `ntfy.sh`.

## 🛠️ OPERATION
1. **Prepare:** Drop subdomains into `all_subdomains.txt`.
2. **Execute:** ```bash
   sentinel```
   
## ⚖️ ETHICAL STANDARDS
This node identifies itself in every request. All scanning is performed at a conservative rate-limit (15 req/sec) to ensure no disruption of service to target infrastructure.

**Header:** X-Bug-Bounty: joshuadanielca

**User-Agent:** X-Bug-Bounty: joshuadanielca


Developed by : Github JoshPower32 / X joshuadanielca
