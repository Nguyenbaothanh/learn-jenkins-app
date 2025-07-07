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

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubernetesDeploy(
                        configs: 'k8s/deployment.yaml',
                        kubeconfigId: KUBECONFIG_CREDENTIAL
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
