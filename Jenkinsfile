pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/vipulwarthe/sp-repo.git'
        IMAGE_NAME = 'vipulwarthe/ml-model-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Running Docker container...'
                sh '''
                    docker stop ml-model-app || true
                    docker rm ml-model-app || true
                    docker run -d -p 5000:5000 --name ml-model-app ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh '''
                docker ps -aq --filter "name=ml-model-app" | xargs -r docker stop
                docker ps -aq --filter "name=ml-model-app" | xargs -r docker rm
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
