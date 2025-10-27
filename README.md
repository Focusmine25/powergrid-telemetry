---
## Project Overview

The **PowerGrid Telemetry Pipeline** is a containerized, production-like telemetry ingestion and processing system for power grid devices. It simulates device telemetry, validates and streams it through a messaging layer, stores raw and processed data, exposes metrics, and includes CI/CD, infrastructure-as-code, observability, and secure deployment on **AWS EKS**.

**Goal:** Mirror real-world utility telemetry pipelines — reliable ingestion, monitoring, security, and predictable deployments.

---


---

## Components

1. **Device Simulator** (Python)
   - Simulates power grid device telemetry.
   - Publishes data to the Ingest API.

2. **Ingest API** (Node.js)
   - Receives telemetry via HTTP.
   - Validates and publishes messages to Kafka.

3. **Message Broker** (Kafka on EKS)
   - Reliable streaming of telemetry data.
   - Can also use Amazon MSK/Kinesis in production.

4. **Stream Processor / Consumer**
   - Listens to Kafka queue.
   - Processes telemetry, stores raw data in **S3**, enriched data in **DynamoDB**.

5. **Frontend / Dashboard**
   - Grafana visualizes metrics collected via Prometheus.
   - Optional UI for querying processed telemetry.

6. **Observability**
   - **Prometheus:** Collect metrics.
   - **Grafana:** Dashboards.
   - **Fluentd/Filebeat → Elasticsearch / CloudWatch:** Logs collection.

7. **CI/CD**
   - GitHub Actions:
     - Build Docker images
     - Run tests
     - Push images to AWS ECR
     - Deploy to EKS using Helm charts

8. **Infrastructure as Code**
   - Terraform provisions:
     - VPC, Subnets
     - EKS cluster
     - ECR
     - DynamoDB and S3
     - IAM roles for services

9. **Security**
   - Kubernetes Secrets & AWS Secrets Manager
   - IAM roles for service accounts
   - Network policies
   - TLS for services
   - Pod security best practices

---

## Setup & Installation

### Prerequisites
- **Docker Desktop** (with Kubernetes enabled)
- **Minikube** (optional local cluster)
- **Node.js** (v18+)
- **Python 3.10+**
- **Terraform v1.13.4+**
- **AWS CLI** configured
- **kubectl** installed

### Local Setup
1. Clone the repository:
```bash
git clone https://github.com/yourusername/powergrid-telemetry.git
cd powergrid-telemetry


