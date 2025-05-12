## Repository Links:

Our project is composed of the following repositories:

operation: https://github.com/remla25-team18/operation

model training: https://github.com/remla25-team18/model-training

model service: https://github.com/remla25-team18/model-service

lib-ml: https://github.com/remla25-team18/lib-ml

lib-version: https://github.com/remla25-team18/lib-version

app: https://github.com/remla25-team18/app

Note: In our organization there are two other repositories, namely app-frontend and app-service, which are only there for activity tracking reasons. The current project uses the app repository.

## Comments for A2:

Git tags for every repo to be reviewed are marked with $a2$.

We have finished the following aspects:

We haven't finished the following:

## Comments for A1:

Git tags for every repo to be reviewed are marked with $a1$.

We have finished the following aspects:
- Basic Requirements for Data Availability and Sensible Use Case;
- Automated Release Process, which can be triggered by `git push origin <vx.x.x>`;
- Exposing a Model via REST, all ports and DNS are defined as env variable;
- A dummy docker compose.


We haven't finished the following:
- We have packaged lib-ml, but not for lib-version.
- The Docker Compose Operation is not fully functioning because we have 3 separate images for app-frontend, app-service and model-service now.