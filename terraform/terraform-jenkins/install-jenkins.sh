#!/bin/bash
sudo apt update -y

# Install Java (Required for Jenkins)
sudo apt install -y openjdk-17-jdk

# Add Jenkins repo and install
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker jenkins

# Install AWS CLI
sudo apt install -y awscli

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Print Jenkins Initial Password
echo "Jenkins is ready! Access it at http://<EC2-PUBLIC-IP>:8080"
echo "Retrieve admin password using:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

