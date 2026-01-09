# GenAI Chatbot with CI/CD Automation

This repository contains a GenAI chatbot application built with Python, Streamlit, and LangChain. The project is fully automated with a CI/CD pipeline using Jenkins, Docker, and Kubernetes (EKS).

## Project Overview

The application is a simple chatbot that uses the OpenAI API to answer user questions. The frontend is built with Streamlit, and the backend logic is handled by LangChain.

## CI/CD Pipeline

The CI/CD pipeline is defined in the `Jenkinsfile` and consists of the following stages:

1.  **Git-checkout**: Clones the source code from the GitHub repository.
2.  **Building-Stage**: Builds a Docker image of the application using the `Dockerfile`.
3.  **Login to Docker Hub**: Logs in to Docker Hub using credentials stored in Jenkins.
4.  **Pushing to Docker hub**: Pushes the Docker image to Docker Hub.
5.  **Cluster-Update**: Updates the kubeconfig to connect to the EKS cluster.
6.  **Deploying to EKS clsuter**: Deploys the application to the EKS cluster using the `Deployment.yml` file.
7.  **Verify the deployment**: Verifies the deployment by checking the status of pods and services.

## Kubernetes Configuration

The Kubernetes configuration is defined in the `Deployment.yml` file and the `k8-permissions/` directory.

*   **`Deployment.yml`**: Defines a Kubernetes Deployment and a LoadBalancer Service to expose the application.
*   **`k8-permissions/`**: Contains the RBAC configuration for Jenkins to interact with the Kubernetes API.
    *   `sa.yaml`: Creates a ServiceAccount for Jenkins.
    *   `role.yaml`: Defines a Role with permissions to manage Kubernetes resources.
    *   `role-binding.yaml`: Binds the Role to the ServiceAccount.
    *   `token.yaml`: Creates a Secret to store the ServiceAccount token.

## How to Use

1.  **Prerequisites**:
    *   An AWS account with an EKS cluster.
    *   Jenkins server with the required plugins (Docker, Kubernetes, etc.).
    *   Docker Hub account.
    *   OpenAI API key.

2.  **Setup**:
    *   Clone this repository.
    *   Create a Jenkins pipeline and point it to the `Jenkinsfile` in this repository.
    *   Configure the Jenkins credentials for Docker Hub and Kubernetes.
    *   Update the environment variables in the `Jenkinsfile` with your specific values.

3.  **Run**:
    *   Start the Jenkins pipeline. The pipeline will automatically build, push, and deploy the application to your EKS cluster.
![image alt](https://github.com/Prajwal8651/project-chatbot/blob/b29a80e18827c5a0c921f8e101ca4ca2a12ff1f7/image.png)
![image alt](https://github.com/Prajwal8651/project-chatbot/blob/acdaa74aeaae2db3ed439e4eff04941d136a5ba6/image-1.PNG)
