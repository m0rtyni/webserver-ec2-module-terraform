# Self-Hosted GitHub Actions Runner Setup

## 1. Prerequisites

Before installing the runner, prepare:

- An Ubuntu 24.04 EC2 instance.
- Outbound internet access (HTTPS, TCP port 443).
- A dedicated Linux user for running GitHub Actions.
- Git, Terraform and Docker installed if required by the workflows.
- An IAM instance profile with SSM permissions for remote administration.

## 2. Runner Installation

1. Open the GitHub repository.
2. Navigate to **Settings → Actions → Runners**.
3. Click **New self-hosted runner**.
4. Select **Linux** and the appropriate architecture.
5. Follow GitHub's instructions to download and extract the runner package.

Configure the runner using the repository URL and temporary registration token provided by GitHub:

```bash
./config.sh --url https://github.com/OWNER/REPOSITORY --token REGISTRATION_TOKEN
```

Install and start the runner as a service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

Verify that the service is running:

```bash
sudo ./svc.sh status
```

Once configured, the runner should appear as **Online** in the repository's Actions Runners settings.

## 3. Runner Management

Useful service commands:

```bash
sudo ./svc.sh status
sudo ./svc.sh stop
sudo ./svc.sh start
sudo ./svc.sh uninstall
```

To remove the runner from GitHub, generate a removal token under **Settings → Actions → Runners**, then execute:

```bash
./config.sh remove --token REMOVAL_TOKEN
```

## 4. Troubleshooting

| Issue | Possible solution |
|---|---|
| Runner is offline | Check EC2 status, network connectivity and runner service. |
| Docker command not found | Install Docker and verify that the service is running. |
| Docker permission denied | Add the runner user to the Docker group and restart its session. |
| AWS authentication failed | Verify the IAM role, OIDC trust policy and permissions. |
| Terraform not found | Check the Terraform installation and PATH. |
| Terratest fails due to memory | Check available RAM and configure sufficient memory or swap. |
| Runner cannot connect to GitHub | Verify outbound HTTPS connectivity and DNS resolution. |

For additional diagnostics, check GitHub Actions job logs and runner service logs:

```bash
sudo journalctl -u actions.runner.* -f
```

## 5. Security Recommendations

- Run the runner under a dedicated non-root user.
- Use temporary registration and removal tokens.
- Prefer AWS Systems Manager Session Manager over public SSH access.
- Use IAM roles and GitHub OIDC instead of long-lived AWS credentials.
- Restrict access to self-hosted runners and avoid executing untrusted workflows.