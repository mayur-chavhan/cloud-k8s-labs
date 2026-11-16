#!/usr/bin/env bash
# Delete EKS cluster via eksctl (removes its CloudFormation stack + nodegroup).
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a

eksctl delete cluster --name "$EKS_CLUSTER_NAME" --region "$AWS_DEFAULT_REGION" --wait
echo "=== leftover check (EC2 should be empty) ==="
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].InstanceId' --output text
echo "NOTE: sandbox bills you for every running EC2 — empty list above = safe."
