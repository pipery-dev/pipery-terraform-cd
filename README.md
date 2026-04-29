# Pipery Terraform CD

Reusable GitHub Action for Terraform CD with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Terraform%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-terraform-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    uses: pipery-dev/pipery-terraform-cd@v1
    with:
      project_path: .
    secrets: inherit
```

## Pipeline steps

init → plan → apply → drift detection → state management

Every step is logged to `pipery.jsonl` via psh and uploaded as a GitHub Actions artifact.

## Inputs

| Input | Description | Default |
|---|---|---|
| `project_path` | Path to the Terraform root module. | `.` |
| `config_file` | Path to the pipery config file. | `.github/pipery/config.yaml` |
| `terraform_version` | Terraform CLI version to use. | `latest` |
| `backend_config` | Comma-separated backend config vars (key=val). | `` |
| `var_file` | Path to a .tfvars file. | `` |
| `working_directory` | Working directory for Terraform commands. | `.` |
| `plan_only` | Only run plan, do not apply. | `false` |
| `auto_approve` | Skip interactive approval of plan. | `true` |
| `destroy` | Run terraform destroy instead of apply. | `false` |
| `check_drift` | Run a post-apply plan to detect drift. | `true` |
| `skip_plan` | Skip terraform plan step. | `false` |
| `skip_apply` | Skip terraform apply step. | `false` |
| `skip_drift_check` | Skip drift detection step. | `false` |
| `log_file` | Path to write the JSONL log file. | `pipery.jsonl` |

## Observability

Each run produces a `pipery.jsonl` file. Upload it as an artifact and inspect it with the [Pipery Dashboard](https://dash.pipery.dev).

## License

MIT — see [LICENSE](LICENSE).
