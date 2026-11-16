# cloud-k8s-labs

Personal AKS + EKS learning lab for **ephemeral Pluralsight sandbox sessions** (3–4 h each).
Everything here is scripted so a *fresh sandbox* can be turned into a working cluster in one command,
and torn down cleanly before the clock runs out.

> ⚠️ Sandboxes die. This repo is the permanent part — re-provision, learn, tear down, log, repeat.

## When Pluralsight gives you a NEW sandbox (Azure)

The only things that change per sandbox: **subscription id**, **resource-group name**, **SP client id**, **SP secret**.
(Grab them from the sandbox details panel; the RG name looks like `1-a60bb264-playground-sandbox`.)

```bash
cd azure
cp env.example .env && nano .env     # paste the 4 sandbox values
./01-login.sh                        # az login via SP
./02-create-aks.sh                   # creates + waits for cluster (~9 min)
./03-connect.sh                      # kubeconfig + kubectl get nodes → Ready
# ... do lab tasks from labs/ ...
./04-teardown.sh                     # before sandbox expires / when done
```

## When Pluralsight gives you a NEW sandbox (AWS)

```bash
cd aws
cp env.example .env && nano .env     # region + cluster name
./01-setup.sh                        # paste temp Access Key/Secret → aws sts whoami; installs eksctl
./02-create-eks.sh                   # EKS via eksctl (~15-20 min). Blocked? see note inside for k3s-on-EC2 fallback
./03-connect.sh                      # kubeconfig + kubectl get nodes
# ... same lab tasks ...
./04-teardown.sh
```

AWS track is written but **not yet live-verified** (no AWS sandbox opened yet). First AWS session = verify.

## Where your cluster knowledge lives

| Path | What it is |
|---|---|
| `graphs/` | Azure sandbox limits map — no resource groups outside, allowlisted VM SKUs, AKS ≤ 3 clusters × 3 nodes |
| `ROADMAP.md` | 6-week curriculum, what to learn in which order |
| `labs/` | One task set per session — pass/fail tasks (45-min design) + notes |
| `labs/lab-log.md` | Lab journal — one line per session (interview war stories come from here) |

## Never commit to this repo

- Sandbox passwords / SP secrets / AWS keys (kept in local `.env`, gitignored)
- Kubeconfig files (gitignored)
- Anything from `~/.az-sp-secret`

## Verified facts baked into scripts (2026-11-16, Azure sandbox `eastus`)

- AKS works despite single-RG identity: **omit `--node-resource-group`**; the AKS provider creates its hidden `MC_` group itself (`NodeResourceGroupSameAsResourceGroup` if you pass the sandbox RG).
- `Standard_B2s` is on the sandbox VM allowlist. Use regional-availability AND allowlist.
- SP cannot create resource groups (`AuthorizationFailed`) — expected; don't fight it.
- Interactive portal user has the same limits as the SP.
- After cluster creation, `MC_<rg>_<cluster>_<region>` is NOT listable by your identity — by design.
