## Repository Links:

We have 8 repos in total(the app repo is not used so far), can be found namely through:

operation: https://github.com/remla25-team18/operation

model training: https://github.com/remla25-team18/model-training

model service: https://github.com/remla25-team18/model-service

lib-ml: https://github.com/remla25-team18/lib-ml

app-frontend: https://github.com/remla25-team18/app-frontend

app-service: https://github.com/remla25-team18/app-service

lib-version: https://github.com/remla25-team18/lib-version


## Comments for A1:

Git tags for every repo to be reviewed are marked with $a1$.

We have finished the following aspects:
- Basic Requirements for Data Availability and Sensible Use Case;
- Automated Release Process, which can be trigger by `git push origin <vx.x.x>`;
- Exposing a Model via REST, all ports and DNS are defined as env variable;
- A dummy docker compose.


We havn't finished the following:
- We have packaged lib-ml, but not for lib-version.
- The Docker Compose Operation is not fully functioning because we have 3 separate images for app-frontend, app-service and model-service now.