# Lab 05 — ArgoCD on EKS: GitOps from your own repo (45 min)

GitOps = Git is the single source of truth. ArgoCD watches THIS repo and makes the
cluster match it. You never `kubectl apply` an app by hand again (in prod discipline).

## Prereq
Cluster up + connected: `kubectl get nodes` shows `t3.medium` Ready.
Git source must be READABLE BY ARGOCD anonymously — i.e. the repo must be
**public** (or register a repo credential in ArgoCD, the production pattern for
private repos). Symptom if you forget: app stuck `Unknown` with
"authentication required: Repository not found" in conditions.

## Tasks
1. [ ] Install ArgoCD with Helm (this server already has helm 3.22).
   Chart name is `argo-cd` (with a dash) — NOT `argocd`:
   ```bash
   helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
   helm install argocd argo/argo-cd -n argocd --create-namespace \
     --set server.service.type=LoadBalancer
   ```
2. [ ] Watch it settle (~1-2 min): `kubectl get pods -n argocd -w`
   Expect: server, repo-server, application-controller, redis, notifications, dex.
3. [ ] Get the public UI URL:
   `kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
   → open in browser (LoadBalancer needs ~1 min to provision the address).
4. [ ] Get the admin password:
   `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d`
   User `admin` + that password.
5. [ ] Apply the Application CRD that points at YOUR repo (already in this repo):
   ```bash
   kubectl apply -f argocd-demo/application.yaml
   kubectl get applications.argoproj.io -n argocd
   ```
   STATUS should flip `Missing→Progressing→Healthy+Synced` on its own.
6. [ ] GitOps proof — change the desired state in Git, not in the cluster:
   Edit `argocd-demo/app.yaml` replicas 2→3, commit, push. Watch ArgoCD self-sync:
   `kubectl get pods -w` — a third pod appears with NO kubectl apply.
   Then `git revert` the change (keep repo canonical).
7. [ ] Drift proof: `kubectl scale deployment gitops-nginx --replicas=5` (out-of-band)
   → ArgoCD flags it `OutOfSync`, auto-heals back to 2 (selfHeal=true).

## Pass criteria
- [ ] argocd pods all Running; UI reachable at the LB hostname
- [ ] Application shows `Healthy` + `Synced` sourced from github.com/mayur-chavhan/cloud-k8s-labs
- [ ] You saw a Git-only change appear in the cluster AND an out-of-band change self-heal

## Interview one-liners
- ArgoCD = pull-based CD (cluster pulls Git) vs CI pipeline push-based `kubectl apply`.
- Sync policy: automated+selfHeal+prune vs manual sync (dev vs prod discipline).
- App-of-apps / ApplicationSets for fleet patterns (next-level).

## Teardown order (before sandbox dies)
```bash
kubectl delete -f argocd-demo/application.yaml    # remove ArgoCD-managed app FIRST
helm uninstall argocd -n argocd                    # removes LB too
aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn'  # confirm empty
cd ../aws && ./04-teardown.sh
```

# Lab-log line
`<date> L5: argocd via helm on eks-lab01; git commit = deploy; drift self-healed`
