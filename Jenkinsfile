pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/vipulwarthe/sp-repo.git'
        IMAGE_NAME = 'vipulwarthe/ml-model-app'
        CONTAINER_NAME = 'ml-model-app'
        PORT_MAPPING = '5000:5000'
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
                sh '''
                    docker build -t ${IMAGE_NAME}:latest .
                '''
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
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d -p ${PORT_MAPPING} --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up unused Docker resources...'
            sh '''
                docker ps -aq --filter "status=exited" | xargs -r docker rm
                docker images -q --filter "dangling=true" | xargs -r docker rmi
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


