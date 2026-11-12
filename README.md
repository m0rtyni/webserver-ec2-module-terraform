## How to Create and Manage Environments

The infrastructure consists of:
- 1 VPC
- 2 networks (public and private subnets)
- 2 HTTP EC2 instances
- 3 DB EC2 instances

The project supports two isolated environments: `test` and `production`. Each environment uses a separate Terraform Workspace and remote state file stored in an Amazon S3 bucket.

### GitHub Actions Pipeline

GitHub Actions automates Terraform validation, security checks, planning, and deployment.

The repository uses three workflows:

- **Terraform CI** – runs `terraform fmt`, `terraform init`, and `terraform validate` on pushes and pull requests.
- **Terraform Pipeline** – runs TFLint and Trivy security scans, then generates and uploads a Terraform Plan artifact. Supports selecting `test` or `production`.
- **Terraform Apply** – manually triggered workflow that deploys the selected environment and runs Terratest.

### Creating an Environment

To create or update an environment using GitHub Actions:

1. Push changes to the `main` branch to trigger Terraform CI and Terraform Pipeline, or manually run the Terraform Pipeline and select the required environment.
2. Review the Terraform Plan result and download the generated plan artifact if needed.
3. Open GitHub Actions and manually run the **Terraform Apply** workflow.
4. Select the target environment (`test` or `production`).
5. The workflow initializes Terraform, selects or creates the corresponding Workspace, applies the configuration, and runs Terratest.

Each environment is managed independently and has its own Terraform state.

### Local Environment Management

To manage environments locally, navigate to the repository root and initialize Terraform:

```bash
terraform -chdir=infrastructure init
```

Select an existing Workspace or create it if it does not exist:

```bash
terraform -chdir=infrastructure workspace select test || terraform -chdir=infrastructure workspace new test
```

Replace `test` with `production` to work with the production environment.

Plan and apply the configuration:

```bash
terraform -chdir=infrastructure plan
terraform -chdir=infrastructure apply
```

To remove the selected environment:

```bash
terraform -chdir=infrastructure destroy
```

### AWS Authentication and Remote State

- GitHub Actions authenticates to AWS using OpenID Connect (OIDC) and an IAM role. No long-lived AWS access keys are stored in GitHub.
- Terraform state is stored remotely in an Amazon S3 bucket in the `eu-north-1` region.
- State locking is enabled using S3 lockfiles.
- Terraform Workspaces keep the `test` and `production` state files isolated.