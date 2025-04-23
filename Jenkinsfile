pipeline 
{
    agent any

    tools 
    {
        maven 'MAVEN-HOME'
    }
     environment 
     {

        KUBECONFIG = 'kubeconfig.yaml'
        DOCKER_USERNAME = 'nayan1103'
        DOCKER_PASSWORD = 'Gopala@1980' // Avoid using hard-coded credentials, use Jenkins secrets
    }


    stages 
    {
        stage('Maven Build') {
            steps {
                 checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/nayanacharya7/automation']])
                     sh 'mvn clean install'
                
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t nayan1103/automation .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    // Push the Docker image to Docker Hub
                    sh 'docker push nayan1103/automation:latest'
                }
            }
        }
        stage('Deploy to Kubernetes') 
        {
            steps {
                script {
                    withCredentials([file(credentialsId: 'k8s-credentials', variable: 'KUBECONFIG')]) {
                        withEnv(["KUBECONFIG=$KUBECONFIG"]) {
                            sh 'kubectl apply -f deployment.yaml --validate=false'
                            sh 'kubectl apply -f service.yaml --validate=false'
                        }
                    }
                }
            }
        }
    }
}
