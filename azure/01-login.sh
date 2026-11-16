#!/usr/bin/env bash
# Log in to the (new) Pluralsight Azure sandbox with the sandbox service principal.
set -euo pipefail
cd "$(dirname "$0")"
[ -f .env ] || { echo "ERROR: no .env here. Run: cp env.example .env  and paste sandbox values."; exit 1; }
set -a; source .env; set +a

umask 077
printf '%s' "$AZ_SP_SECRET" > .az-sp-secret-tmp     # secret never touches argv/history
az login --service-principal -u "$AZ_SP_CLIENT_ID" \
  -p @.az-sp-secret-tmp --tenant "$AZ_TENANT" >/dev/null
rm -f .az-sp-secret-tmp

az account set --subscription "$AZ_SUBSCRIPTION_ID"
az account show -o table --query '{name:name, state:state}'
echo "VERIFY: subscription name should be the Pluralsight one, state Enabled."
[[ $(az account show --query id -o tsv) == "$AZ_SUBSCRIPTION_ID" ]] \
  && echo "OK login+subscription" || echo "FAIL subscription mismatch"
