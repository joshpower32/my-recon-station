#!/bin/bash

# --- 0. AUTO-ID CONFIG ---
# This pulls your REAL IDs from a local file that ISN'T on GitHub
source ~/.hacker_identity 2>/dev/null || { BC_USER="YOUR_BC_USER"; H1_USER="YOUR_H1_USER"; INT_USER="YOUR_INT_USER"; EMAIL="your@email.com"; NTFY_TOPIC="your_private_topic"; }

# --- 1. AUTO-DETECT PROGRAM & PLATFORM ---
PROGRAM=$(basename "$(pwd)")
if [[ "$(pwd)" == *"hackerone"* ]]; then
    PLATFORM="hackerone"; HEADER="X-HackerOne-Research"; USER_ID=$H1_USER
elif [[ "$(pwd)" == *"intigriti"* ]]; then
    PLATFORM="intigriti"; HEADER="X-Intigriti-Id"; USER_ID=$INT_USER
else
    PLATFORM="bugcrowd"; HEADER="X-Bug-Bounty"; USER_ID=$BC_USER
fi

TARGETS="all_subdomains.txt"
RESULTS="live_site_results.txt"

echo -e "\033[0;32m--- 🛡️ AUTO-PILOT SENTINEL: $PROGRAM ---\033[0m"

# --- 2. SECURITY CHECK ---
if ! ip addr show tun0 > /dev/null 2>&1; then
    echo -e "\033[0;31m❌ ERROR: VPN DOWN!\033[0m"
    exit 1
fi

# --- 3. EXECUTION ---
TOTAL=$(wc -l < "$TARGETS")
cat "$TARGETS" | httpx \
    -H "$HEADER: $USER_ID" \
    -H "User-Agent: Silent-Sentinel-Scanner-Contact:($EMAIL)" \
    -rate-limit 15 -silent -o "$RESULTS" & 

# --- 4. MONITORING & CIRCUIT BREAKER ---
while pgrep -f httpx > /dev/null; do
    if [ -f "$RESULTS" ]; then
        CUR=$(wc -l < "$RESULTS")
        PER=$((CUR * 100 / TOTAL))
        
        BLOCK_COUNT=$(tail -n 10 "$RESULTS" | grep -E "429|403" | wc -l)
        
        if [ "$BLOCK_COUNT" -gt 5 ]; then
            echo -e "\n\033[0;31m🚨 CIRCUIT BREAKER TRIGGERED!\033[0m"
            pkill -f httpx
            curl -H "Priority: urgent" -d "🛑 SCAN ABORTED: $PROGRAM" ntfy.sh/$NTFY_TOPIC
            exit 2
        fi

        SIZE=$((PER / 5))
        BAR=$(printf "%${SIZE}s" | tr ' ' '#')
        EMPTY=$(printf "%$((20 - SIZE))s" | tr ' ' '-')
        printf "\rProgress: [\033[0;32m%s\033[0m\033[0;31m%s\033[0m] %d%% (%d/%d) | WAF Status: OK" "$BAR" "$EMPTY" "$PER" "$CUR" "$TOTAL"
    fi
    sleep 20
done

# --- 5. POST-SCAN ANALYSIS ---
echo -e "\n\033[0;32m✅ Complete! Sorting Intelligence...\033[0m"
sort -k2 -n "$RESULTS" -o "$RESULTS"
grep -iE "admin|dash|login|portal|staff|backend|manage|root|control|secret|config|dev|staging" "$RESULTS" > "interesting_results.txt"
grep -iE "\.env|\.git|\.config|\.sql|\.json|backup|old|draft" "$RESULTS" > "leaked_secrets.txt"

curl -d "🎯 $PROGRAM Hunt Complete!" ntfy.sh/$NTFY_TOPIC
