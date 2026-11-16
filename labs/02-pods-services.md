# Lab 02 — Services: stable address for unstable pods (45 min)

Why: pod IPs die with pods. A Service gives a permanent front door.

## Tasks
1. [ ] Re-create the app and its internal door:
   ```bash
   kubectl create deployment hello --image=nginx:alpine --replicas=2
   kubectl expose deployment hello --port=80 --name=hello-svc
   ```
2. [ ] Look behind the curtain:
   ```bash
   kubectl get svc hello-svc        # note ClusterIP
   kubectl get endpoints hello-svc  # the 2 pod IPs it load-balances
   kubectl get svc -n kube-system   # coredns lives here — it makes names resolve
   ```
3. [ ] Talk to it from inside the cluster:
   ```bash
   kubectl run tt --rm -it --image=busybox --restart=Never -- sh
   wget -qO- http://hello-svc.default.svc.cluster.local ; exit
   ```
   The service NAME worked — that's CoreDNS. Pod IP would also work but dies on reschedule.
4. [ ] Scale and watch endpoints change:
   `kubectl scale deployment hello --replicas=5 && kubectl get endpoints hello-svc -w`
   (count changes live — Ctrl+C, then scale back to 2)
5. [ ] Labels — how the Service finds pods (this is THE concept):
   `kubectl get pods --show-labels` — the svc `selector` matched exactly these.

## Pass criteria
- [ ] From the busybox pod, `wget http://hello-svc...` returns nginx HTML
- [ ] Can explain: ClusterIP vs endpoint list vs pod IP

## Break it
- `kubectl label pod <one> app=typo --overwrite` → endpoints drop to 1. Fix: relabel back.

# Lab-log line
`<date> L2: svc + endpoints wired via labels; coredns resolves svc names`
