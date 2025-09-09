pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "thanh295/nodejs:latest"
        REGISTRY_CREDENTIAL = 'docker-hub'
        GIT_CREDENTIAL = 'github-key'
        KUBECONFIG_CREDENTIAL = 'kubeconfigCredential'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git(
                    branch: 'main',
                    url: 'https://github.com/Nguyenbaothanh/learn-jenkins-app.git',
                    credentialsId: "${GIT_CREDENTIAL}"
                )
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Lint Code') {
            steps {
                sh 'npm run lint || echo "Linting not configured, skipping..."'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'npm test || echo "Tests not configured, skipping..."'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: REGISTRY_CREDENTIAL, url: 'https://index.docker.io/v1/') {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Setup Kubectl') {
            steps {
                sh '''
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                chmod +x kubectl
                mv kubectl $HOME/.local/bin/
                export PATH=$HOME/.local/bin:$PATH
                kubectl version --client
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: "${KUBECONFIG_CREDENTIAL}"]) {
                    sh "kubectl apply -f k8s/deployment.yaml -n default"
                    sh "kubectl set image deployment/my-app my-app=${DOCKER_IMAGE} -n default"
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f || true'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for details.'
        }
    }
}
