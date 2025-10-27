#!/usr/bin/env bash
set -Eeuo pipefail

PORT="${PORT:-8080}"
APP_PATH="${APP_PATH:-app:app}"

exec uv run uvicorn "${APP_PATH}" \
  --host 0.0.0.0 \
  --port "${PORT}" \
  --proxy-headers \
  --forwarded-allow-ips="*" \
  --access-log \
  --log-level info \
  --timeout-keep-alive 5
