pipeline {
    agent any

    environment {
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

        stage('Update kubeconfig (IAM Role)') {
            steps {
                sh '''
                  aws eks update-kubeconfig \
                    --region ${AWS_REGION} \
                    --name ${CLUSTER_NAME}
                '''
            }
        }

        stage('Create Namespace (if not exists)') {
            steps {
                sh '''
                  kubectl get namespace ${NAMESPACE} \
                  || kubectl create namespace ${NAMESPACE}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                  sed -i "s|IMAGE_PLACEHOLDER|${IMAGE_NAME}|g" Deployment.yml
                  kubectl apply -f Deployment.yml -n ${NAMESPACE}
                '''
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
