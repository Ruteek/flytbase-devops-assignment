pipeline {
    agent any
    environment {
        GIT_CREDENTIALS = credentials('git-cred')
        REPO_URL = 'https://github.com/Ruteek/flytbase-devops-assignment.git'
         
        AWS_CREDENTIALS = credentials('eks-cred')
        EKS_CLUSTER = "flytbase-cluster"
        KUBECONFIG_PATH = "/home/ubuntu/.kube/config"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/Ruteek/flytbase-devops-assignment.git"
            }
        }

        stage('Build & Test') {
            steps {
                echo "Running tests..."
                // Add build/test commands here
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'eks-cred']]) {
                        sh '''
                        aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER
                        kubectl apply -f kubernetes/nginx-deployment.yaml
                        kubectl apply -f kubernetes/nginx-service.yaml
                        kubectl apply -f kubernetes/websocket-deployment.yaml
                        kubectl apply -f kubernetes/websocket-service.yaml
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
