#!/usr/bin/env bash
# Configure the temp AWS sandbox credentials + install eksctl/kubectl>.
# Pluralsight AWS sandboxes hand you an IAM user with access keys — paste when asked.
set -euo pipefail
cd "$(dirname "$0")"
[ -f .env ] || { echo "ERROR: no .env — cp env.example .env first."; exit 1; }
set -a; source .env; set +a

mkdir -p "$HOME/.aws"
read -rp "Paste sandbox AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
read -rsp "Paste sandbox AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY; echo

cat > "$HOME/.aws/credentials" <<EOF
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF
chmod 600 "$HOME/.aws/credentials"

echo "=== identity check ==="
aws sts get-caller-identity
echo "VERIFY: Account should be the sandbox account id (NOT your personal one)."

command -v eksctl >/dev/null || {
  echo "Installing eksctl..."
  curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
    | tar xz -C "$HOME/.local/bin"
}
command -v kubectl >/dev/null || {
  echo "Installing kubectl..."
  curl -sL "https://dl.k8s.io/release/stable.txt" | head -c1 >/dev/null
  curl -sLO "https://dl.k8s.io/release/stable/bin/linux/amd64/kubectl" \
    && mkdir -p "$HOME/.local/bin" && mv kubectl "$HOME/.local/bin/"
}
eksctl version && kubectl version --client
echo "OK setup complete"
