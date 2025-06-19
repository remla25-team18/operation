# Deplyment Documentation

This file aims to conceptially document the final deployment of REMLA's group 18 review sentiment analysis system, in terms of the deployment structure and data flow. After studying the documentation, an outsiders (e.g. a new team member) should have sufficient understanding of the overall design to contribute in a design discussion.

## Deployment Structure
Deployment structure 
- Visualization (with all deployed resources and their connections -> entities, their types and relations should be clear)
- Provide understanding of general setup

Microservices (do our own high level architecture diagram of the components and how they communicate with each other)

Kubernetes deployment: controller VM (ip), two worker nodes VMs (ip) -> provisioned using vagrant and ansible

Istio service mesh (traffic management)

Continuous monitoring
- prometheus: scrape metrics
- grafana: visualization


## Data Flow
- Flow of requests in the cluster (including dynamic traffic routing in experiment, 90/10 split)
- Provide understanding of experimental design

Incoming requests (http) -> istio ingress gateway

-> virtual service + destination rule (traffic routing - standard 90/10 split) + sticky sessions:

a) 90% v1 -> app version 1

b) 10% v2 -> app version 2

-> model communication: REST to model service, which responds with prediction to app

Mention continuous experimentation or rate limiting where?


## Repository Links
- operation: https://github.com/remla25-team18/operation
- app: https://github.com/remla25-team18/app
- model-service: https://github.com/remla25-team18/model-service
- model-training: https://github.com/remla25-team18/model-training
- lib-ml: https://github.com/remla25-team18/lib-ml
- lib-version: https://github.com/remla25-team18/lib-version
