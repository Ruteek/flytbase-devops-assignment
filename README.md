 Project Overview
This project deploys Nginx and WebSocket applications on AWS EKS using Kubernetes.

Nginx serves static files and acts as a reverse proxy.
WebSocket Service enables real-time communication.
Jenkins CI/CD automates the deployment process.
AWS EKS + LoadBalancer ensures scalability.
📌 Tech Stack
AWS EKS (Elastic Kubernetes Service)
Kubernetes (kubectl, eksctl)
Jenkins (CI/CD Automation)
Docker (Containerization)
WebSockets (ws:// Communication)
Nginx (Web Server & Reverse Proxy)
GitHub (Version Control)
🚀 Deployment Instructions
1️⃣ Setup AWS & Kubernetes
Install AWS CLI, Kubectl, and Eksctl
sh
Copy
Edit
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install eksctl
curl -sSLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf eksctl_Linux_amd64.tar.gz
sudo mv eksctl /usr/local/bin/
2️⃣ Deploy Nginx & WebSocket Services on EKS
Apply Kubernetes Manifests
sh
Copy
Edit
kubectl apply -f kubernetes/deployments/nginx-deployment.yaml
kubectl apply -f kubernetes/services/nginx-service.yaml
kubectl apply -f kubernetes/deployments/websocket-deployment.yaml
kubectl apply -f kubernetes/services/websocket-service.yaml
Verify Deployment
sh
Copy
Edit
kubectl get pods -A
kubectl get services -A
3️⃣ Setup CI/CD Pipeline in Jenkins
1. Install Required Jenkins Plugins
1️⃣ Go to Manage Jenkins → Manage Plugins
2️⃣ Install:

Pipeline Plugin
Git Plugin
AWS Credentials Plugin
Kubernetes CLI Plugin
2. Add AWS Credentials in Jenkins
1️⃣ Go to Manage Jenkins → Manage Credentials
2️⃣ Add new AWS Credentials:

ID: aws-eks
Access Key ID & Secret Access Key
3. Add GitHub Token for Private Repositories
1️⃣ Create a Personal Access Token (PAT) in GitHub with:

repo (Full control of private repos)
2️⃣ Add Token to Jenkins:
Kind: Username & Password
Username: Your GitHub username
Password: Your GitHub token
ID: github-token
4. Create a Jenkins Pipeline
Go to Jenkins Dashboard → Click New Item → Pipeline

Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/yourusername/your-repo.git
Branch: main
Credentials: github-token
Script Path: Jenkinsfile
📌 Jenkinsfile (CI/CD Pipeline)
groovy
Copy
Edit
pipeline {
    agent any
    environment {
        EKS_CLUSTER = "flytbase-cluster"
        AWS_REGION = "us-east-1"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/your-repo.git'
            }
        }

        stage('Build & Test') {
            steps {
                echo "Running tests..."
                // Add your test commands here
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-eks']]) {
                        sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER
                        kubectl apply -f kubernetes/deployments/nginx-deployment.yaml
                        kubectl apply -f kubernetes/services/nginx-service.yaml
                        kubectl apply -f kubernetes/deployments/websocket-deployment.yaml
                        kubectl apply -f kubernetes/services/websocket-service.yaml
                        '''
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods -A'
                sh 'kubectl get services -A'
            }
        }
    }
}
🌍 Access WebSocket & Nginx in Browser
1️⃣ Get WebSocket & Nginx URLs
sh
Copy
Edit
kubectl get services -A
Example output:

cpp
Copy
Edit
default       nginx-service        LoadBalancer   a1b2c3d4.elb.amazonaws.com   80:31456/TCP
default       websocket-service    LoadBalancer   e5f6g7h8.elb.amazonaws.com   8080:32090/TCP
🔹 Nginx URL:

arduino
Copy
Edit
http://a1b2c3d4.elb.amazonaws.com
🔹 WebSocket URL:

arduino
Copy
Edit
ws://e5f6g7h8.elb.amazonaws.com:8080
2️⃣ Test WebSocket in Browser Console
1️⃣ Open Google Chrome → Press F12 → Go to Console
2️⃣ Run:

javascript
Copy
Edit
let ws = new WebSocket("ws://e5f6g7h8.elb.amazonaws.com:8080");

ws.onopen = () => {
    console.log("✅ Connected to WebSocket!");
    ws.send("Hello from Browser!");
};

ws.onmessage = (event) => {
    console.log("📩 Received:", event.data);
};
3️⃣ Open Nginx in Browser
Go to:

arduino
Copy
Edit
http://a1b2c3d4.elb.amazonaws.com
✅ If you see the Nginx default page, it's working! 🎉

📌 Debugging Issues
1️⃣ Check Kubernetes Pods
sh
Copy
Edit
kubectl get pods -A
kubectl logs -l app=websocket -n default
2️⃣ Verify LoadBalancer Security Group
sh
Copy
Edit
aws ec2 describe-security-groups --region us-east-1 --query 'SecurityGroups[*].[GroupId,IpPermissions]'
If port 8080 or 80 is missing, add:

sh
Copy
Edit
aws ec2 authorize-security-group-ingress --group-id <SG_ID> --protocol tcp --port 8080 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id <SG_ID> --protocol tcp --port 80 --cidr 0.0.0.0/0
🚀 Next Steps
✅ Deploy Nginx & WebSocket on AWS EKS
✅ Automate deployment with Jenkins CI/CD
✅ Access both services in the browser

🎯 Future Enhancements:

Add TLS/SSL (wss://, https://)
Use Ingress Controller for domain-based access
Deploy a frontend UI for WebSocket communication
