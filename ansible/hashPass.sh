#!/bin/bash
# Input: plaintext-users.csv
# Format: username,plaintext_password

input="users.csv"
output="hashed-users.csv"

> "$output"

while IFS=',' read -r user pass; do
  hashed=$(mkpasswd --method=SHA-512 "$pass")
  echo "$user,$hashed" >> "$output"
done < "$input"

