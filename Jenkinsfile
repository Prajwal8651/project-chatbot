pipeline {
    agent any

    environment {
        IMAGE_NAME   = "prajwal8651/chatbot:${GIT_COMMIT}"
        AWS_REGION   = "us-west-2"
        CLUSTER_NAME = "devops-cluster"
        NAMESPACE    = "devops-chatbot"
    }

    stages {

        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/Prajwal8651/project-chatbot.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Test Docker Image') {
            steps {
                sh '''
                    if docker ps -a --format '{{.Names}}' | grep -w chatbot-container > /dev/null; then
                        docker rm -f chatbot-container
                    fi

                    docker run -d --name chatbot-container -p 9001:8501 ${IMAGE_NAME}
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'devops-cluster',
                    contextName: '',
                    credentialsId: '',
                    namespace: 'devops-chatbot',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://E2230E4C1EFE686FBCB10EAFD44571D3.gr7.us-west-2.eks.amazonaws.com'
                ) {
                    sh '''
                        sed -i "s|replace|${IMAGE_NAME}|g" Deployment.yml
                        kubectl apply -f Deployment.yml -n ${NAMESPACE}
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'devops-cluster',
                    contextName: '',
                    credentialsId: '',
                    namespace: 'devops-chatbot',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://E2230E4C1EFE686FBCB10EAFD44571D3.gr7.us-west-2.eks.amazonaws.com'
                ) {
                    sh '''
                        kubectl get pods -n ${NAMESPACE}
                        kubectl get svc -n ${NAMESPACE}
                    '''
                }
            }
        }
    }
}
