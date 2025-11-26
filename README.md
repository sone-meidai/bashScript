# Bash Scripts Collection

A collection of utility bash scripts for security scanning, SSH tunneling, and DefectDojo management.

## 📋 Table of Contents

- [Scripts Overview](#scripts-overview)
- [Security Scanning](#security-scanning)
- [SSH Tunnels](#ssh-tunnels)
- [DefectDojo Management](#defectdojo-management)
- [Prerequisites](#prerequisites)
- [Installation](#installation)

---

## 🛠️ Scripts Overview

| Script | Description |
|--------|-------------|
| `scan_security.sh` | Comprehensive security scanning tool (SCA, SAST, Secrets) |
| `start_tunnels.sh` | Start SSH tunnels to remote Elasticsearch/MongoDB servers |
| `stop_tunnels.sh` | Stop active SSH tunnels |
| `installDefectdojo.sh` | Install and configure DefectDojo |
| `checkDependencies.sh` | Check system dependencies |
| `checkBlockByCf.sh` | Check Cloudflare blocking |
| `checkBotGG.sh` | Bot checking utility |
| `pullAll.sh` | Pull all Git repositories |

---

## 🔒 Security Scanning

### `scan_security.sh`

A comprehensive security scanning tool that runs multiple security scans in parallel.

#### Features

- **SCA (Software Composition Analysis)** - Trivy vulnerability scanning
- **SAST (Static Application Security Testing)** - Semgrep code analysis
- **Secret Detection** - TruffleHog secret scanning
- **Pattern Matching** - Grep-based password/key detection
- **Git History Scanning** - Check git logs for leaked secrets

#### Usage

```bash
# Run all scans
./scan_security.sh <report_output_dir> <scan_target_dir>

# Run specific scan only
./scan_security.sh <report_output_dir> <scan_target_dir> <scan_number>
```

#### Scan Numbers

| Number | Scan Type | Tool | Output Format |
|--------|-----------|------|---------------|
| `1` | SCA | Trivy | SARIF |
| `2` | SAST | Semgrep | SARIF |
| `3` | Secrets | TruffleHog | JSON |
| `4` | Grep .env files | grep | TXT |
| `5` | Grep git log | grep | TXT |
| `6` | Grep password patterns | grep | TXT |
| `7` | Grep key patterns | grep | TXT |
| `ALL` | All scans (default) | - | Multiple |

#### Examples

```bash
# Scan entire project with all tools
./scan_security.sh /var/reports /home/user/my-project

# Run only Trivy vulnerability scan
./scan_security.sh /var/reports /home/user/my-project 1

# Run only Semgrep code analysis
./scan_security.sh /var/reports /home/user/my-project 2

# Run only secret detection with TruffleHog
./scan_security.sh /var/reports /home/user/my-project 3
```

#### Output Files

Reports are saved to: `<report_output_dir>/<project_name>/`

```
1.sca-report-<project_name>.sarif      # Trivy vulnerability scan
2.semgrep-report-<project_name>.sarif  # Semgrep SAST scan
3.trufflehog-<project_name>.json       # TruffleHog secret detection
4.grep-env-<project_name>.txt          # .env file patterns
5.grep-gitlog-<project_name>.txt       # Git history secrets
6.grep-password-<project_name>.txt     # Password patterns
7.grep-key-<project_name>.txt          # Key/token patterns
```

#### Requirements

- Docker installed and running
- Read access to scan target directory
- Write access to report output directory
- Lock files: `yarn.lock`, `package-lock.json`, or `gradle.lockfile`

#### Docker Images Used

- `sqasupport/trivy:latest`
- `sqasupport/semgrep:latest`
- `sqasupport/trufflehog:latest`

---

## 🔐 SSH Tunnels

### `start_tunnels.sh`

Start SSH tunnels to access remote Elasticsearch and MongoDB servers through SSH gateways.

#### Available Tunnels

| Name | Local Port | Remote Service | SSH Gateway |
|------|------------|----------------|-------------|
| UK88 | 9200 | Elasticsearch | 18.166.91.208:22000 |
| XO88 | 9201 | Elasticsearch | 18.162.73.251:22000 |
| DA88 | 9202 | Elasticsearch | 18.163.17.205:22000 |
| ONE88 | 9203 | Elasticsearch | 18.166.108.212:22000 |
| LUCKY88 | 9204 | Elasticsearch | 18.163.160.30:22000 |
| THAI | 9205 | Elasticsearch | 43.198.213.72:22000 |
| 11BET | 9206 | Elasticsearch | 18.163.171.126:22000 |
| TA88 | 9207 | Elasticsearch | 18.167.74.16:22000 |
| VODKA | 9208 | Elasticsearch | 18.163.19.62:22000 |
| NET88 | 9209 | Elasticsearch | 16.163.60.169:22000 |
| CMS | 27018 | MongoDB | 18.166.175.126:22000 |

#### Usage

```bash
# Start all tunnels
./start_tunnels.sh

# Start specific tunnel
./start_tunnels.sh <TUNNEL_NAME>
```

#### Examples

```bash
# Start all tunnels
./start_tunnels.sh

# Start only UK88 tunnel
./start_tunnels.sh UK88

# Start only CMS MongoDB tunnel
./start_tunnels.sh CMS
```

#### Direct SSH Access

```bash
# UK88
ssh -p 22000 msservice@18.166.91.208 -i ~/.ssh/Daluzz9

# XO88
ssh -p 22000 msservice@18.162.73.251 -i ~/.ssh/Daluzz9

# CMS
ssh -p 22000 daluzz@18.166.175.126 -i ~/.ssh/Daluzz9
```

#### Connect to Services

```bash
# Connect to Elasticsearch (after tunnel is established)
curl http://localhost:9200/_cluster/health

# Connect to MongoDB (after CMS tunnel is established)
mongosh mongodb://localhost:27018
```

### `stop_tunnels.sh`

Stop active SSH tunnels.

```bash
./stop_tunnels.sh
```

#### Requirements

- `autossh` installed
- SSH private key at `~/.ssh/Daluzz9`
- Private key permissions: `chmod 600 ~/.ssh/Daluzz9`
- Network access to SSH gateways

---

## 🛡️ DefectDojo Management

### `installDefectdojo.sh`

Install and configure DefectDojo vulnerability management platform.

```bash
./installDefectdojo.sh
```

The DefectDojo installation is located in the `django-DefectDojo/` directory.

---

## 📦 Prerequisites

### System Requirements

- **OS**: Linux or macOS
- **Shell**: bash or zsh
- **Docker**: Version 20.10+
- **Git**: For repository management

### Tools Installation

#### Docker
```bash
# macOS
brew install docker

# Linux (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

#### autossh
```bash
# macOS
brew install autossh

# Linux (Ubuntu/Debian)
sudo apt-get install autossh
```

#### MongoDB Shell (for CMS tunnel)
```bash
# macOS
brew install mongosh

# Linux
# See: https://www.mongodb.com/docs/mongodb-shell/install/
```

---

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd bashScript
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

3. **Setup SSH key (for tunnels):**
   ```bash
   # Place your SSH key
   cp /path/to/your/key ~/.ssh/Daluzz9
   chmod 600 ~/.ssh/Daluzz9
   ```

4. **Pull required Docker images:**
   ```bash
   docker pull sqasupport/trivy:latest
   docker pull sqasupport/semgrep:latest
   docker pull sqasupport/trufflehog:latest
   ```

---

## 📝 License

See individual script headers for licensing information.

## 🤝 Contributing

Feel free to submit issues and enhancement requests.

## ⚠️ Security Notes

- Keep SSH private keys secure and never commit them to version control
- Review scan reports carefully before sharing
- Ensure proper access controls on report directories
- Use network isolation (`--network=none`) for Docker containers when possible

---

## 📞 Support

For issues or questions, please open an issue in the repository.
