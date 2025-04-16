# Terraform Project: Automating VPC and EC2 to Serve a Web Page

## 💪 Goal
Fully automate the following using Terraform:

- Create a VPC
- Set up a Subnet
- Attach an Internet Gateway
- Configure a Route Table
- Open port 80 via Security Group
- Launch an EC2 instance with Nginx
- Show a custom "Welcome" page when accessed via browser

---

## 📊 Project Structure

```
terraform-vpc-ec2-webpage/
├── main.tf
├── variables.tf
├── outputs.tf
├── user_data.sh
└── README.md
```

---

## 🔧 Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/your-username/terraform-vpc-ec2-webpage.git
cd terraform-vpc-ec2-webpage
```

### 2. Edit `terraform.tfvars` (optional)
Create this file to define your own values for the variables:
```hcl
aws_region     = "us-east-1"
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"
vpc_cidr       = "10.0.0.0/16"
subnet_cidr    = "10.0.1.0/24"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Apply Configuration
```bash
terraform apply -auto-approve
```

---

## 🚀 What Happens Behind the Scenes?
1. Terraform authenticates using your AWS keys
2. It creates a VPC + subnet
3. Attaches an internet gateway
4. Configures routing for internet traffic
5. Creates a security group to allow HTTP
6. Launches an EC2 instance
7. Runs a startup script to:
   - Install Nginx
   - Replace the default index.html with your **Welcome Page**

---

## 🌐 Access the Web Page

- After `terraform apply`, find the public IP in the Terraform output
- Paste the IP into your browser
- You should see:

```
Welcome Page
You successfully automated VPC and EC2 using Terraform!
```

---

## 🚫 Destroy Everything
When you're done:
```bash
terraform destroy -auto-approve
```

---

## ✨ Credit
Made with love by Sajid . Let's automate the world!

---

## ✈️ Next Level
Want to go further?
- Add an S3 bucket for static assets
- Automate Route 53 DNS
- Add SSL using ACM + ALB
- Learn CI/CD with Terraform + GitHub Actions

---

> "Infrastructure as Code means Confidence as a Coder."
> — Sajid
