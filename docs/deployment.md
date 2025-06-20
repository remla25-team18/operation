# Deplyment Documentation

This file aims to conceptially document the final deployment of REMLA's group 18 review sentiment analysis system, in terms of the deployment structure and data flow. After studying the documentation, an outsiders (e.g. a new team member) should have sufficient understanding of the overall design to contribute in a design discussion.

## Deployment Structure
Deployment structure 
- Visualization (with all deployed resources and their connections -> entities, their types and relations should be clear)
- Provide understanding of general setup

Microservices architecture
Kubernetes deployment using Helm: controller VM (ip), two worker nodes VMs (ip) -> provisioned using vagrant and ansible

<div align="center"> 

![Deployment Structure](../assets/DeploymentStructure.jpg)  
**Figure 1: Deployment Structure**

</div> 

Our kubernetes cluster is composed of:

Istio Ingress Layer
- Istio ingress gateway: Provides an entry point to the application running in the istio mesh.
- Istio virtual service: Routes incoming traffic to the services based on the incoming request.

App Layer
- App service: 
- App pods (v1 and v2): 

Model Service Layer
- Model service:
- Model pod:

Monitoring Layer
- Kubernetes dashboard: Provides an overview of the cluster resources.
- Prometheus: Scrape metrics from the application, through a service monitor.
- Grafana: Provides real-time visualization of the metrics collected by Prometheus.


## Data Flow
- Flow of requests in the cluster (including dynamic traffic routing in experiment, 90/10 split)
- Provide understanding of experimental design

### Dynamic Traffic Routing
<div align="center">

![Traffic Management](../assets/TrafficManagement.jpg)  
**Figure 2: Traffic Management**

</div> 

In our experiment, dynamic traffic routing is achieved using:
- Istio ingress gateway: load balancer that handles incoming HTTPS traffic (request) to the mesh.
- Rate limiting: there cannot be more than 10 requests per minute, through an Envoy filter.
- Istio virtual service: with a destination rule, traffic is split 90% to app version 1 and 10% to app version 2, and uses sticky sessions to ensure the versions are consistent.
- Model communication: http post request to get the review sentiment prediction.

For more details regarding continuous experimentation, please refer to `continuous-experimentation.md`.


## Repository Links
- operation: https://github.com/remla25-team18/operation
- app: https://github.com/remla25-team18/app
- model-service: https://github.com/remla25-team18/model-service
- model-training: https://github.com/remla25-team18/model-training
- lib-ml: https://github.com/remla25-team18/lib-ml
- lib-version: https://github.com/remla25-team18/lib-version
