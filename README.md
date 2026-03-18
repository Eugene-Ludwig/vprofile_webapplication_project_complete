# 🚀 Automated Multi-Tier Cloud-Native Infrastructure (vProfile)

## 📌 Overview

This project demonstrates an end-to-end **Everything-as-Code (EaC)** approach to designing, provisioning, and automating a highly available microservices infrastructure on AWS.

The platform orchestrates a Java-based application stack (**Tomcat, RabbitMQ, Memcached, MySQL**) on **Amazon EKS**, leveraging Infrastructure-as-Code, Kubernetes, and CI/CD automation.

---

## 🎯 Objective

Design and implement a **production-like cloud-native environment** with:

* High availability across multiple availability zones
* Fully automated infrastructure provisioning
* Secure and scalable Kubernetes deployment
* CI/CD-driven infrastructure lifecycle

---

## 🧰 Tech Stack

* **Cloud:** AWS (EKS, VPC, IAM, S3, Route53)
* **Infrastructure as Code:** Terraform
* **Container Orchestration:** Kubernetes (EKS)
* **Package Management:** Helm
* **CI/CD:** GitHub Actions
* **Security:** OIDC Federation, IRSA
* **Containers:** Docker

---

## 🏗️ Architecture Highlights

### 🔹 Infrastructure as Code (IaC)

* Designed modular Terraform configurations for a custom VPC:

  * Public & Private subnets
  * NAT Gateways & Internet Gateway
* Provisioned **EKS (v1.33)** cluster with:

  * Multi-AZ setup
  * Managed node groups
  * Dual-node-pool architecture:

    * **System pool** (cluster services)
    * **Workload pool** (application traffic)

---

### 🔐 Security & Identity

* Implemented **OIDC Federation** between GitHub Actions and AWS (no static credentials)
* Configured **IAM Roles for Service Accounts (IRSA)** for secure pod-level access
* Managed cluster access via **EKS Access Entry API**
* Applied **Principle of Least Privilege** across all components

---

### ⚙️ Cloud-Native Automation

* Integrated **Helm with Terraform** to bootstrap cluster add-ons:

  * AWS Load Balancer Controller
  * Cluster Autoscaler
* Configured node labeling & selectors for workload separation
* Built reusable Infrastructure-as-Code workflows

---

### 💰 Cost & Performance Optimization

* Leveraged **AWS Spot Instances** (~70% cost reduction)
* Optimized pod density using custom EKS networking settings
* Designed scalable and efficient resource allocation strategy

---

## 🚀 CI/CD Pipeline (GitHub Actions)

Infrastructure provisioning and updates are fully automated using **GitHub Actions** with secure **OIDC-based authentication**.

### 🔧 Pipeline Features

* Triggered on changes in `infrastructure/**`
* Supports both **automatic** and **manual (apply/destroy)** execution
* Executes full Terraform lifecycle:

  * `init → fmt → plan → apply/destroy`
* Uses **OIDC federation** (no AWS keys stored in GitHub)

---

### ⚙️ Key Pipeline Logic

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./infrastructure

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Configure AWS Credentials (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: eu-central-1

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

---

### 🧠 CI/CD Architecture Flow

```
Developer Push / PR
        ↓
GitHub Actions (CI/CD)
        ↓
OIDC Authentication → AWS IAM Role
        ↓
Terraform (IaC)
        ↓
AWS Infrastructure (EKS, VPC, etc.)
        ↓
Helm → Kubernetes Add-ons & Workloads
```

---

### 🔐 Security Approach

* Keyless authentication using **OIDC federation**
* Fine-grained access via **IRSA roles**
* No long-lived credentials stored in CI/CD

---

## 📊 Architecture Diagrams

### 🌐 General VPC Structure

<img width="1635" height="1357" src="https://github.com/user-attachments/assets/af142585-31ce-4256-9069-bdd61b965805" />

---

### ☸️ EKS Cluster Architecture

<img width="813" height="591" src="https://github.com/user-attachments/assets/33a5123c-52ae-4f88-a4af-d2ad704076e1" />

---

### 🔄 CI Pipeline

<img width="2093" height="978" src="https://github.com/user-attachments/assets/4cbc04da-d100-44a3-a71b-ec4b5d2c9bb7" />

---

### 🚀 CD Pipeline

<img width="1770" height="1441" src="https://github.com/user-attachments/assets/60fb2d30-6b16-451c-8385-d418fca33783" />

---

## 📈 Key Takeaways

* Built a **fully automated cloud-native platform** using modern DevOps practices
* Implemented secure, scalable, and production-like infrastructure
* Demonstrated hands-on experience with **AWS, Kubernetes, Terraform, and CI/CD**

---
