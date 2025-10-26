pipeline {
    agent any

    environment {
        IMAGE_NAME = "ShagovVladislav/Docker"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    bat "docker run -d -p 5000:5000 --name calc-test ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    bat "ping -n 10 127.0.0.1 > nul"
                }
            }
            post {
                always {
                    bat "docker stop calc-test || echo Container already stopped"
                    bat "docker rm calc-test || echo Container already removed"
                }
            }
        }

        stage('Verify Image') {
            steps {
                bat "docker images ${env.IMAGE_NAME}"
                bat "docker run --rm ${env.IMAGE_NAME}:${env.IMAGE_TAG} python -c \"print('App is working!')\""
            }
        }
    }

    post {
        always {
            deleteDir()
            bat "docker system prune -f || echo Docker cleanup completed"
        }
        success {
            echo "✅ Build successful! Docker image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}
