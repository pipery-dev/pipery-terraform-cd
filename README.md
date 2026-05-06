# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-terraform-cd/main/assets/icon.png" alt="Pipery Terraform CD" width="28" align="center" /> Pipery Terraform CD

Reusable GitHub Action for Terraform deployment with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Terraform%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-terraform-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-terraform-cd@v1
        with:
          project_path: .
          terraform_version: latest
          auto_approve: true
```

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Plan | Terraform plan | `skip_plan` |
| Apply | Terraform apply | `skip_apply` |
| Drift check | Post-apply plan for drift detection | `skip_drift_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the Terraform root module. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `terraform_version` | `latest` | Terraform CLI version to use. |
| `backend_config` | `` | Comma-separated backend config vars (key=val). |
| `var_file` | `` | Path to a .tfvars file. |
| `working_directory` | `.` | Working directory for Terraform commands. |
| `plan_only` | `false` | Only run plan, do not apply. |
| `auto_approve` | `true` | Skip interactive approval of plan. |
| `destroy` | `false` | Run terraform destroy instead of apply. |
| `check_drift` | `true` | Run post-apply plan to detect drift. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |
| `skip_plan` | `false` | Skip terraform plan step. |
| `skip_apply` | `false` | Skip terraform apply step. |
| `skip_drift_check` | `false` | Skip drift detection step. |

## Usage Examples

### Example 1: Basic Terraform apply with auto-approve

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-terraform-cd@v1
        with:
          project_path: .
          terraform_version: latest
          auto_approve: true
```

### Example 2: With backend configuration

```yaml
- uses: pipery-dev/pipery-terraform-cd@v1
  with:
    project_path: ./infrastructure
    terraform_version: 1.7
    backend_config: bucket=my-bucket,key=prod/terraform.tfstate,region=us-east-1
    auto_approve: true
```

### Example 3: Using variables file

```yaml
- uses: pipery-dev/pipery-terraform-cd@v1
  with:
    project_path: .
    terraform_version: latest
    var_file: terraform.prod.tfvars
    auto_approve: true
```

### Example 4: Plan-only dry run

```yaml
- uses: pipery-dev/pipery-terraform-cd@v1
  with:
    project_path: .
    terraform_version: latest
    plan_only: true
```

### Example 5: Destroy infrastructure

```yaml
- uses: pipery-dev/pipery-terraform-cd@v1
  with:
    project_path: .
    terraform_version: latest
    destroy: true
    auto_approve: true
```

### Example 6: Interactive approval with drift detection

```yaml
- uses: pipery-dev/pipery-terraform-cd@v1
  with:
    project_path: ./terraform/prod
    terraform_version: 1.6
    auto_approve: false
    check_drift: true
    backend_config: bucket=my-state-bucket,key=prod
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-terraform-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `TERRAFORM_VERSION` - Terraform version (default: latest)
- `BACKEND_CONFIG` - Backend configuration (key=val format)
- `VAR_FILE` - Path to .tfvars file
- `AUTO_APPROVE` - Auto-approve without prompt (default: true)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `TERRAFORM_VERSION` - Terraform version (default: latest)
   - `BACKEND_CONFIG` - Backend configuration variables
   - `VAR_FILE` - Path to .tfvars file
   - `AUTO_APPROVE` - Auto-approve (default: true)
3. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → plan → apply → drift_check → logs

### Features

- Plan and apply infrastructure changes
- Drift detection for configuration compliance
- Remote backend state management
- Variables file support
- Interactive and auto-approved modes
- Destroy capability
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
