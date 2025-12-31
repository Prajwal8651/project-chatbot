pipeline {
    agent any

    environment {
        IMAGE_NAME   = "prajwal8651/chatbot:${GIT_COMMIT}"
        AWS_REGION   = "us-west-2"
        CLUSTER_NAME = "devops-cluster"
        NAMESPACE    = "devops-chatbot"
    }

    stages {

        stage('Git-checkout') {
            steps {
                git url: 'https://github.com/Prajwal8651/project-chatbot.git', branch: 'main'
            }
        }

        stage('Building-Stage') {
            steps {
                sh '''
                    printenv
                    docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Testing-Stage') {
            steps {
                sh '''
                    if docker ps -a --format '{{.Names}}' | grep -w chatbot-container > /dev/null; then
                        docker rm -f chatbot-container
                    fi
                    docker run -it -d --name chatbot-container -p 9001:8501 ${IMAGE_NAME}
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'docker-hub-creds',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )
                    ]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Pushing to Docker hub') {
            steps {
                sh "docker push ${IMAGE_NAME}"
            }
        }

        stage('Cluster-Update') {
            steps {
                sh "aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}"
            }
        }

        stage('Deploying to EKS cluster') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'devops-cluster',
                    contextName: '',
                    credentialsId: 'kube',
                    namespace: 'devops-chatbot',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://B21FFB423837C8CDB50D491BC21F4D20.gr7.us-west-2.eks.amazonaws.com'
                ) {
                    sh "sed -i 's|replace|${IMAGE_NAME}|g' Deployment.yml"
                    sh "kubectl apply -f Deployment.yml -n ${NAMESPACE}"
                }
            }
        }

        stage('Verify the deployment') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'devops-cluster',
                    contextName: '',
                    credentialsId: 'kube',
                    namespace: 'devops-chatbot',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://B21FFB423837C8CDB50D491BC21F4D20.gr7.us-west-2.eks.amazonaws.com'
                ) {
                    sh "kubectl get pods -n ${NAMESPACE}"
                    sh "kubectl get services -n ${NAMESPACE}"
                }
            }
        }
    }
}
