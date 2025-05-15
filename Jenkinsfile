pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/ajithdevopsproject/devopsfinalproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('ajithdocgym/staticweb:latest')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', '8bbedcc6-7f8c-4fb7-9133-797f53bc3d44') {
                        docker.image('ajithdocgym/staticweb:latest').push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 80:80 --name staticweb ajithdocgym/staticweb:latest'
            }
        }
    }
}
