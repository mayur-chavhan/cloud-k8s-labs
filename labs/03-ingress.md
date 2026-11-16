# Lab 03 — Ingress: one public URL (45 min, Azure-verified)

Why: ClusterIP is internal-only. Ingress = L7 router → your app on a real URL.

## Tasks
1. [ ] Check what's already installed:
   `kubectl get pods -n kube-system | grep -iE 'ingress|web-app-routing'`
   Modern AKS ships **Web App Routing** (nginx-based) as an add-on. If present, skip installs.
2. [ ] If not present, enable it (takes ~2 min):
   `az aks update -g <rg> -n <cluster> --enable-azure-web-app-routing`
   (victims of the single-RG identity: this is a cluster-config change, allowed)
3. [ ] Create the app + Ingress manifest (`hello-ingress.yaml`):
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata: { name: hello }
   spec:
     replicas: 2
     selector: { matchLabels: { app: hello } }
     template:
       metadata: { labels: { app: hello } }
       spec:
         containers:
         - name: ngx
           image: nginx:alpine
   ---
   apiVersion: v1
   kind: Service
   metadata: { name: hello-svc }
   spec:
     selector: { app: hello }
     ports: [{ port: 80, targetPort: 80 }]
   ---
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata: { name: hello-ing }
   spec:
     ingressClassName: webapprouting.kubernetes.azure.com
     rules:
     - http:
         paths:
         - path: /
           pathType: Prefix
           backend: { service: { name: hello-svc, port: { number: 80 } } }
   ```
4. [ ] `kubectl apply -f hello-ingress.yaml && kubectl get ingress hello-ing`
   Copy the public ADDRESS → open in a browser → nginx welcome page.
5. [ ] Delete + re-apply to prove you can rebuild it from scratch.

## Pass criteria
- [ ] Public URL from `kubectl get ingress` serves nginx from the internet

## Interview one-liners
- Service vs Ingress? — L4 stable IP vs L7 host/path routing + TLS termination at the edge.

# Lab-log line
`<date> L3: ingress exposes svc publicly; class webapprouting`
