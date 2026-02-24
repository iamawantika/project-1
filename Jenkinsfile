pipeline {
    agent any

    environment {
        IMAGE_NAME = "iamawantika/nginx-app"
        KUBE_DEPLOYMENT = "nginx-deployment"
        CONTAINER_NAME = "nginx"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/iamawantika/project-1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                docker push $IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl set image deployment/$KUBE_DEPLOYMENT \
                $CONTAINER_NAME=$IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl rollout status deployment/$KUBE_DEPLOYMENT
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}