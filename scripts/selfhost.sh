#!/usr/bin/env bash

set -euo pipefail

BASE="$HOME/selfhost"

usage() {
  echo "Usage: $0 {start|stop|restart|status|logs|update}"
}

run_for_all() {
  local action="$1"
  local found=0

  shopt -s nullglob

  for dir in "$BASE"/*/; do
    local service
    service="$(basename "$dir")"

    # Only run in folders that contain a compose file
    if [[ ! -f "$dir/docker-compose.yml" && \
          ! -f "$dir/docker-compose.yaml" && \
          ! -f "$dir/compose.yml" && \
          ! -f "$dir/compose.yaml" ]]; then
      echo "==> $service skipped: no compose file"
      continue
    fi

    found=1
    echo "==> $service"

    cd "$dir"

    case "$action" in
      start)
        docker compose up -d
        ;;
      stop)
        docker compose down
        ;;
      restart)
        docker compose down
        docker compose up -d
        ;;
      status)
        docker compose ps
        ;;
      logs)
        docker compose logs --tail=80
        ;;
      update)
        docker compose pull
        docker compose up -d
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  done

  if [[ "$found" -eq 0 ]]; then
    echo "No Docker Compose services found in $BASE"
    exit 1
  fi
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  start|stop|restart|status|logs|update)
    run_for_all "$1"
    ;;
  *)
    usage
    exit 1
    ;;
esac
