pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/vipulwarthe/sp-ml-model-deploy-docker-jenkins.git'
        IMAGE_NAME = 'vipulwarthe/sp-model-app'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
                echo 'Workspace cleaned successfully.'
            }
        }

        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', url: "${REPO_URL}"
            }
        }

       stage('Install Dependencies') {
           steps {
               echo 'Installing dependencies...'
               sh '''
               if ! python3 -m pip --version > /dev/null 2>&1; then
               echo "pip not found. Installing pip locally..."
               wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py
               python3 get-pip.py --user
               export PATH=$PATH:$HOME/.local/bin
               fi
               python3 -m pip install --user -r requirements.txt
               '''
           }
       }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying application...'
                sh '''
                docker stop ml-model-app || true
                docker rm ml-model-app || true
                docker run -d -p 5000:5000 --name sp-app-1 ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}






