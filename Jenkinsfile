
pipeline {
    agent any

    environment {
        IMAGE = 'ajithdocgym/staticwebmonitering:latest'
        CONTAINER = 'staticwebmonitering'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/ajithdevopsproject/devopsfinalproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', '8bbedcc6-7f8c-4fb7-9133-797f53bc3d44') {
                        docker.image("${IMAGE}").push()
                    }
                }
            }
        }

        stage('Remove Old Container') {
            steps {
                script {
                    sh '''
                    docker stop ${CONTAINER} || true
                    docker rm ${CONTAINER} || true
                    '''
                }
            }
        }

        stage('Deploy New Container') {
            steps {
                script {
                    sh "docker run -d -p 80:80 -p 9090:9090 -p 9093:9093 -p 3000:3000 --name ${CONTAINER} ${IMAGE}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }
    }
}
