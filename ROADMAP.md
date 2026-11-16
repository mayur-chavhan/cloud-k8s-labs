# AKS + EKS learning roadmap (sandbox-sized, 45-min sessions)

Design rules (adapted from homelab k8s lab): 1 lab = 1 sandbox session ≈ 45 min,
every task has pass/fail, deliberately break things, log everything in `labs/lab-log.md`.

## Phase 1 — Foundations (both clouds share this)
- [ ] L1  First pod, deployments, self-healing (`labs/01-first-pod.md`)
- [ ] L2  Services, labels, scaling (`labs/02-pods-services.md`)
- [ ] L3  Ingress → public URL (`labs/03-ingress.md`, Azure live-verified)

## Phase 2 — Real-world glue
- [ ] L4  Registry: ACR push→pull→deploy (Azure) / ECR (AWS)
- [ ] L5  Config: ConfigMaps, Secrets, env, probes
- [ ] L6  Storage: Azure Disk PVC (pod with DB survives delete)

## Phase 3 — Ops layer (interview territory)
- [ ] L7  Namespaces, quotas, RBAC basics
- [ ] L8  Monitoring: `kubectl top`, Azure Monitor / CloudWatch logs
- [ ] L9  Upgrade a nodepool; drain/cordon
- [ ] L10 Break-fix day: kill things on purpose, repair, log the war story

## Phase 4 — AWS track (after L3)
- [ ] A1  EKS via eksctl up/down (verify scripts)
- [ ] A2  ECR + deploy to EKS
- [ ] A3  ALB ingress (AWS Load Balancer Controller) vs Azure app-routing add-on

## CKA note
Sandbox AKS/EKS teach *managed* workflows. CKA practice stays on your Proxmox K3s lab.

## Session ritual (every time)
1. New sandbox → run bootstrap scripts (top of README)
2. Run lab tasks, tick boxes, paste odd outputs into lab-log
3. Teardown + `az resource list` empty-check BEFORE the clock dies
