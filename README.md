# Pipery Terraform CD

CD pipeline for Terraform: init → plan → apply → state management and drift detection

## Status

- Owner: `pipery-dev`
- Repository: `pipery-terraform-cd`
- Marketplace category: `continuous-integration`
- Current version: `3.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-terraform-cd@v3
        with:
          project_path: .
          config_file: .github/pipery/config.yaml
          terraform_version: latest
          backend_config: 
          var_file: 
          working_directory: .
          plan_only: false
          auto_approve: true
          destroy: false
          check_drift: true
          skip_plan: false
          skip_apply: false
          skip_drift_check: false
          log_file: pipery.jsonl
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the Terraform root module. |
| `config_file` | no | `.github/pipery/config.yaml` | Path to the pipery config file. |
| `terraform_version` | no | `latest` | Terraform CLI version to use. |
| `backend_config` | no | `` | Comma-separated backend config vars (key=val). |
| `var_file` | no | `` | Path to a .tfvars file. |
| `working_directory` | no | `.` | Working directory for Terraform commands. |
| `plan_only` | no | `false` | Only run plan, do not apply. |
| `auto_approve` | no | `true` | Skip interactive approval of plan. |
| `destroy` | no | `false` | Run terraform destroy instead of apply. |
| `check_drift` | no | `true` | Run a post-apply plan to detect drift. |
| `skip_plan` | no | `false` | Skip terraform plan step. |
| `skip_apply` | no | `false` | Skip terraform apply step. |
| `skip_drift_check` | no | `false` | Skip drift detection step. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
