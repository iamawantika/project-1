pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'kamble123456789/my-nginx-app:dev'
        DOCKER_REGISTRY_CREDENTIALS = 'docker-hub-credentials' // Set in Jenkins Credentials
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning Git repository..."
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/dev"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/iamawantika/project-1.git',
                        credentialsId: 'github-credentials'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${env.DOCKER_IMAGE}"
                bat "docker build -t ${env.DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: env.DOCKER_REGISTRY_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                }

                echo "Pushing Docker image to Docker Hub..."
                bat "docker push ${env.DOCKER_IMAGE}"
            }
        }

        stage('Clean Workspace') {
            steps {
                echo "Cleaning workspace..."
                cleanWs()
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}