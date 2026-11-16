#!/usr/bin/env bash
# Delete the cluster (frees sandbox compute). Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a

az aks delete -g "$AZ_RG_NAME" -n "$AZ_CLUSTER_NAME" --yes --no-wait
echo "Deletion started (async). Check later with:"
echo "  az aks show -g $AZ_RG_NAME -n $AZ_CLUSTER_NAME -o tsv --query provisioningState"
echo
echo "=== remaining resources in sandbox RG ==="
az resource list -g "$AZ_RG_NAME" -o table --query '[].{name:name, type:type}'
echo "NOTE: the hidden MC_ node group cannot be listed by your identity — the"
echo "AKS provider tears it down with the cluster. Wait a few min and re-run to confirm."
