#!/usr/bin/env bash
# Verifies ComfyUI can start and serve HTTP requests (CPU-only mode).
set -euo pipefail

echo "Installing dependencies..."
pip install -r requirements.txt -q

echo "Running quick CI test..."
python3 main.py --cpu --quick-test-for-ci

echo "Starting server for HTTP check..."
python3 main.py --cpu --port 8188 &
SERVER_PID=$!
sleep 5

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8188/)
kill "$SERVER_PID" 2>/dev/null || true

if [ "$HTTP_CODE" = "200" ]; then
    echo "OK: ComfyUI is running and responding (HTTP $HTTP_CODE)"
    exit 0
else
    echo "FAIL: Unexpected HTTP status $HTTP_CODE"
    exit 1
fi
