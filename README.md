![alt text](https://github.com/Prajwal8651/project-chatbot/blob/9354675d06ddf7a4c40046d46db21eef257af184/image%20(2).png)

# Itkannadigaru Chatbot Infrastructure

This document provides an overview of the infrastructure for the Itkannadigaru Chatbot, which is deployed on AWS using Terraform and Jenkins.

## Infrastructure Overview

The infrastructure is defined using Terraform and consists of the following components:

*   **Amazon EKS (Elastic Kubernetes Service):** A managed Kubernetes service to run the chatbot application.
*   **Amazon VPC (Virtual Private Cloud):** A dedicated and isolated virtual network for the EKS cluster.
*   **Public Subnets:** Two public subnets are created for the EKS worker nodes.
*   **Internet Gateway:** Provides internet access to the subnets.
*   **Route Table:** Routes traffic from the subnets to the internet.
*   **Security Groups:** Control inbound and outbound traffic to the EKS cluster and worker nodes.
*   **IAM Roles:** IAM roles are defined for the EKS cluster and worker nodes to provide the necessary permissions to interact with other AWS services.

## CI/CD Pipeline

A Jenkins pipeline is used to automate the deployment of the infrastructure. The pipeline is defined in the `Jenkinsfile` and consists of the following stages:

1.  **Checkout:** The pipeline checks out the source code from the GitHub repository.
2.  **Plan:** It runs `terraform plan` to create an execution plan for the infrastructure changes.
3.  **Approval:** The pipeline waits for manual approval before applying any changes. This allows for a review of the plan before it is executed.
4.  **Apply or Destroy:** Based on the user's choice, the pipeline either applies the changes using `terraform apply` or destroys the infrastructure using `terraform destroy`.
5.  **Backup-Stage:** After applying the changes, the pipeline backs up the `terraform.tfstate` file to an S3 bucket. This is crucial for disaster recovery and for managing the state of the infrastructure.

## Use Cases

This infrastructure is designed to support the following use cases:

*   **Development and Testing:** The infrastructure can be quickly provisioned to create a development or testing environment for the chatbot application. The `terraform apply` and `terraform destroy` commands, automated by the Jenkins pipeline, make it easy to create and tear down the environment as needed.
*   **Staging:** A staging environment can be created to test new features and bug fixes before they are deployed to production. This environment would be a replica of the production environment.
*   **Production:** The infrastructure is robust enough to be used for a production deployment of the chatbot. The EKS cluster can be scaled to handle a large number of users.
*   **Disaster Recovery:** The backup of the Terraform state to S3 allows for quick recovery in case of a disaster. The entire infrastructure can be recreated from the state file.
*   **Scalability:** The EKS node group is configured with a scaling policy that allows it to automatically scale up or down based on the load. This ensures that the application is always available and responsive.




