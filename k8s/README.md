# Setup Kubernetes Cluster

1. **Make sure now you're under /operation**, and then you have vagrant booted by running:
    ```bash
    cd /VM
    vagrant up
    ```
    then connect to the VM using SSH:
    ```bash
    vagrant ssh ctrl
    ```


2. **In another local terminal under /operation**, Copy the k8s setting from local to vm:

    > *Lemon's note: I'm not so sure how we can use the local file directly, this doesn't sound very reliable but it works so I'm building on it. Future exploration needed.*

    ```bash
    scp ./k8s/app.yaml ./k8s/model.yaml ./k8s/ingress.yaml ./k8s/environment.yaml ./k8s/monitoring.yaml vagrant@192.168.56.100:/home/vagrant/
    ```

    **This is the only place where you need to use this terminal. The rest of the steps will be done in the VM.**

3. Now go back to the virtual machine, which means the terminal with `vagrant@ctrl`, generate the k8s SECRET(replace the `GITHUB_USERNAME`, `GHCR_PAT`  and `your@email.com` with your own):
    ```bash
    kubectl create secret docker-registry ghcr-secret \
    --docker-server=ghcr.io \
    --docker-username=GITHUB_USERNAME \
    --docker-password=GHCR_PAT \
    --docker-email=your@email.com
    ```

4. Deploy the app and model service:
    ```bash
    kubectl apply -f app.yaml
    kubectl apply -f model.yaml
    kubectl apply -f ingress.yaml
    kubectl apply -f environment.yaml
    kubectl apply -f monitoring.yaml
    ```

    This will create the pods and services for the app and model service. You can check the status of the pods and services using ``kubectl get pods`` and ``kubectl get services`` commands. The output should look like this:
    ```bash
    vagrant@ctrl:~/model-service$ kubectl get pods -w
    NAME                                    READY   STATUS    RESTARTS   AGE
    team18-app-575598cb84-m99t4             1/1     Running   0          15m
    team18-model-service-7789876bf7-gwwxz   1/1     Running   0          72s


    vagrant@ctrl:~/model-service$ kubectl get services
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

5. **Access the app**: The app is exposed on port 30001 of the control node (
    So you can access the app using `http://192.168.56.100:30001/`).