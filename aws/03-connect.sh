#!/usr/bin/env bash
# Point kubectl at the EKS cluster and verify.
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a

aws eks update-kubeconfig --region "$AWS_DEFAULT_REGION" --name "$EKS_CLUSTER_NAME"
echo "=== NODES ===";   kubectl get nodes -o wide
echo "=== NAMESPACES ==="; kubectl get ns
echo "OK connected — current context: $(kubectl config current-context)"
