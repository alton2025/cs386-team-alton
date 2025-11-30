#!/bin/bash

########################################
# CS386 Final Project - User Automation
# Author: Alton
# Description:
# Reads CSV file and automatically:
# 1. Creates groups
# 2. Creates users
# 3. Creates /home/<user>/www directory
# 4. Generates SSH key pairs
########################################

INPUT="cs386-project-data.csv"

echo "=== CS386 USER PROVISION SCRIPT START ==="
echo "Using CSV: $INPUT"
echo

# Convert CSV from Windows/Mac to Linux format
if command -v dos2unix >/dev/null 2>&1; then
    dos2unix "$INPUT" 2>/dev/null
    echo "CSV converted to UNIX format."
else
    echo " ERROR: dos2unix NOT installed."
    echo "    If CSV was exported from Google Sheets or Windows,"
    echo "    line endings may break parsing."
fi

echo

# Process CSV line by line
# username,group
while IFS=',' read -r username group
do
    echo "----------------------------------------"
    echo "Processing USER: $username | GROUP: $group"

    # 1. CREATE GROUP IF MISSING
    if ! getent group "$group" >/dev/null; then
        echo "[+] Creating group: $group"
        sudo groupadd "$group"
    else
        echo "[=] Group '$group' already exists."
    fi

    # 2. CREATE USER IF MISSING
    if ! id "$username" >/dev/null 2>&1; then
        echo "Creating user: $username"
        sudo useradd -m -g "$group" "$username"
    else
        echo "User '$username' already exists."
    fi

    # 3. CREATE WEB DIRECTORY
    WEB_DIR="/home/$username/www"

    if [ ! -d "$WEB_DIR" ]; then
        echo "Creating web directory: $WEB_DIR"
        sudo mkdir -p "$WEB_DIR"
        sudo chown "$username:$group" "$WEB_DIR"
        sudo chmod 755 "$WEB_DIR"
    else
        echo "Web directory already exists."
    fi

    # 4. GENERATE SSH KEYS
    SSH_DIR="/home/$username/.ssh"
    SSH_KEY="$SSH_DIR/id_rsa"

    if [ ! -f "$SSH_KEY" ]; then
        echo "Generating SSH keys for $username"
        sudo -u "$username" mkdir -p "$SSH_DIR"
        sudo -u "$username" ssh-keygen -t rsa -b 2048 -f "$SSH_KEY" -N ""
        sudo chmod 700 "$SSH_DIR"
        sudo chmod 600 "$SSH_KEY"
        sudo chmod 644 "$SSH_KEY.pub"
    else
        echo "SSH keys already exist."
    fi

done < "$INPUT"

echo "----------------------------------------"
echo "SCRIPT COMPLETE"
echo "Users & groups provisioned successfully."
echo
