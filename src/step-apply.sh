#!/usr/bin/env psh
# Pipery Terraform CD — apply step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Apply"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"
