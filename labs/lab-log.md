# Lab-log (one line per session — this becomes your interview stories)

Format: `<date> <L#>: what happened in one line [break/fix: what broke & how fixed]`

| Date | Lab | Story |
|---|---|---|
| 2026-11-16 | L0 | aks-lab01 stood up (B2s, 1.36.5); smoke: 2× nginx Running; had to bypass MITM proxy for kubectl |
| 2026-11-18 | L5 | eks-lab01 (t3.medium, k8s 1.34, ~14 min via eksctl) + ArgoCD; app deployed from THIS repo (Synced/Healthy); gotchas: chart `argo-cd` not `argocd`, repo had to go public for anonymous pull, eksctl final watch fails behind MITM proxy (harmless) |
