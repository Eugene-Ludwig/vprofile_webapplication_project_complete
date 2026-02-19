Project: Automated Multi-Tier Cloud-Native Infrastructure (vProfile)

Core Objective: Orchestrate a high-availability Java-based microservices stack (Tomcat, RabbitMQ, Memcached, MySQL) on AWS EKS using a "Everything-as-Code" (EaC) approach.
Key Technical Milestones Accomplished:

Infrastructure as Code (IaC): * Developed modular Terraform configurations to provision a custom VPC architecture (Public/Private subnets, NAT Gateways, and IGW).

  ---Automated EKS Cluster (v1.31) deployment using managed node groups with a Dual-Node-Pool strategy (System pool for management, Workload pool for application traffic).

Security & Identity Management: * Implemented OIDC Federation to bridge GitHub Actions and AWS, enabling keyless authentication.

  ---Configured IAM Roles for Service Accounts (IRSA) for Kubernetes controllers to follow the Principle of Least Privilege.
  ---Managed cluster access through the EKS Access Entry API, configuring identity mapping for local administrators (kops_admin) and CI/CD runners.

Cloud-Native Automation & GitOps: * Integrated Helm Provider within Terraform to automatically bootstrap the cluster with essential controllers: AWS Load Balancer Controller and Cluster Autoscaler.

  ---Engineered a GitHub Actions CI/CD Pipeline that performs terraform plan/apply on Pull Requests, ensuring infrastructure changes are validated before merging.

Cost & Performance Optimization: * Architected the cluster using AWS Spot Instances to reduce infrastructure costs by ~70%.

  ---Optimized container density by tuning EKS user data (USE_MAX_PODS=false) to bypass default networking limits.


Tech Stack: AWS (EKS, VPC, IAM, S3), Terraform, Kubernetes, Helm, GitHub Actions, OIDC, Docker.


General VPC structure diagram
<img width="1635" height="1357" alt="Untitled-2026-01-30-1635(1)" src="https://github.com/user-attachments/assets/af142585-31ce-4256-9069-bdd61b965805" />

EKS cluster
<img width="813" height="591" alt="web-app-backend drawio" src="https://github.com/user-attachments/assets/33a5123c-52ae-4f88-a4af-d2ad704076e1" />

CI Pipeline
<img width="2093" height="978" alt="CI Pipeline" src="https://github.com/user-attachments/assets/4cbc04da-d100-44a3-a71b-ec4b5d2c9bb7" />

CD Pipeline
<img width="1770" height="1441" alt="CD Pipeline" src="https://github.com/user-attachments/assets/60fb2d30-6b16-451c-8385-d418fca33783" />
