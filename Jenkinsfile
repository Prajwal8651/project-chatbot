pipeline{
    agent any
    
    environment{
        IMAGE_NAME = "prajwal8651/chatbot:${GIT_COMMIT}"
    }

    stages{

        stage('Git-checkout'){
            steps{
                git url: 'https://github.com/Prajwal8651/project-chatbot.git', branch: 'main'
            } 
        }

        stage('Building-Stage'){
            steps{
                sh '''
                    printenv
                    docker build -t ${IMAGE_NAME} .
                '''
            } 
        }

        stage('Testing-Stage'){
            steps{
                sh '''
                    # Safely remove old container if it exists
                    if docker ps -a --format '{{.Names}}' | grep -w chatbot-container > /dev/null; then
                        echo "Old container found. Removing..."
                        docker rm -f chatbot-container
                    else
                        echo "No previous container found. Skipping removal."
                    fi

                    # Start new container
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

        stage('Pushing to Docker hub'){
            steps{
                sh '''
                    docker push ${IMAGE_NAME}
                '''
            }
        }
    }
}
