# order fulfillment platform

## Overview 

Built a production-grade, event-driven order fulfillment platform on AWS using a microservices architecture with 9 independently deployed services running on ECS Fargate. Designed and implemented the complete infrastructure stack with Terraform, CI/CD pipelines using GitHub Actions + OIDC. Architected cross-service communication with SQS-based orchestration, service discovery, centralized observability, and least-privilege IAM to support resilient workloads.

## Features
- SQS for message based workload
- Prometheus, Grafana, YACE for a complete centralised observability stack 
- Pipeline ownership of deployments to prevent config drifts 
- OIDC using web tokens rather than providing access keys mitigating security risks implementing security best practices 

## Architecture Diagram


## System Design 
Every component of this Infrastructure was thought through carefully in order to maximise efficiency and prevent future issues through smart decisions 

- ECS Fargate: Reduced operational overhead by removing the need to manage EC2 instances. This allowed the platform to focus on application deployment whilst AWS handled compute provisioning and scaling
- EC2 Observability Stack: Added a centralized observability stack on EC2 pushing out logs and metrics from ECS cluster to pinpoint issues in cases of downtime for rapid recovery
- VPC Endpoints: Chosen over NAT Gateways to keep AWS service communication within the private network whilst also reducing costs, introducing a more secure and cost efficient approach 
- SQS v Kafka: Kafka was considered but quickly dimissed due to its complexity and unecessary operational overhead, SQS was the smarter option due to:
    
    - Its clean integration with native AWS services
    - Built in failure system with DLQ 
    - My platform is orchestration focused, orders trigger worklow between services and not analytic heavy 
- ECS vs EKS: This was a major architectural decision throughout the project. While EKS provides greater flexibility, it also introduces significantly higher operational complexity, infrastructure management overhead, and cost. Since the platform consisted of containerized microservices with predictable workloads and did not require advanced Kubernetes features, ECS Fargate was the more appropriate choice. It allowed the platform to remain production-grade and scalable, without the additional complexity of managing Kubernetes
- ElastiCache for rate limiting: Since the platform will process large financial workflows and customer data, rate limiting was implemented at the API gateway layer to protect services from excessive traffic spikes, and request flooding. This helps maintain platform stability, prevents resource exhaustion across microservices, and improves overall system reliability under load.