#!/usr/bin/env psh
# Pipery Terraform CD — plan step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Plan"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"
