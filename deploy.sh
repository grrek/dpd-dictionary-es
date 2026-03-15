#!/usr/bin/env bash
# Deploy DPD Diccionario Pali-Espanol to dhamma-pb.org
# Target: https://dhamma-pb.org/dpd-espanol/
#
# Server: infra-core (via Tailscale)
# Remote path: apps/caddy/site/dev/dpd-espanol/
#
# Usage:
#   ./deploy.sh          # rsync local -> remote
#   ./deploy.sh pull      # ssh pull from GitHub on server
#   ./deploy.sh status    # check what's deployed

set -euo pipefail

REMOTE="infra-core"
REMOTE_PATH="apps/caddy/site/dev/dpd-espanol"
LOCAL_PATH="$(cd "$(dirname "$0")" && pwd)"

case "${1:-sync}" in
  sync|push)
    echo "=> Deploying via rsync: $LOCAL_PATH -> $REMOTE:$REMOTE_PATH/"
    rsync -avzL "$LOCAL_PATH/" "$REMOTE:$REMOTE_PATH/"
    echo "=> Done. Live at https://dhamma-pb.org/dpd-espanol/"
    ;;

  pull)
    echo "=> Deploying via SSH git pull on $REMOTE"
    ssh "$REMOTE" "cd $REMOTE_PATH && git pull"
    echo "=> Done. Live at https://dhamma-pb.org/dpd-espanol/"
    ;;

  status)
    echo "=> Checking deployed files on $REMOTE:"
    ssh "$REMOTE" "ls -lh $REMOTE_PATH/index.html $REMOTE_PATH/js/"
    ;;

  *)
    echo "Usage: $0 [sync|pull|status]"
    echo "  sync   - rsync local files to server (default)"
    echo "  pull   - git pull on server via SSH"
    echo "  status - check deployed files"
    exit 1
    ;;
esac
