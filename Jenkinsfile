pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        IMAGE_NAME   = "prajwal8651/chatbot:${GIT_COMMIT}"
        AWS_REGION   = "us-west-2"
        CLUSTER_NAME = "AskAI-cluster"
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
                    docker rm -f chatbot-container || true
                    docker run -d --name chatbot-container -p 9001:8501 ${IMAGE_NAME}
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login \
                        -u $DOCKER_USERNAME --password-stdin
                    '''
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

        stage('Update kubeconfig for EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${CLUSTER_NAME}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'AskAI-cluster',
                    contextName: '',
                    credentialsId: 'kube',
                    namespace: 'devops-chatbot',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://E91C16DFDD5F678E773F461A9C64F728.gr7.us-west-2.eks.amazonaws.com'
                ) {
                    sh '''
                        sed -i "s|IMAGE_PLACEHOLDER|${IMAGE_NAME}|g" Deployment.yml
                        kubectl apply -f Deployment.yml -n ${NAMESPACE}
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl get pods -n ${NAMESPACE}
                    kubectl get svc  -n ${NAMESPACE}
                '''
            }
        }
    }
}
