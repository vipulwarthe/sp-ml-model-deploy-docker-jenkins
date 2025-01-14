pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/vipulwarthe/sp-repo.git'
        IMAGE_NAME = 'vipulwarthe/ml-model-app'
        SONAR_PROJECT_KEY = 'ml-model-app'
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
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh 'pytest tests/'
            }
        }

        stage('OWASP Dependency-Check') {
            steps {
                echo 'Running OWASP Dependency-Check...'
                sh '''
                dependency-check.sh --project ml-model-app --scan . --format "HTML"
                '''
                archiveArtifacts artifacts: 'dependency-check-report.html', allowEmptyArchive: true
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Trivy Security Scan') {
            steps {
                echo 'Running Trivy security scan...'
                sh 'trivy image --exit-code 1 --severity HIGH ${IMAGE_NAME}:latest || true'
            }
        }

        stage('Push Docker Image') {
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

        stage('Deploy Application') {
            steps {
                echo 'Deploying application...'
                sh '''
                docker stop ml-model-app || true
                docker rm ml-model-app || true
                docker run -d -p 5000:5000 --name sp-app ${IMAGE_NAME}:latest
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






