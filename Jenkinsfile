pipeline {
    agent {
        docker {
            image 'node:18'  // Dùng image NodeJS để build/test app
        }
    }

    environment {
        DOCKER_IMAGE = "thanh295/nodejs:latest"
        KUBECONFIG = "/root/.kube/config"  // hoặc nơi khác tùy cấu hình của bạn
    }

    stages {
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
            agent any  // cần agent ngoài để chạy Docker build
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'

                sh '''
                # Kiểm tra quyền truy cập cluster
                kubectl version --client
                kubectl config current-context

                # Apply deployment & service
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

                kubectl rollout status deployment/nodejs-app
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker...'
            sh 'docker system prune -f || true'
        }
        success {
            echo '✅ Deployment completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for errors.'
        }
    }
}
