pipeline {
    agent any

    environment {
        // Docker image name for DEV environment
        DOCKER_IMAGE = "kamble123456789/my-nginx-app:dev-${env.BRANCH_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from Git branch
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image $DOCKER_IMAGE"
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub"
                // Use Docker Hub credentials
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Update Kubernetes ConfigMap') {
            steps {
                echo "Updating Kubernetes ConfigMap for HTML changes"
                // Use kubeconfig credential
                withCredentials([file(credentialsId: 'local-kubeconfig', variable: 'KUBECONFIG_PATH')]) {
                    sh """
                    kubectl delete configmap nginx-html --ignore-not-found --kubeconfig=$KUBECONFIG_PATH
                    kubectl create configmap nginx-html --from-file=$WORKSPACE/html/ --kubeconfig=$KUBECONFIG_PATH
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes DEV environment"
                withCredentials([file(credentialsId: 'local-kubeconfig', variable: 'KUBECONFIG_PATH')]) {
                    sh """
                    kubectl set image deployment/nginx-deployment nginx=$DOCKER_IMAGE --kubeconfig=$KUBECONFIG_PATH
                    kubectl rollout status deployment/nginx-deployment --kubeconfig=$KUBECONFIG_PATH
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ DEV Deployment successful for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ DEV Deployment failed for branch ${env.BRANCH_NAME}"
        }
    }
}