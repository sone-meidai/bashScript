#!/bin/bash

# User-Agent string to mimic Googlebot
USER_AGENT="Googlebot/2.1 (+http://www.google.com/bot.html)"

# Colors for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# List of domains
DOMAINS=(
    "https://uk88.vip"
    "https://xo88.pro"
    "https://11bet.com"
    "https://lucky88.in"
    "https://ta88.pro"
    "https://one88.pro"
    "https://net88.tv"
    "https://da88.vip"
    "https://bu88.com"
    "https://co88.win"
    "https://du88.com"
    "https://tx88.com"
    "https://ga88.top"
    "https://vk88.com"
    "https://bom88.com"
    "https://tip88.com"
    "https://ho88.com"
    "https://kbet.com"
    "https://mb88.vip"
    "https://vu88.com"
    "https://mbet.win"
    "https://nc88.net"
    "https://sb88.net"
    "https://vabet.com"
    "https://pi88.vip"
    "https://bet79.win"
    "https://789go.win"
    "https://man88.net"
    "https://kb88.win"
    "https://de88.win"
    "https://11win.net"
    "https://kvip.win"
    "https://vi88.net"
    "https://m79.win"
    "https://q88.win"
    "https://s88.vip"
    "https://vf8.net"
    "https://gbet.win"
    "https://86win.club"
)

# Loop through each domain
for domain in "${DOMAINS[@]}"; do
    echo -e "${CYAN}Checking: ${YELLOW}$domain${NC}"
    
    # Fetch content and check for the specific string
    if curl -s -A "$USER_AGENT" "$domain" | grep -q "Attention Required! | Cloudflare"; then
        echo -e "${RED}⚠️  Found Cloudflare protection on: $domain${NC}\n"
    else
        echo -e "${GREEN}✅ No Cloudflare warning on: $domain${NC}\n"
    fi
done

