pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'f511bef3-1dc1-4b96-a44b-0e55a50e0b33'
        NETLIFY_AUTH_TOKEN = credentials('netlify-secret')
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci || exit 1  # Dừng pipeline nếu cài đặt gặp lỗi
                    npm run build || exit 1  # Dừng pipeline nếu build gặp lỗi
                    ls -la build  # Kiểm tra sự tồn tại của các file build
                '''
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f build/index.html || exit 1  # Kiểm tra sự tồn tại của file index.html
                    npm test || exit 1  # Dừng pipeline nếu tests gặp lỗi
                '''
            }
        }
        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    npm install netlify-cli || exit 1  # Dừng pipeline nếu cài đặt netlify-cli gặp lỗi
                    ./node_modules/.bin/netlify --version || exit 1  # Kiểm tra phiên bản Netlify CLI
                    echo "Deploying to production. Site ID"
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod
                '''
            }
        }
    }
    post {
        always {
            junit 'test-results/junit.xml'
        }
    }
}
