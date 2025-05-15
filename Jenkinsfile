pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('8bbedcc6-7f8c-4fb7-9133-797f53bc3d44') // Replace with your Jenkins DockerHub credential ID
        IMAGE_NAME = "ajithdocgym/dev"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub (your repo & branch)
                git branch: 'dev',
                    url: 'https://github.com/ajithdevopsproject/devopsfinalproject.git',
                    credentialsId: '' // Add if private repo
            }
        }

        stage('Debug Workspace') {
            steps {
                echo "Listing files in workspace root:"
                sh 'ls -la'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build docker image using current directory (repo root)
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using stored credentials
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean workspace after build
            cleanWs()
        }
        failure {
            echo 'Build failed. Check logs for errors.'
        }
        success {
            echo 'Build and push successful!'
        }
    }
}
