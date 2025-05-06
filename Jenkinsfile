pipeline {
    agent any

    tools {
        maven 'MAVEN-HOME' // Ensure the Maven tool is properly set up in Jenkins
    }

    environment {
        DOCKER_IMAGE = 'nayan1103/automation:latest'  // Define the Docker image tag
    }

    triggers {
        githubPush()  // This enables GitHub webhook triggering when there is a push event
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository on the 'main' branch
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/nayanacharya7/automation']]])
            }
        }

        stage('Maven Build') {
            steps {
                // Execute Maven build to clean and install dependencies
                sh 'mvn clean install'
            }
        }

        stage('Docker Build') {
            steps {
                // Build the Docker image with the latest tag
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
                // Push the Docker image to Docker Hub using stored credentials
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Apply Kubernetes deployment and service YAML configurations
                withCredentials([file(credentialsId: 'k8s-credentials', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f deployment.yaml --validate=false'
                    sh 'kubectl apply -f service.yaml --validate=false'
                }
            }
        }
    }
}
