# Secure EC2 Provisioning and Configuration with Terraform, OIDC, SSM, and Ansible

## 📌 Problem Statement

**How do we provision, access, and configure EC2 instances in a secure, repeatable, and auditable way *without* long-lived credentials or SSH access?**

This is a **real enterprise problem**, commonly faced by organisations that need to balance automation speed with strong security controls. Traditional approaches relying on manual configuration, static credentials, and SSH access introduce significant security and operational risks.

This project demonstrates a modern, security-first solution using **Terraform**, **GitHub Actions with OIDC**, **AWS Systems Manager (SSM)**, and **Ansible**.

---

## 🏗️ Architecture Overview

* **Terraform** provisions AWS infrastructure as code
* **GitHub Actions** runs CI/CD pipelines
* **OIDC authentication** provides short-lived AWS credentials to GitHub Actions
* **AWS SSM** replaces SSH for EC2 access and command execution
* **Ansible playbooks** configure EC2 instances via SSM

The result is a fully automated, auditable, and least-privilege workflow aligned with zero-trust principles.

![aws_ansible_ssm](https://github.com/user-attachments/assets/164dc5af-c7a5-40c8-852e-548c7cd8b672)

---

## 🔍 Problem → Solution Breakdown

## 1️⃣ Manual infrastructure is error-prone and inconsistent

#### Pain Points

* Clicking through the AWS Console
* Different environments drift over time
* Hard to reproduce or roll back infrastructure
* No version history or peer review

#### Solution: Terraform (Infrastructure as Code)

* Infrastructure defined declaratively as code
* Version-controlled and peer-reviewed via Git
* Repeatable deployments across environments
* Easy teardown and rebuild

#### What This Prevents

* Configuration drift
* "It works in prod but not in dev"
* Undocumented or ad-hoc changes

**Problem Solved:** Inconsistent, non-auditable infrastructure

---

## 2️⃣ Long-lived AWS credentials in CI/CD are a security risk

#### Pain Points

* AWS access keys stored in GitHub Secrets
* Credentials can leak, be reused, or forgotten
* Manual and error-prone key rotation
* Large blast radius if compromised

#### Solution: GitHub Actions + OIDC

* No static AWS credentials stored anywhere
* Short-lived, per-workflow credentials issued at runtime
* IAM role tightly scoped to the repository and workflow
* All access logged and auditable via CloudTrail

#### What This Prevents

* Credential leakage
* Static secrets in CI/CD pipelines
* Over-permissioned automation roles

**Problem Solved:** Insecure CI/CD authentication

---

## 3️⃣ SSH access to EC2 is risky and hard to manage

#### Pain Points

* Port 22 exposed to the network
* SSH key sprawl across users and systems
* Limited visibility into who accessed servers and why
* Slow and disruptive access revocation

#### Solution: AWS Systems Manager (SSM)

* No inbound ports required on EC2 instances
* IAM-based access control instead of SSH keys
* Centralised logging of sessions and commands
* Immediate access revocation via IAM

#### What This Prevents

* Brute-force SSH attacks
* Lost or leaked SSH keys
* Undocumented server access

**Problem Solved:** Unsafe and unauditable server access

---

## 4️⃣ Manually configuring servers doesn’t scale

#### Pain Points

* Logging into servers to install or update software
* Configuration differs between instances
* Changes are not repeatable
* High risk of human error

#### Solution: Ansible via SSM

* Configuration defined as code using Ansible playbooks
* Same configuration applied consistently across all instances
* No direct server login required
* Fully automated and repeatable configuration process

#### What This Prevents

* Snowflake servers
* Environment inconsistency
* Manual misconfiguration

**Problem Solved:** Non-scalable server configuration

---

## ✅ Key Outcomes

* Secure, keyless CI/CD authentication
* No SSH access or inbound management ports
* Fully automated infrastructure provisioning
* Consistent and repeatable server configuration
* Strong auditability and least-privilege access

---

## 🎯 Why This Matters

This project reflects real-world enterprise patterns used in security-conscious environments such as financial services, government, and large-scale SaaS platforms. It prioritises:

* **Security by design**
* **Automation over manual processes**
* **Auditability and compliance**
* **Scalability and operational resilience**

---

## 🚀 Future Improvements

* Add SSM Session Manager logging to S3/CloudWatch
* Introduce environment separation (dev / staging / prod)
* Integrate security scanning into CI/CD
* Apply tighter IAM permission boundaries
