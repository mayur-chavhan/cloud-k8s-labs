# Pluralsight Azure sandbox — limits map (verified live 2026-11-16)

Source: https://help.pluralsight.com/hc/en-us/articles/24392988447636-Azure-cloud-sandbox

## CAN create (inside the one sandbox RG)
| Service | Limit |
|---|---|
| AKS | **max 3 clusters × 3 nodes** — "you may see an error you can ignore" (AKS makes its own hidden MC_ group) |
| VMs | max 10 VMs / 10 vCPUs total; allowlist: B1s, B1ms, B2ms, **B2s**, B2s_v2*, D2s_v3/v4/v5-class, F2s, DS-series (check `az vm list-skus`) |
| ACR | max 2 registries, 3 tasks |
| Container Apps | 3 apps, 6 revisions |
| Storage / Key Vault / VNet / App Gateway / Bastion / App Insights / Azure Monitor (1 GiB Log Analytics) / Cosmos ≤1000 RU/s / MySQL / PostgreSQL / Service Bus / Event Grid | allowed |

## CANNOT do
- **Create resource groups** — you and the sandbox SP are locked to `1-<x>-playground-sandbox`
- Azure DevOps (service), Entra ID changes, role assignments, Network Watcher
- Arc-enabled Kubernetes, user-assigned managed identities, HDInsight, Databricks, Redis
- VMs: no GPUs, no Hybrid Use Benefit; sustained CPU is monitored

## Verified AKS recipe facts
- `az aks create -g <sandbox-rg> -n <name> -l eastus --node-count 1 --node-vm-size Standard_B2s --no-wait` → Succeeded in ~9 min
- Hidden node RG: `MC_<sandbox-rg>_<cluster>_eastus` (not listable by sandbox identity — normal)
- k8s version served: 1.36.x (Nov 2026)
- If `az aks create` fails with `NodeResourceGroupSameAsResourceGroup` you passed the sandbox RG as node-RG — omit the flag entirely
