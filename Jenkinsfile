pipeline {
    agent any

    environment {
        // Set your Docker Hub repo (username/repo)
        DOCKER_REPO = "prajwal8651/chat-bot"
        // Jenkins credentials id for docker username/password
        DOCKER_CREDS_ID = "docker-hub-creds"
        // Name for the test container we create during pipeline
        TEST_CONTAINER = "chat-bot-test"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/Prajwal8651/project-chatbot.git']]
                ])
            }
        }

        stage('Set image name') {
            steps {
                script {
                    // compute a short SHA for readability
                    def shortSha = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
                    env.IMAGE_NAME = "${env.DOCKER_REPO}:${shortSha}"
                    echo "Image will be: ${env.IMAGE_NAME}"
                }
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Building Docker image: ${IMAGE_NAME}"
                    docker build -t "${IMAGE_NAME}" .
                '''
            }
        }

        stage('Test - start container (safely remove previous if exists)') {
            steps {
                sh """
                    echo "Checking for existing container named ${TEST_CONTAINER}..."
                    if docker ps -a --format '{{.Names}}' | grep -w ${TEST_CONTAINER} > /dev/null 2>&1; then
                        echo "Found existing container ${TEST_CONTAINER} — removing (force)..."
                        docker rm -f ${TEST_CONTAINER}
                    else
                        echo "No existing container named ${TEST_CONTAINER} found."
                    fi

                    echo "Starting new container ${TEST_CONTAINER} from ${IMAGE_NAME} (detached)..."
                    docker run -d --name ${TEST_CONTAINER} -p 9001:8501 ${IMAGE_NAME}
                """

                // Optional health check (uncomment if you want the pipeline to fail on bad health)
                // sh "sleep 5 && curl -f http://localhost:9001/ || (docker logs ${TEST_CONTAINER} && exit 1)"
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Push image') {
            steps {
                sh '''
                    echo "Pushing ${IMAGE_NAME} to Docker Hub..."
                    docker push "${IMAGE_NAME}"
                '''
            }
        }
    }

    post {
        always {
            script {
                // best-effort cleanup of test container
                sh "docker rm -f ${TEST_CONTAINER} || true"
            }
        }

        success {
            echo "Pipeline successful — image pushed: ${env.IMAGE_NAME}"
        }

        failure {
            echo "Pipeline failed. Check console output for details."
        }
    }
}
