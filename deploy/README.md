# Deployment Chart

This folder contains the helm chart used for the fully automated deployment of the Kubernetes cluster of the application.

Ensure you have helm installed, navigate to the `/deploy` folder,  and run:

```bash
helm install release .
```

All the kubernetes files are in the `/templates` folder. Helm will automatically process them and substitute the right values from `values.yaml` when the install command is run.

Important to note: if the files in the `/k8s` folder are changed, they should be updates in this chart accordingly (optionally with value substitution).