# Automated Multi-Tier Cloud-Native Infrastructure (vProfile)

## Overview

This project focuses on building and automating a production-like cloud infrastructure on AWS using an Everything-as-Code approach.

The system runs a Java-based application stack (Tomcat, RabbitMQ, Memcached, MySQL) on Amazon EKS, with infrastructure provisioned via Terraform and deployments managed through CI/CD pipelines.

---

## Objective

The goal was to design a reliable and repeatable setup that includes:

* Multi-AZ high availability
* Fully automated infrastructure provisioning
* Secure Kubernetes-based deployment
* CI/CD-driven infrastructure lifecycle

---

## Tech Stack

* AWS (EKS, VPC, IAM, S3, Route53)
* Terraform
* Kubernetes (EKS)
* Helm
* GitHub Actions
* OIDC, IRSA
* Docker

---

## Architecture

### Infrastructure (Terraform)

* Built modular Terraform configuration for a custom VPC:

  * public and private subnets
  * NAT Gateway and Internet Gateway
* Provisioned an EKS cluster (v1.31):

  * multi-AZ setup
  * managed node groups
  * separate node pools for system and application workloads

---

### Security

* Configured OIDC federation between GitHub Actions and AWS (no static credentials)
* Implemented IAM Roles for Service Accounts (IRSA) for Kubernetes workloads
* Managed cluster access via EKS Access Entry API
* Followed least privilege principles across all components

---

### Kubernetes and Automation

* Used Helm (via Terraform) to install:

  * AWS Load Balancer Controller
  * Cluster Autoscaler
* Configured node labels and selectors to separate system and application workloads
* Built reusable infrastructure workflows

---

### Cost and Efficiency

* Used AWS Spot Instances to reduce compute costs
* Tuned EKS networking (prefix delegation, max pods) to increase pod density per node
* Improved resource utilization across the cluster

---

## CI/CD (GitHub Actions)

Infrastructure is deployed and updated through GitHub Actions using OIDC authentication.

### What the pipeline does

* Runs on changes in `infrastructure/**`
* Supports both automatic runs and manual apply/destroy
* Executes Terraform workflow:

  * init
  * plan
  * apply / destroy

---

### Example workflow

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./infrastructure

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Configure AWS credentials (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: eu-central-1

      - name: Terraform init
        run: terraform init

      - name: Terraform plan
        run: terraform plan

      - name: Terraform apply
        run: terraform apply -auto-approve
```

---

### Flow

```
Push / Pull Request
        ↓
GitHub Actions
        ↓
OIDC → AWS IAM Role
        ↓
Terraform
        ↓
AWS (EKS, VPC, etc.)
        ↓
Helm → Kubernetes
```

---

## Architecture Diagrams

### VPC structure

<img width="1635" height="1357" src="https://github.com/user-attachments/assets/af142585-31ce-4256-9069-bdd61b965805" />

---

### EKS cluster

<img width="813" height="591" src="https://github.com/user-attachments/assets/33a5123c-52ae-4f88-a4af-d2ad704076e1" />

---

### CI pipeline

<img width="2093" height="978" src="https://github.com/user-attachments/assets/4cbc04da-d100-44a3-a71b-ec4b5d2c9bb7" />

---

### CD pipeline

<img width="1770" height="1441" src="https://github.com/user-attachments/assets/60fb2d30-6b16-451c-8385-d418fca33783" />

---

## Notes

This project was built to practice real-world DevOps workflows:

* infrastructure as code
* Kubernetes operations
* CI/CD automation
* secure cloud access patterns

It reflects how a small production environment could be structured and managed.
