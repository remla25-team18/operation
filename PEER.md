## Required Software

To run this project, the following applications need to be installed on your system:

- Docker
- Vagrant
- VirtualBox
- Ansible

## Repository Links:

Our project is composed of the following repositories:

operation: https://github.com/remla25-team18/operation

- Release A1: https://github.com/remla25-team18/operation/releases/tag/a1
- Release A2: https://github.com/remla25-team18/operation/releases/tag/a2
- Release A3: https://github.com/remla25-team18/operation/releases/tag/a3
- Release A4: https://github.com/remla25-team18/operation/releases/tag/a4
- Release A5: https://github.com/remla25-team18/operation/releases/tag/a5

model training: https://github.com/remla25-team18/model-training

- Release A1: https://github.com/remla25-team18/model-training/releases/tag/a1
- Release A2: https://github.com/remla25-team18/model-training/releases/tag/a2
- Release A3: https://github.com/remla25-team18/model-training/releases/tag/a3
- Release A4: https://github.com/remla25-team18/model-training/releases/tag/a4
- Release A5: https://github.com/remla25-team18/model-training/releases/tag/a5

model service: https://github.com/remla25-team18/model-service

- Release A1: https://github.com/remla25-team18/model-service/releases/tag/a1
- Release A2: https://github.com/remla25-team18/model-service/releases/tag/a2
- Release A3: https://github.com/remla25-team18/model-service/releases/tag/a3
- Release A4: https://github.com/remla25-team18/model-service/releases/tag/a4
- Release A5: https://github.com/remla25-team18/model-service/releases/tag/a5

lib-ml: https://github.com/remla25-team18/lib-ml

- Release A1: https://github.com/remla25-team18/lib-ml/releases/tag/a1
- Release A2: https://github.com/remla25-team18/lib-ml/releases/tag/a2
- Release A3: https://github.com/remla25-team18/lib-ml/releases/tag/a3
- Release A4: https://github.com/remla25-team18/lib-ml/releases/tag/a4
- Release A5: https://github.com/remla25-team18/lib-ml/releases/tag/a5

lib-version: https://github.com/remla25-team18/lib-version

- Release A1: https://github.com/remla25-team18/lib-version/releases/tag/a1
- Release A2: https://github.com/remla25-team18/lib-version/releases/tag/a2
- Release A3: https://github.com/remla25-team18/lib-version/releases/tag/a3
- Release A4: https://github.com/remla25-team18/lib-version/releases/tag/a4
- Release A5: https://github.com/remla25-team18/lib-version/releases/tag/a5

app: https://github.com/remla25-team18/app

- Release A1: https://github.com/remla25-team18/app/releases/tag/a1
- Release A2: https://github.com/remla25-team18/app/releases/tag/a2
- Release A3: https://github.com/remla25-team18/app/releases/tag/a3
- Release A4: https://github.com/remla25-team18/app/releases/tag/a4
- Release A5: https://github.com/remla25-team18/app/releases/tag/a5
  
Note: In our organization there are two other repositories, namely app-frontend and app-service. These repositories are no longer maintained, and are only there for activity tracking reasons. The current project uses the app repository.

## Comments for A5:

Git tags for every repo to be reviewed are marked with $a5$

Since we decide the final deployment structure and the data flow still needs to be polished, we chose to skip the documentation for now and only did task 1.1 Implementation of a5, which is the following:

- Traffic Management: 
- Continuous Experimentation: See `docs/continuous-experimentation.md` for details, so far we achieved sufficient level because only prometheus is used for monitoring and Grafana hasn't been set up yet.
- Additional Use Case(Rate Limiting):

## Comments for A4:

Git tags for every repo to be reviewed are marked with $a4$

We have finished the following aspects:
- Basic automated ML tests have been implemented
- Test coverage is measured with `coverage.py`
- For both linting & testing, automated workflows have been set up (coverage is automatically updated in README)
- For the ML Config Management rubrics, we got everything up to and including the Good requirements working


## Comments for A3:

Git tags for every repo to be reviewed are marked with $a3$.

We have finished the following aspects:
- Deploying the app and model service to the Kubernetes cluster
- Creating a Helm chart for the deployment
- Adding metrics to the app and monitoring them using Prometheus

## Comments for A2:

Git tags for every repo to be reviewed are marked with $a2$.

We have finished the following aspects:

- Set up VM infrastructure
- Set up Software environment
- Set up basic Kubernetes cluster (steps 20-21)

We haven't finished the following:

- Set up basic Kubernetes cluster (step 22)
- Setting up Istio service mesh

## Comments for A1:

Git tags for every repo to be reviewed are marked with $a1$.

For A1, all `Good` requirements have been met. Some excellent criteria are also met, but not all.
