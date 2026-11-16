# Lab 01 — First pod + self-healing (45 min)

Prereq: cluster up, `kubectl get nodes` shows Ready (or `source ../azure/k.alias && k get nodes`).

## Tasks
1. [ ] Show your node with full details:
   `kubectl get nodes -o wide` — write down VERSION and OS-IMAGE columns
2. [ ] Your first deployment:
   `kubectl create deployment hello --image=nginx:alpine --replicas=2`
3. [ ] Watch it come up live (Ctrl+C to stop):
   `kubectl get pods -w`
4. [ ] The autopsy: pick one pod name, run `kubectl describe pod <name>`. Find and note:
   - `Node:` which VM it landed on
   - `IP:` the pod IP
   - `Events:` the sequence (Pulling → Pulled → Created → Started)
5. [ ] **The main event — self-healing:** `kubectl delete pod <podname>`
   Then `kubectl get pods` again. One is gone and a NEW one exists (different suffix).
   Why? The Deployment notices it has 1/2 and makes a replacement. This loop is the heart of K8s.
6. [ ] Break-fix (don't fear it): `kubectl delete deployment hello` — recreate it.

## Pass criteria
- [ ] `kubectl get replicasets` shows a rs controlling 2 pods
- [ ] After deleting a pod, a new pod replaces it within ~30s

## Explain in one sentence each (interview answers)
- Pod vs Deployment vs ReplicaSet?
- Who "heals" the deleted pod — and where is that logic?

# Lab-log line to write afterwards
`<date> L1: deployed nginx x2, killed a pod, Deployment replaced it (self-heal seen)`
