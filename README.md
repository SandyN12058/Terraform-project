# 🚀 AWS Scalable Web App Deployment using Terraform

This project provisions a highly available and scalable infrastructure on AWS using Terraform. It includes:
- An **Application Load Balancer (ALB)** for routing HTTP traffic
- Two **Auto Scaling Groups (ASGs)** for different applications
- Two **Target Groups (TGs)** with path-based routing
- **Launch Templates (LTs)** for EC2 instance configuration

---

## 📁 Project Structure

. ├── **main.tf** (Main Terraform configuration) <br>
. ├── **variables.tf** (Input variables) <br> 
. ├── **outputs.tf** (Outputs) <br>
. ├── **provider.tf** <br>
. ├── **README.md** <br>


---

## 🧰 Prerequisites

- ✅ [Terraform](https://www.terraform.io/downloads)
- ✅ [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- ✅ AWS account with programmatic access (Access Key & Secret Key)
- ✅ EC2 AMI configured with an app running on:
  - Port `8000` for `/app1`
  - Port `8001` for `/app2`

---

## ⚙️ How to Deploy

#### 1. Clone the repository
```bash
git clone https://github.com/SandyN12058/Terraform-project.git
cd terraform-project
```
#### 2. Initialize Terraform
```bash
terraform init
```
#### 3. Preview the execution plan
```bash
terraform plan
```
#### 4. Apply the configuration
```bash
terraform apply
```
#### 5. Destroy the configuration
```bash
terraform destroy
```

---

## 🌐 Application Access
Once deployed, access your application at: <br>

`http://<LoadBalancer-DNS>/app1/`   → App running on port 8000 <br>
`http://<LoadBalancer-DNS>/app2/`   → App running on port 8001 <br>

