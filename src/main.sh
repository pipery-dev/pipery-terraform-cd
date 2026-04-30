#!/usr/bin/env bash
set -euo pipefail

# Pipery Terraform CD - Main orchestrator
# Orchestrates: read config → plan → apply → drift check

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
LOG="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "[pipery-terraform-cd] ERROR: project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$LOG")"

# Step: read config
"$SCRIPT_DIR/read-config.sh"

# Step: plan
if [ "${INPUT_SKIP_PLAN:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-plan.sh"
else
  echo "[pipery-terraform-cd] Skipping plan step."
fi

# Step: apply
if [ "${INPUT_SKIP_APPLY:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-apply.sh"
else
  echo "[pipery-terraform-cd] Skipping apply step."
fi

# Step: drift check
if [ "${INPUT_SKIP_DRIFT:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-drift.sh"
else
  echo "[pipery-terraform-cd] Skipping drift check step."
fi

# Final success log entry (always written)
printf '{"event":"deploy","status":"success","target":"terraform","mode":"cd"}\n' >> "${INPUT_LOG_FILE:-pipery.jsonl}"

echo "[pipery-terraform-cd] CD pipeline completed for: ${PROJECT_PATH}"
