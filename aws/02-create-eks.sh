#!/usr/bin/env bash
# Create EKS with eksctl (~15-20 min). eksctl auto-creates the needed IAM roles,
# which requires IAM permissions — AWS sandboxes usually allow this; Azure sandboxes don't.
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a

eksctl create cluster \
  --name "$EKS_CLUSTER_NAME" \
  --region "$AWS_DEFAULT_REGION" \
  --nodegroup-name ng-lab \
  --nodes "$EKS_NODE_COUNT" \
  --node-type "$EKS_NODE_SIZE" \
  --managed

eksctl get cluster --region "$AWS_DEFAULT_REGION"
echo "OK EKS cluster created"

# IF THE SANDBOX BLOCKS EKS (IAM denied, or hangs on role creation):
# cheaper, simpler fallback = K3s on a single EC2 spot/on-demand box:
#   aws ec2 run-instances --image-id resolve:ssm-name=/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
#     --instance-type t3.small --key-name <your-key> \
#     --user-data 'yum install -y curl && curl -sfL https://get.k3s.io | sh -'
# CKA-style practice belongs on the Proxmox K3s lab anyway.
