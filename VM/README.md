# File structure
All virtual machine setups are in the folder `./VM`, where you can see `Vagrantfile`. This is also the working directory for the vagrant commands that will be introduced below.

Inside `./provisioning`, you can find `general.yaml`, which works for all VMs, `ctrl.yaml`, which works for the controller only, and `node.yaml`, which works for the nodes.


# Steps

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
**Only when you see the three nodes are all running, go to the next step.**

3. (Optional) To verify the setup, you can ssh into the control mode of the VM using 
```bash
vagrant ssh <name>
```
where `<name> = ctrl / node-1 / node-2 `. The command for quiting ssh mode is `exit`.

4. If you modify the ansible files (the `yaml` files under `./provisioning`), you don't need to reload VM, just run:
```bash
vagrant provision
```
There you will see the running output of all the defined tasks.

5. (Optional) While you're working, you can use the following commands:
```bash
vagrant reload
vagrant suspend
vagrant resume
```

6. To finalize the cluster setup, run the following command from the `./VM` folder:
```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

7. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Note: this means next time you need to build the VMs from scratch, which takes time.

8. Copy the k8s setting from local to vm:
```bash
scp ./k8s/app.yaml ./k8s/model.yaml vagrant@192.168.56.100:/home/vagrant/
```

9. Generate the k8s SECRET:
```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=GITHUB_USERNAME \
  --docker-password=GHCR_PAT \
  --docker-email=your@email.com
```

10. Lemon's note:
```bash
vagrant@ctrl:~/model-service$ kubectl get pods -w
NAME                                    READY   STATUS    RESTARTS   AGE
team18-app-575598cb84-m99t4             1/1     Running   0          15m
team18-model-service-7789876bf7-gwwxz   1/1     Running   0          72s
^Cvagrant@ctrl:~/model-service$ kubectl get services
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes             ClusterIP   10.96.0.1       <none>        443/TCP          39m
team18-app             NodePort    10.100.5.251    <none>        4200:30001/TCP   26m
team18-model-service   ClusterIP   10.103.48.115   <none>        5050/TCP         26m
vagrant@ctrl:~/model-service$ kubectl get nodes -o wide
NAME     STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
ctrl     Ready    control-plane   39m   v1.32.4   192.168.56.100   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.24
node-1   Ready    <none>          37m   v1.32.4   192.168.56.101   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.24
node-2   Ready    <none>          35m   v1.32.4   192.168.56.102   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.24
```

So you can access the app using `http://192.168.56.100:30001/`.