provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id # Amazon Linux 2 or Ubuntu AMI (set via env)
  instance_type = var.instance_type
  key_name      = var.key_name # SSH Key

  tags = {
    Name = "Jenkins-Server"
  }

  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = file("install-jenkins.sh") #jenkins installation script
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow SSH and Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

