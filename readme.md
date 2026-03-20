# ☁️ Local Cloud Orchestration Project

A professional Infrastructure as Code (IaC) project using **Terraform** to simulate a real-world AWS cloud environment locally via **LocalStack**.

## 🎯 Project Overview
This project automates the setup of a core cloud architecture. Instead of manually clicking buttons in a console, I've written code to provision networking, compute, and storage. This ensures the infrastructure is "disposable," repeatable, and version-controlled.

---

## 🏗️ Infrastructure Breakdown

### 🌐 Networking (VPC & Subnets)
The foundation of the project. I created a **Virtual Private Cloud (VPC)** to isolate our resources.
* **Public Subnet:** Where our instances live.
* **Internet Gateway:** Allows our local resources to simulate talking to the web.

### 🖥️ Compute (EC2)
A virtual server (EC2 instance) is provisioned within the VPC.
* **Instance Type:** `t2.micro` (standard for testing).
* **Automated Setup:** Uses the `main.tf` configuration to link with our networking.

### 📦 Storage & Database (S3 & DynamoDB)
* **S3 Bucket:** Created for object storage (like logs or user uploads).
* **DynamoDB:** A NoSQL database table for fast, scalable data management.

---

## 🛠️ Tech Stack & Tools
* **Terraform:** The engine that reads my `.tf` files and builds the infrastructure.
* **LocalStack:** A cloud service emulator that lets me run AWS locally on my machine (no costs!).
* **PowerShell:** Used for managing the Git workflow and Terraform commands.
* **JSON:** Used for handling data inputs in `data.json`.

---

## 🚀 How to Use

### 1. Prerequisites
Ensure you have **LocalStack** running on your machine and **Terraform** installed.

### 2. Initialize the Project
Download the providers and prepare the workspace:
powershell
terraform init

###3. Deploy the Infrastructure
Run the following to build everything at once:

PowerShell
terraform apply -auto-approve

###4. Cleanup
To "tear down" the infrastructure and save resources:

PowerShell
terraform destroy -auto-approve

📁 Project Structure
main.tf: The primary logic for creating AWS resources.

providers.tf: Configures Terraform to talk to LocalStack instead of the real AWS.

variable.tf: Makes the code reusable by defining flexible inputs.

data.json: Stores configuration data for the infrastructure.

.gitignore: Keeps the repository clean by hiding heavy "garbage" files.


---

### How to upload this to GitHub:
Run these commands in your PowerShell:

1. `git add README.md`
2. `git commit -m "docs: add user-friendly professional readme"`
3. `git push`
