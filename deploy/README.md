# Deployment Chart

This folder contains the helm chart used for the fully automated deployment of the Kubernetes cluster of the application.

From the `operation` folder, copy the deploy chart into the control node:

```bash
scp -r ./deploy/ vagrant@192.168.56.100:/home/vagrant/
```

Then SSH into the control node:
```bash
vagrant ssh ctrl
```

Now, within the VM, you should be able to see the deploy chart when you run the command
```bash
ls
```

If this is the case, and Helm was succesfully installed into the VM, you can deploy the Kubernetes cluster via:

```bash
helm install release deploy/
```

The expected output is:
```bash
NAME: release
LAST DEPLOYED: Mon May 19 18:14:28 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Side note about the deployment (dev notes)

All the kubernetes files are in the `/templates` folder. Helm will automatically process them and substitute the right values from `values.yaml` when the install command is run.

Important to note: if the files in the `/k8s` folder are changed, they should be updates in this chart accordingly (optionally with corresponding parameter substitution).