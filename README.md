Terraform AWS Deployment Project
📋 Project Overview
A complete Infrastructure as Code (IaC) project that deploys a scalable "Hello World" web application on AWS using modern DevOps practices. This project integrates multiple AWS services and automation tools to create a production-ready infrastructure.

🚀 Features Implemented
✅ Infrastructure as Code (Terraform)
Complete infrastructure defined in Terraform HCL

Modular configuration with variables and outputs

Automated provisioning of AWS resources

✅ Scalable Architecture (AWS Services)
VPC Networking: Custom VPC with public subnets across multiple availability zones

Auto Scaling Group: Automatic scaling from 2 to 5 EC2 instances based on load

Application Load Balancer: Distributes traffic across multiple instances

Security Groups: Configured with least-privilege access rules

✅ Containerization (Docker)
Dockerized "Hello World" application

Automated container deployment on instance launch

Custom Docker image from Docker Hub: erick1109/hello-world-app:v1

✅ Automation & DevOps
User Data Scripts: Automated instance configuration at boot

GitHub Repository: Full version control of infrastructure code

CI/CD Pipeline: GitHub Actions workflow for automated deployments

🏗️ Architecture Diagram
text
┌─────────────────────────────────────────────────────────────┐
│                    User Browser                              │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│             Application Load Balancer (ALB)                  │
│         hello-world-app-alb-xxxxxxxx.elb.amazonaws.com      │
└─────────────┬───────────────────────┬───────────────────────┘
              │                       │
              ▼                       ▼
    ┌─────────────────┐     ┌─────────────────┐
    │  EC2 Instance   │     │  EC2 Instance   │
    │  t2.micro       │     │  t2.micro       │
    │  Docker Running │     │  Docker Running │
    │  Hello World    │     │  Hello World    │
    └─────────────────┘     └─────────────────┘
              │                       │
              └───────────┬───────────┘
                          │
                  ┌───────────────┐
                  │ Auto Scaling  │
                  │ Group (ASG)   │
                  │ Min: 2 Max: 5 │
                  └───────────────┘
📁 Project Structure
text
TerraformHelloWorld/
├── .github/workflows/          # CI/CD Pipeline
│   └── deploy.yml             # GitHub Actions workflow
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Terraform variables
├── outputs.tf                 # Terraform outputs (URLs, IDs)
├── user_data.sh               # Instance initialization script
├── terraform.tfvars.example   # Example configuration file
└── README.md                  # This documentation
🛠️ Technologies Used
Infrastructure: Terraform v1.14+

Cloud Provider: AWS (us-east-1 region)

Compute: EC2 t2.micro instances

Orchestration: Docker

Load Balancing: AWS Application Load Balancer

Auto Scaling: AWS Auto Scaling Groups

CI/CD: GitHub Actions

Version Control: Git

📦 AWS Resources Created
Networking:

1 VPC (10.0.0.0/16)

2 Public Subnets (different availability zones)

Internet Gateway

Route Tables

Compute & Scaling:

Auto Scaling Group (2-5 instances)

Launch Template with Amazon Linux 2 AMI

Application Load Balancer with Target Group

Security:

Security Group for ALB (HTTP port 80)

Security Group for instances (HTTP from ALB, SSH access)

🚀 Deployment Instructions
Prerequisites
AWS Account with IAM credentials

Terraform installed locally

Git installed

AWS CLI configured

Quick Start
bash
# Clone the repository
git clone https://github.com/empulamarin11/TerraformHelloWorld.git
cd TerraformHelloWorld

# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply

# Get application URL
terraform output load_balancer_url
CI/CD Deployment
Push changes to the main branch

GitHub Actions automatically:

Validates Terraform code

Deploys to AWS

Runs health checks

Application available at Load Balancer DNS

🔧 Configuration
Environment Variables
Create terraform.tfvars with:

hcl
aws_region       = "us-east-1"
project_name     = "hello-world-app"
environment      = "dev"
instance_type    = "t2.micro"
docker_image     = "erick1109/hello-world-app:v1"
min_instances    = 2
max_instances    = 5
GitHub Secrets Required
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_SESSION_TOKEN (for temporary credentials)

📊 Outputs
After deployment, Terraform provides:

bash
load_balancer_url = "http://hello-world-app-alb-xxxxxxxx.us-east-1.elb.amazonaws.com"
instance_count = 2
auto_scaling_group_name = "hello-world-app-asg-xxxx"
🧪 Testing
Health Check
bash
# Test application response
curl http://hello-world-app-alb-xxxxxxxx.us-east-1.elb.amazonaws.com

# Check Load Balancer health
# Visit AWS Console → EC2 → Target Groups → hello-world-app-tg
Auto Scaling Test
Increase load on application

Monitor CloudWatch metrics

Auto Scaling Group should launch new instances when CPU > 70%

Scale down when CPU < 30%

🧹 Cleanup
To avoid ongoing costs, destroy all resources:

bash
terraform destroy
🎯 Learning Outcomes
This project demonstrates:

Infrastructure as Code: Complete AWS environment defined in Terraform

Scalability: Auto Scaling Group with Load Balancer

Automation: CI/CD pipeline with GitHub Actions

Containerization: Docker deployment on EC2

High Availability: Multi-AZ deployment with health checks

📝 Project Status
✅ COMPLETED: All core functionality implemented
✅ TESTED: Infrastructure deploys successfully
✅ DOCUMENTED: Complete setup and usage instructions
✅ AUTOMATED: CI/CD pipeline configured

🔗 Links
Application URL: http://hello-world-app-alb-xxxxxxxx.us-east-1.elb.amazonaws.com

GitHub Repository: https://github.com/empulamarin11/TerraformHelloWorld

GitHub Actions: https://github.com/empulamarin11/TerraformHelloWorld/actions

Docker Image: erick1109/hello-world-app:v1

👥 Contributors
Erick Pulamarin - Infrastructure & DevOps implementation

AWS Academy - Cloud resources and learning platform

Terraform Community - Infrastructure as code tools

📄 License
This project is for educational purposes as part of Cloud Computing coursework at Central University of Ecuador.