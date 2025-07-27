#!/bin/bash

# Set instance name and zone (update if needed)
INSTANCE_NAME="my-instance"
ZONE="us-central1-a"

# Fetch public IP
PUBLIC_IP=$(gcloud compute instances describe "$INSTANCE_NAME" \
    --zone "$ZONE" \
    --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

# Create inventory.ini file
cat <<EOF > inventory.ini
[servers]
$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF
