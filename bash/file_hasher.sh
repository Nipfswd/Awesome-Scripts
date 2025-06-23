#!/bin/bash

# ============================
# 🔒 SUPER PRO MAX FILE HASHER
# Author: Noah.J
# ============================

LOGFILE="./file_hasher.log"
HASH_ALGO="sha256"  # default

function log() {
    echo "$1"
    echo "$1" >> "$LOGFILE"
}

function check_tools() {
    for tool in sha256sum sha512sum md5sum openssl; do
        if command -v "$tool" >/dev/null 2>&1; then
            log "✅ Found tool: $tool"
        fi
    done
}

function select_algorithm() {
    echo "Choose hash algorithm:"
    select opt in SHA256 SHA512 MD5; do
        case $opt in
            SHA256) HASH_ALGO="sha256"; break ;;
            SHA512) HASH_ALGO="sha512"; break ;;
            MD5) HASH_ALGO="md5"; break ;;
            *) echo "Invalid option." ;;
        esac
    done
}

function generate_hash() {
    local file="$1"
    local output

    if [[ ! -f "$file" ]]; then
        log "❌ File not found: $file"
        exit 1
    fi

    log "🔄 Generating $HASH_ALGO hash for: $file"

    case "$HASH_ALGO" in
        sha256)
            if command -v sha256sum >/dev/null 2>&1; then
                output=$(sha256sum "$file")
            else
                output=$(openssl dgst -sha256 "$file")
            fi
            ;;
        sha512)
            if command -v sha512sum >/dev/null 2>&1; then
                output=$(sha512sum "$file")
            else
                output=$(openssl dgst -sha512 "$file")
            fi
            ;;
        md5)
            if command -v md5sum >/dev/null 2>&1; then
                output=$(md5sum "$file")
            else
                output=$(openssl dgst -md5 "$file")
            fi
            ;;
    esac

    log "✅ Hash: $output"
    echo "$output"
}

function verify_hash() {
    local file="$1"
    local expected="$2"
    local actual=$(generate_hash "$file" | awk '{print $1}')

    log "🔍 Verifying hash..."
    if [[ "$actual" == "$expected" ]]; then
        echo -e "\e[32m✔ Hash matches!\e[0m"
        log "✔ Verification passed"
    else
        echo -e "\e[31m✖ Hash mismatch!\e[0m"
        log "✖ Verification failed"
    fi
}

function usage() {
    echo "Usage:"
    echo "  $0 generate <file> [algorithm]"
    echo "  $0 verify <file> <expected_hash> [algorithm]"
    echo "Supported algorithms: sha256 (default), sha512, md5"
    exit 1
}

# ------------- MAIN ---------------

mkdir -p "$(dirname "$LOGFILE")"
echo "=== FILE HASHER LOG - $(date) ===" > "$LOGFILE"
check_tools

if [[ $# -lt 2 ]]; then
    usage
fi

ACTION="$1"
FILE="$2"
EXPECTED="$3"
ALGO="$4"

# Allow algorithm override from CLI
if [[ -n "$ALGO" ]]; then
    HASH_ALGO="$ALGO"
fi

case "$ACTION" in
    generate)
        generate_hash "$FILE"
        ;;
    verify)
        if [[ -z "$EXPECTED" ]]; then
            echo "Missing expected hash!"
            usage
        fi
        verify_hash "$FILE" "$EXPECTED"
        ;;
    *)
        usage
        ;;
esac
