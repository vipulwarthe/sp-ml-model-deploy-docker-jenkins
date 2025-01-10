pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/vipulwarthe/sp-repo.git'
        IMAGE_NAME = 'vipulwarthe/ml-model-app'
        SONAR_PROJECT_KEY = 'student-performance-app'
        SONAR_HOST_URL =  'http://54.160.134.66:9000'
        SONAR_AUTH_TOKEN = 'squ_ca6d93ad6f55cf35d037312591ed87a9093d1a12'    
    }

    stages {
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

        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                withSonarQubeEnv('SonarQube') {
                    sh """
                    sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.sources=. \
                        -Dsonar.python.version=3.9 \
                        -Dsonar.host.url=${env.SONAR_HOST_URL} \
                        -Dsonar.login=${env.SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                echo 'Checking SonarQube Quality Gate...'
                waitForQualityGate abortPipeline: true
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
                docker run -d -p 5000:5000 --name student-performance-app ${IMAGE_NAME}:latest
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


