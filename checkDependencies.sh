#!/bin/bash

PACKAGES=(
    "ansi-styles@6.2.2"
    "debug@4.4.2"
    "chalk@5.6.1"
    "supports-color@10.2.1"
    "strip-ansi@7.1.1"
    "ansi-regex@6.2.1"
    "wrap-ansi@9.0.1"
    "color-convert@3.1.1"
    "color-name@2.0.1"
    "is-arrayish@0.3.3"
    "slice-ansi@7.1.1"
    "color@5.0.1"
    "color-string@2.1.1"
    "simple-swizzle@0.2.3"
    "supports-hyperlinks@4.1.1"
    "has-ansi@6.0.1"
    "chalk-template@1.1.1"
    "backslash@0.2.1"
)

PROJECT_DIR="$HOME/Documents/Project"

printf "Starting automated scan for packages in yarn.lock files under: %s\n\n" "$PROJECT_DIR"

find "$PROJECT_DIR" -type f -name "yarn.lock" | while read -r YARN_LOCK_PATH; do
    REPO_PATH=$(dirname "$YARN_LOCK_PATH")
    REPO_NAME=$(basename "$REPO_PATH")

    printf "Scanning %s...\n" "$REPO_NAME"
    FOUND_ANY=false

    for pkg in "${PACKAGES[@]}"; do
        if grep -q "$pkg" "$YARN_LOCK_PATH"; then
            printf "  ✅ Found %s\n" "$pkg"
            FOUND_ANY=true
        fi
    done

    if ! $FOUND_ANY; then
        printf "  ➡️ No specified packages found.\n"
    fi
    printf "\n"
done

printf "Scan complete.\n"
