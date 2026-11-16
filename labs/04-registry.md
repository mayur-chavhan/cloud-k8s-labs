# Lab 04 — Registry → deploy your own image (ACR on Azure, ECR on AWS)

Choose your cloud section. Time ≈ 45 min (docker already running on your machine).

## AZURE (ACR)
1. [ ] Create registry (sandbox allows 2):
   `az acr create -g <rg> -n mayurlab$RANDOM --sku Basic --admin-enabled false`
2. [ ] Build + push a tiny image:
   ```bash
   ACR=$(az acr list -g <rg> --query '[0].name' -o tsv)
   docker build -t $ACR.azurecr.io/hello:v1 .      # any Dockerfile; nginx-mimic: FROM nginx:alpine
   az acr login --name $ACR && docker push $ACR.azurecr.io/hello:v1
   ```
3. [ ] Attach AKS to ACR (runs via cluster's identity — sandbox-friendly):
   `az aks update -g <rg> -n <cluster> --attach-acr $ACR`
4. [ ] Deploy from your private image:
   `kubectl create deployment myhello --image=$ACR.azurecr.io/hello:v1`
5. [ ] Pass: `kubectl get pods` shows myhello Running (no ImagePullBackOff).

## AWS (ECR)
1. [ ] Create repo:
   `aws ecr create-repository --repository-name hello`
2. [ ] Build + push:
   ```bash
   ACC=$(aws sts get-caller-identity --query Account --output text)
   aws ecr get-login-password | docker login --username AWS --password-stdin $ACC.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
   docker tag hello:v1 $ACC.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/hello:v1
   docker push $ACC.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/hello:v1
   ```
3. [ ] Deploy → same pass criterion.

## Interview one-liners
- Why attach-ACR works without secrets: AKS's managed identity gets `AcrPull` role on the registry.
- ImagePullBackOff checklist: name? tag? auth? (getAKS/ECR token provider reason via `kubectl describe pod`)

# Lab-log line
`<date> L4: private registry round-trip done on <ACR/ECR> — pods pulled from private reg`
