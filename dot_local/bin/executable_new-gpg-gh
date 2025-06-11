#!/bin/bash

# GPG Key Generation and GitHub Setup Script
set -e

echo "🔑 Setting up new GPG key for GitHub..."

# Get user info
read -p "Enter your full name: " FULL_NAME
read -p "Enter your GitHub email: " EMAIL

# Generate GPG key
# Generate GPG key (skip if one already exists)
if gpg --list-secret-keys --keyid-format=long | grep -q 'sec'; then
    echo "GPG key already exists, using existing key..."
    KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep 'sec' | head -1 | sed 's/.*\/\([A-F0-9]*\) .*/\1/')
else
    echo "Generating GPG key..."
    gpg --batch --full-generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $FULL_NAME
Name-Email: $EMAIL
Expire-Date: 0
%no-ask-passphrase
%no-protection
%commit
%echo done
EOF
    KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep 'sec' | head -1 | sed 's/.*\/\([A-F0-9]*\) .*/\1/')
fi

echo "Generated key ID: $KEY_ID"

# Export public key
echo "Exporting public key..."
GPG_PUBLIC_KEY=$(gpg --armor --export $KEY_ID)

# Configure git to use the key
echo "Configuring git..."
git config --global user.signingkey $KEY_ID
git config --global commit.gpgsign true
git config --global gpg.program gpg

# Check and refresh GitHub CLI permissions
echo "Checking GitHub CLI permissions..."
if ! gh auth status --show-token 2>/dev/null | grep -q "write:gpg_key"; then
    echo "Refreshing GitHub CLI permissions..."
    gh auth refresh -s write:gpg_key
fi

# Add key to GitHub using gh CLI (check if already exists first)
echo "Adding key to GitHub..."
if gh gpg-key list | grep -q "$KEY_ID"; then
    echo "Key $KEY_ID already exists on GitHub, skipping..."
else
    echo "$GPG_PUBLIC_KEY" | gh gpg-key add --title "$(hostname)-$(date +%Y%m%d)"
fi

# Test signing
echo "Testing GPG signing..."
echo "test" | gpg --clearsign --default-key $KEY_ID

echo "✅ GPG key setup complete!"
echo ""
echo "Key ID: $KEY_ID"
echo "Your commits will now be signed automatically."
echo ""
echo "To verify, run: gpg --list-secret-keys --keyid-format=long"
