#!/usr/bin/env bash
# Create AKS in the sandbox RG (recipe verified 2026-11-16).
# KEY FACT: do NOT pass --node-resource-group. The AKS provider creates its
# hidden MC_ group itself; passing the sandbox RG fails (NodeResourceGroupSameAsResourceGroup).
set -euo pipefail
cd "$(dirname "$0")"
[ -f .env ] || { echo "ERROR: no .env. cp env.example .env first."; exit 1; }
set -a; source .env; set +a

command -v az >/dev/null || { echo "Installing Azure CLI..."; curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash >/dev/null; }

echo "Creating cluster $AZ_CLUSTER_NAME in $AZ_RG_NAME ($AZ_LOCATION)..."
az aks create \
  -g "$AZ_RG_NAME" -n "$AZ_CLUSTER_NAME" -l "$AZ_LOCATION" \
  --node-count "$AZ_NODE_COUNT" --node-vm-size "$AZ_NODE_SIZE" \
  --generate-ssh-keys --no-wait -o none

echo -n "Polling"
for i in $(seq 1 40); do
  ST=$(az aks show -g "$AZ_RG_NAME" -n "$AZ_CLUSTER_NAME" --query provisioningState -o tsv 2>/dev/null || echo "")
  if [ "$ST" = "Succeeded" ]; then echo; echo "OK cluster Succeeded (took ~$((i*30))s)"; exit 0; fi
  if [ "$ST" = "Failed" ]; then echo; echo "FAIL provisioning Failed — run: az aks show -g $AZ_RG_NAME -n $AZ_CLUSTER_NAME"; exit 1; fi
  echo -n "."; sleep 30
done
echo; echo "TIMEOUT after 20 min — poll manually: az aks show -g $AZ_RG_NAME -n $AZ_CLUSTER_NAME --query provisioningState -o tsv"
exit 1
