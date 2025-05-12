REMLA Group Project | Group 18
====

## How to run

### Assignment 2
For assignment 2, here are the steps to run the project:

1. Make sure you're in `./VM` folder, by doing:

```bash
cd VM
```

2. To boot all the VMs, use the following:

```bash
vagrant up
```

To validate the running process, run

```bash
vagrant status
```
If it successfully runs, you should get the output like this:

```
Current machine states:

ctrl                      running (virtualbox)
node-1                    running (virtualbox)
node-2                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed above with their current state. For more information about a specific VM, run `vagrant status NAME`.

```
3. To finalize the cluster setup, run the following command from the `./VM` folder:
```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

4. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Note: this means next time you need to build the VMs from scratch, which takes time.

### Assignment 1
For assignment 1, we have created a docker-compose file that allows you to run the entire project with a single command.
Under **operation** folder, run:
```bash
docker-compose up
```

Then you should be able to see the web page running at [http://127.0.0.1:4200/](http://127.0.0.1:4200/).

> **Note:** This port is the default. To ensure it's the same port on your computer, check the terminal output, as shown in the image below:

![Docker Port Output](Assets/docker_port.png)


## Relevant repositories

The following repositories are relevant for our REMLA group 18 project:

- [operation](https://github.com/remla25-team18/operation) - stores models and their versions, pointers to other repositories, general instructions how to run the app and a docker-compose file to run the whole project.
- [app](https://github.com/remla25-team18/app) - the app repository that use Flask framework to contain the frontend of the application, which is a web app that allows users to interact with the model and provide feedback and the backend of the application.
- [model-service](https://github.com/remla25-team18/model-service) - the model service, which is a REST API that serves the model and is responsible for sending generating predictions for requested comments.
- [model-training](https://github.com/remla25-team18/model-training) - the component that is responsible for training the model and generating a model version.
- [lib-ml](https://github.com/remla2) - the library that contains a method to process input data.
- [lib-version](https://github.com/remla25-team18/lib-version) - the library that can read its own version.

## Progress log

### Assignment 1
- **[Basic Requirements]** We created a structured organization with several repositories that are responsible for different parts of the project. Operation repository contains a README.md, provides the steps to run the application and docker-compose.yml file to run the whole project. The app has a frontend and a backend which allows a user to interact with the model and provide feedback.
- **[Automated Release Process]** We created a workflow which automatically versions the artifacts and increases patch versions and bumps the version to the next pre-release version. Main is set to a pre-release after a stable release.
- **[Software Reuse in Libraries]** We released libraries lib-version and lib-ml through GitHub packages. lib-ml is reused in both model-training and model-service. A trained model is not part of a container image. 
- **[Exposing a Model via REST]** We used REST API to communicate between the app and model-service, also within the app. DNS name and port are defined as ENV variables. All server endpoints have a well-defined API definition that follows Open API Specification. 
- **[Docker Compose Operation]** We added an attempt to configure a docker-compose file to run the whole project.