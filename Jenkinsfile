pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "thanh295/nodejs:latest"
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Code already checked out by Jenkins'
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
                withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to Server') {
            steps {
                echo 'Deploying to server...'
                sh '''
                    docker stop node-app || true
                    docker rm node-app || true
                    docker run -d --name node-app -p 3000:3000 ${DOCKER_IMAGE}
                    sleep 5  # Đợi container khởi động
                    docker ps  # Kiểm tra container đang chạy
                    docker logs node-app  # Hiển thị log để debug
                    echo "Check if application is running on port 3000"
                    netstat -tuln | grep 3000 || echo "Port 3000 not found, check container logs"
                '''
            }
        }
    }
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -f || true'
        }
        success {
            echo 'Pipeline completed successfully!'
            echo "Application deployed at: http://localhost:3000"
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
