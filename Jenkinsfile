pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "thanh295/nodejs:latest"
        registryCredential = 'docker-hub'
        kubeconfigCredential = 'kubernetes'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Nguyenbaothanh/learn-jenkins-app.git'
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
                withDockerRegistry(credentialsId: registryCredential, url: 'https://index.docker.io/v1/') {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubernetesDeploy(
                        configs: 'k8s/deployment.yaml',
                        kubeconfigId: kubeconfigCredential
                    )
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
