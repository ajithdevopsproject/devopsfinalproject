pipeline {
    agent any
    environment {
        DEV_REPO = "ajithdocgym/dev"
        PROD_REPO = "ajithdocgym/prod"
        IMAGE_TAG = "latest"
        BRANCH_NAME = "dev"  // Explicitly set branch name to fix null issue
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH_NAME}", url: 'https://github.com/ajithdevopsproject/devopsfinalproject.git'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${DEV_REPO}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        if (BRANCH_NAME == 'dev') {
                            dockerImage.push()
                        } else if (BRANCH_NAME == 'master') {
                            dockerImage.tag("${PROD_REPO}:${IMAGE_TAG}")
                            dockerImage.push("${PROD_REPO}:${IMAGE_TAG}")
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            when {
                expression { return BRANCH_NAME == 'dev' }
            }
            steps {
                sh './deploy.sh'
            }
        }
    }
    triggers {
        githubPush()
    }
}
