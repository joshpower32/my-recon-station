#!/bin/bash

# --- 0. AUTO-ID CONFIG ---
# Pulls your REAL IDs from a local file that ISN'T on GitHub
source ~/.hacker_identity 2>/dev/null || { 
    BC_USER="YOUR_BC_USER"; 
    H1_USER="YOUR_H1_USER"; 
    INT_USER="YOUR_INT_USER"; 
    EMAIL="your@email.com"; 
    NTFY_TOPIC="joshuadanielca-homeserver-notify"; 
}

# --- 1. AUTO-DETECT PROGRAM & PLATFORM ---
PROGRAM=$(basename "$(pwd)")
CURRENT_PATH=$(pwd)

if [[ "$CURRENT_PATH" == *"hackerone"* ]]; then
    PLATFORM="hackerone"; HEADER="X-HackerOne-Research"; USER_ID=$H1_USER
elif [[ "$CURRENT_PATH" == *"intigriti"* ]]; then
    PLATFORM="intigriti"; HEADER="X-Intigriti-Id"; USER_ID=$INT_USER
else
    # Defaulting to Bugcrowd for your FIS hunt
    PLATFORM="bugcrowd"; HEADER="X-Bug-Bounty"; USER_ID=$BC_USER
fi

TARGETS="all_subdomains.txt"
RESULTS="live_site_results.txt"

echo -e "\033[0;32m--- 🛡️ AUTO-PILOT SENTINEL: $PROGRAM ($PLATFORM) ---\033[0m"

# --- 2. SECURITY & FILE CHECK ---
if ! ip addr show tun0 > /dev/null 2>&1; then
    echo -e "\033[0;31m❌ ERROR: VPN (tun0) DOWN!\033[0m"
    exit 1
fi

if [ ! -f "$TARGETS" ]; then
    echo -e "\033[0;31m❌ ERROR: $TARGETS not found in $(pwd)\033[0m"
    exit 1
fi

# --- 3. EXECUTION ---
TOTAL=$(wc -l < "$TARGETS")
echo "[+] Probing $TOTAL targets..."

# We run httpx in the background so the loop below can monitor it
cat "$TARGETS" | httpx \
    -H "$HEADER: $USER_ID" \
    -H "User-Agent: Silent-Sentinel-Scanner-Contact:($EMAIL)" \
    -rate-limit 15 -silent -o "$RESULTS" & 

# --- 4. MONITORING & CIRCUIT BREAKER ---
while pgrep -f httpx > /dev/null; do
    if [ -f "$RESULTS" ]; then
        CUR=$(wc -l < "$RESULTS")
        # Prevent division by zero if scan just started
        if [ "$TOTAL" -gt 0 ]; then
            PER=$((CUR * 100 / TOTAL))
        else
            PER=0
        fi
        
        # Circuit Breaker: Check for high rate of blocks (429/403)
        BLOCK_COUNT=$(tail -n 20 "$RESULTS" | grep -E "429|403" | wc -l)
        
        if [ "$BLOCK_COUNT" -gt 10 ]; then
            echo -e "\n\033[0;31m🚨 CIRCUIT BREAKER TRIGGERED! WAF IS ANGRY.\033[0m"
            pkill -f httpx
            curl -H "Priority: urgent" -d "🛑 SCAN ABORTED: $PROGRAM (WAF Blocked)" ntfy.sh/$NTFY_TOPIC
            exit 2
        fi

        # Visual Progress Bar
        SIZE=$((PER / 5))
        BAR=$(printf "%${SIZE}s" | tr ' ' '#')
        EMPTY=$(printf "%$((20 - SIZE))s" | tr ' ' '-')
        printf "\rProgress: [\033[0;32m%s\033[0m\033[0;31m%s\033[0m] %d%% (%d/%d) | Status: HUNTING..." "$BAR" "$EMPTY" "$PER" "$CUR" "$TOTAL"
    fi
    sleep 10
done

# --- 5. POST-SCAN ANALYSIS ---
echo -e "\n\033[0;32m✅ Complete! Sorting Intelligence...\033[0m"

if [ -f "$RESULTS" ]; then
    # Organize the "Loot"
    grep -iE "admin|dash|login|portal|staff|backend|manage|root|control|secret|config|dev|staging" "$RESULTS" > "interesting_results.txt"
    grep -iE "\.env|\.git|\.config|\.sql|\.json|backup|old|draft" "$RESULTS" > "leaked_secrets.txt"
    
    FINAL_COUNT=$(wc -l < "$RESULTS")
    curl -d "🎯 $PROGRAM Hunt Complete! Found $FINAL_COUNT live targets." ntfy.sh/$NTFY_TOPIC
else
    echo "❌ No results found."
fi
