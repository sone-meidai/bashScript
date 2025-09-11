#!/bin/bash

# List of URLs to check
URLS=(
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
    "https://k88.pro"
    "https://mb88.pro"
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
    "https://hi88.ag"
    "https://789bet.soy"
    "https://f8bet.mba"
    "https://m88a.club"
)

echo "Checking sites for Cloudflare attention page..."

# Loop through each URL
for URL in "${URLS[@]}"; do
    echo -n "Checking $URL ... "

    # Fetch the page content
    RESPONSE=$(curl -s --max-time 10 "$URL")

    # Check for Cloudflare "Attention Required" message
    if echo "$RESPONSE" | grep -q "Attention Required! | Cloudflare"; then
        echo "⚠️ Cloudflare challenge detected"
    else
        echo "✅ OK"
    fi
done

