#!/usr/bin/env bash
# Fetch kubeconfig, install kubectl if missing, prove connectivity.
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a
KCTL="$HOME/.azure/bin/kubectl"

[ -x "$KCTL" ] || az aks install-cli --install-location "$KCTL" --client-version latest >/dev/null 2>&1

az aks get-credentials -g "$AZ_RG_NAME" -n "$AZ_CLUSTER_NAME" \
  --file "$HOME/aks-${AZ_CLUSTER_NAME}-kubeconfig" -o none

# Kubernetes API only understands the cluster's own CA — bypass any local
# TLS-intercepting proxy (kubectl ignores SSL_CERT_FILE). Harmless elsewhere.
K="env HTTP_PROXY= HTTPS_PROXY= http_proxy= https_proxy= $KCTL"

echo "=== NODES ===";    $K get nodes -o wide
echo "=== NAMESPACES ==="; $K get ns
echo
echo "Connect done. Shell helper:  source k.alias   then run:  k get nodes"
grep -q "cluster.server" "$HOME/aks-${AZ_CLUSTER_NAME}-kubeconfig" \
  && echo "OK kubeconfig written to ~/aks-${AZ_CLUSTER_NAME}-kubeconfig"
