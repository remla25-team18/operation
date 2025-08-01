# REMLA Group Project – Group 18

This project implements a complete MLOps pipeline using Docker, Kubernetes, Helm, and Prometheus/Grafana. It features a restaurant sentiment analysis model served via REST APIs and deployed using container orchestration tools.

## 📚 Table of Contents

- [REMLA Group Project – Group 18](#remla-group-project--group-18)
  - [📚 Table of Contents](#-table-of-contents)
  - [📌 Overview of Components](#-overview-of-components)
  - [🚀 Running the Application](#-running-the-application)
    - [🔪 Assignment 1](#-assignment-1)
      - [Local Development with Docker Compose](#local-development-with-docker-compose)
      - [Using Docker Secrets in Swarm(Optional)](#using-docker-secrets-in-swarmoptional)
    - [⚙️ Assignment 2 – Provisioning Kubernetes Cluster (Vagrant + Ansible)](#️-assignment-2--provisioning-kubernetes-cluster-vagrant--ansible)
      - [1. Boot the Virtual Machines](#1-boot-the-virtual-machines)
      - [2. Create Container Registry Secret](#2-create-container-registry-secret)
      - [3. Create a self-signed certificate for the cluster](#3-create-a-self-signed-certificate-for-the-cluster)
      - [4. Apply Kubernetes Configuration](#4-apply-kubernetes-configuration)
      - [5. Add Hostnames to `/etc/hosts`](#5-add-hostnames-to-etchosts)
    - [☕️ Assignment 3 – Kubernetes Deployment \& Monitoring](#️-assignment-3--kubernetes-deployment--monitoring)
    - [Kubernetes Deployment](#kubernetes-deployment)
      - [Using Ansible Playbook](#using-ansible-playbook)
      - [Using Helm](#using-helm)
      - [1. Deploy the Kubernetes Cluster via Helm](#1-deploy-the-kubernetes-cluster-via-helm)
      - [🧩 Multiple Installations from the Same Chart (Optional)](#-multiple-installations-from-the-same-chart-optional)
        - [How to Install](#how-to-install)
        - [How to Uninstall](#how-to-uninstall)
      - [2. Validate the Deployment](#2-validate-the-deployment)
    - [App Monitoring (Prometheus + Grafana)](#app-monitoring-prometheus--grafana)
    - [:car: Assignment 5 – Traffic Management](#car-assignment-5--traffic-management)
      - [Continuous Experimentation](#continuous-experimentation)
      - [Traffic Management](#traffic-management)
      - [1. Installing Istio and necessary CRDs](#1-installing-istio-and-necessary-crds)
      - [2. Deploying the Application with Istio](#2-deploying-the-application-with-istio)
      - [3. 🚦 Rate Limiting via Istio](#3--rate-limiting-via-istio)
        - [✅ Rate Limiting Details](#-rate-limiting-details)
        - [🧪 How to Test](#-how-to-test)
  - [📁 File Structure](#-file-structure)
  - [🗓️ Progress Log](#️-progress-log)
    - [✅ Assignment 1](#-assignment-1-1)
    - [✅ Assignment 2](#-assignment-2)
    - [✅ Assignment 3](#-assignment-3)
    - [✅ Assignment 4](#-assignment-4)
    - [✅ Assignment 5](#-assignment-5)
  - [🧠 Notes](#-notes)

---

## 📌 Overview of Components

| Repository                                                         | Description                                                            |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------- |
| [operation](https://github.com/remla25-team18/operation)           | Contains deployment orchestration (Docker Compose, Kubernetes, Helm).  |
| [app](https://github.com/remla25-team18/app)                       | Flask web app (frontend + backend) interacting with the model-service. |
| [model-service](https://github.com/remla25-team18/model-service)   | REST API serving the trained ML model.                                 |
| [model-training](https://github.com/remla25-team18/model-training) | Pipeline for training and versioning sentiment analysis models.        |
| [lib-ml](https://github.com/remla25-team18/lib-ml)                 | Preprocessing utilities used in training and inference.                |
| [lib-version](https://github.com/remla25-team18/lib-version)       | Lightweight utility for exposing software version metadata.            |

---

## 🚀 Running the Application

### 🔪 Assignment 1
#### Local Development with Docker Compose

1. Make sure you're inside the `operation` repository and run the following commands to start the Docker Compose setup:

   ```bash
   docker-compose up
   ```
   If you see an error of *unsupported external secret api_key*, ignore it as it is related to Docker Swarm secrets which are used in later setup.

2. Open the app through the web at:  [http://127.0.0.1:4200](http://127.0.0.1:4200)

3. When you're done testing, stop the containers:

   ```bash
   docker-compose down
   ```

> Docker Compose launches the entire stack: frontend, app backend, and model-service.

#### Using Docker Secrets in Swarm(Optional)
Docker secrets are used to securely manage sensitive configuration such as API keys.

1. Make sure Docker Swarm is initialized:

    ```bash
    docker swarm init
    ```

2. Create a Secret

    ```bash
    echo "your-api-key-value" | docker secret create api_key -
    ```

3. Deploy the Stack
    Secrets are referenced in docker-stack.yml. Deploy with exporting the environment variables first and then running the stack:

    ```bash
    set -o allexport
    source .env
    set +o allexport

    docker stack deploy -c docker-compose.yml mystack

    ```

4. Clean Up

    To remove the stack:
    ```bash
    docker stack rm mystack
    ```

    To leave Swarm:
    ```bash
    docker swarm leave --force
    ```
> Docker Swarm provides native clustering and orchestration, allowing users to securely deploy, scale, and manage multi-container applications across multiple hosts with built-in load balancing and secret management.

#### 🔄 Automatic Versioning and Releases

This repository uses [GitVersion](https://gitversion.net/) together with GitHub Actions to automatically handle semantic versioning and release tagging. 

Here's roughly how it works:

1. The Release workflow runs automatically on every push to the main branch (except when pushed by github-actions[bot] itself).

2. GitVersion computes the next version based on commit history, branch configuration, and optionally special commit messages.

3. The computed version is:
    - Stored in a VERSION file (for visibility and allowing version-awareness)

    - Used to tag the repository with a GitHub Release

    - Automatically generates release notes

4. After releasing, the workflow bumps the next-version in GitVersion.yml to prepare for the next cycle.

##### 📌 Default Behavior

By default, pushes to main increment the patch version (e.g. 0.2.7 becomes 0.2.8), and the next version is set as a **pre-release** (e.g. `0.2.9-pre`) as configured in `GitVersion.yml`. This helps indicate that the current state is still under development.

If you want to make a **stable release**, simply edit `GitVersion.yml` and remove the `-pre` suffix from the `next-version` field before merging or pushing to main. This will cause the next release to be tagged as a stable version (e.g. `0.2.9`).

If you want to manually control the version bump (for features or breaking changes), you can include special markers in your commit messages:

##### 📝 How to Control Version Bumps

Use the following +semver: tags in your commit messages to instruct GitVersion:
| Marker           | Result                        | Example Commit Message                                      |
|------------------|-------------------------------|-------------------------------------------------------------|
| `+semver: patch` | Increment patch (x.y.z+1)     | `Fix null pointer in parser [+semver: patch]`              |
| `+semver: minor` | Increment minor (x.y+1.0)     | `Add new user settings feature [+semver: minor]`           |
| `+semver: major` | Increment major (x+1.0.0)     | `Refactor API breaking compatibility [+semver: major]`     |

These markers can be placed anywhere in the commit message, and they take precedence over the default Patch increment.

---

### ⚙️ Assignment 2 – Provisioning Kubernetes Cluster (Vagrant + Ansible)

#### 1. Boot the Virtual Machines

Make sure you have Vagrant and VirtualBox installed. Navigate to the `VM` directory in the `operation` repository:

If you haven't created the keys yet, run the following commands:
```bash
cd VM
chmod +x create-keys.sh
./create-keys.sh
vagrant up
```

If you have run the project and have the ssh keys already created, you can directly run `vagrant up` to start the VMs, this creates 1 controller (192.168.56.100) and 2 workers (192.168.56.101/192.168.56.102).

> Note: If you want to track the time cost for provisioning, you can run the following command:

```bash
vagrant up --no-provision
time vagrant provision
```

You will see the time it takes to provision the VMs, which is around 5 minutes, the log will be like this:

```plaintext
vagrant provision  12.56s user 6.53s system 8% cpu 3:42.87 total
```


#### 2. Create Container Registry Secret

To allow Kubernetes to pull images from GitHub Container Registry (GHCR), create a secret with your GitHub credentials. After connecting to the controller VM using `vagrant ssh ctrl`, run the following command: 

**Replace the parameter with your own info.**

```bash
kubectl create secret docker-registry ghcr-secret \
--docker-server=ghcr.io \
--docker-username=GITHUB_USERNAME \
--docker-password=GHCR_PAT \
--docker-email=you@example.com
```

#### 3. Create a self-signed certificate for the cluster

Now go back to your host machine, under the `operation/VM` directory. The below command will at first create a self-signed certificate for the cluster.

```bash
chmod +x create-certificate.sh
./create-certificate.sh
```

#### 4. Apply Kubernetes Configuration
Under the `operation/VM` directory, run the command below. It will apply the Kubernetes configuration using Ansible.

```bash
bash run_playbook.sh
```

You will see the following tips:
```plaintext
Choose a playbook to run:
[Press enter] Full provisioning
1) Cluster Configuration
2) Finalization
3) Istio Installation
Press enter or choose [1-3] (any other character to abort):
```

By default (if you just press enter), it will run the full provisioning (finalization and istio) which is recommended for the first time. If you want to run only one of them, you can enter the number corresponding to the playbook you want to run. 

#### 5. Add Hostnames to `/etc/hosts`
To access the application and dashboard via friendly domain names, run the following command in your terminal:

```bash
echo "192.168.56.90 team18.local team18.k8s.dashboard.local" | sudo tee -a /etc/hosts > /dev/null
```

To verify, try these commands:
```bash
ping team18.local
ping team18.k8s.dashboard.local
```

---

### ☕️ Assignment 3 – Kubernetes Deployment & Monitoring

This can be done two ways:
- Method A) Using Ansible Playbook: in which case, proceed with the instructions that follow.
- Method B) Using Helm: skip to the "Using Helm" section 

### Kubernetes Deployment

#### Using Ansible Playbook

Under the `operation/VM` directory, run the command below, choosing the option `1` to apply the cluster configuration.

```bash
bash run_playbook.sh
```

You will see the following tips:
```plaintext
Choose a playbook to run:
[Press enter] Full provisioning
1) Cluster Configuration
2) Finalization
3) Istio Installation
Press enter or choose [1-3] (any other character to abort):
```

After this step, you should have a fully functional Kubernetes cluster with the necessary configurations applied.

Try `curl -k https://team18.local` to check if the cluster is up, running and the certificate is valid.

Skip to "App Monitoring (Prometheus + Grafana)" section.

#### Using Helm

#### 1. Deploy the Kubernetes Cluster via Helm
Now, you can deploy the application using Helm. Continue in the VM terminal:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
helm install team18 ./helm/
```

The output should look like this:

```bash
I0606 15:05:32.820209   37158 warnings.go:110] "Warning: EnvoyFilter exposes internal implementation details that may change at any time. Prefer other APIs if possible, and exercise extreme caution, especially around upgrades."
NAME: team18
LAST DEPLOYED: Fri Jun  6 15:05:32 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

#### 🧩 Multiple Installations from the Same Chart (Optional)

This chart supports multiple independent installations in the same cluster. Each installation is isolated by release name using Helm’s built-in `.Release.Name` variable, which is injected into resource names (e.g., `release1-app`, `release1-app-config`, etc.).

##### How to Install 

You can install the chart multiple times like this:

```bash
helm install release1 ./helm/
helm install release2 ./helm/
```
Each release will deploy its own isolated set of resources without naming conflicts.

> **Note:** To prevent Ingress rule collisions, the release name is also included in the Ingress hostname. For example, the default release name uses `team18.local`, while a custom release like `release1` will use `release1.local`.

##### How to Uninstall
To uninstall a release, simply run `helm uninstall <release-name>`. For example:

```bash
helm uninstall release1
helm uninstall release2
```

#### 2. Validate the Deployment

Once deployed, verify that everything is running:

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```
Or you can do this using Kubernetes Dashboard, which is accessible at [https://team18.k8s.dashboard.local](https://team18.k8s.dashboard.local/) on your host machine.

In the ssh terminal of ctrl, run this to get the token:

   ```bash
   kubectl -n kubernetes-dashboard create token admin-user
   ```
Copy the token and paste it into the dashboard login page, you should be able to see the app and model-service pods running.

### App Monitoring (Prometheus + Grafana)

Open a new terminal and connect to the VM via SSH:

```bash
ssh -L 3000:localhost:3000 -L 9090:localhost:9090 vagrant@192.168.56.100
```

Inside the ctrl VM, add the Helm repo and install the monitoring stack:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

If you are deploying with the Ansible playbook `run_playbook.sh` option `1`, you need to rerun it.

Now you can check the status of the Prometheus using:

```bash
kubectl get servicemonitor -n monitoring
```

You should see the `team18-app-servicemonitor` listed (perhaps as the last one in the list). This indicates that Prometheus is set to scrape metrics from the app services.

To access Prometheus, run:
```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

To access Grafana, run, in a **separate terminal**:
```bash
cd operation/VM
ssh -L 3000:localhost:3000 -L 9090:localhost:9090 vagrant@192.168.56.100
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```

Then open your browser and visit the following URLs:

* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)
  * Use the default grafana credentials: user `admin` and password `prom-operator`.

Now you should see the dashboard called **team18** automatically loaded in Grafana, which contains the following panels. 

> Custom app-specific metrics (counters, gauges) are auto-scraped by Prometheus via `ServiceMonitor`, you can view different versions of the app by querying `duration_validation_req`, you should see the different versions of the app in the `version` label like:
> 
  ```plaintext
  duration_validation_req{container="team18-app", endpoint="metrics", instance="10.244.2.3:4200", job="team18-app", namespace="default", pod="team18-app-v2-6464889d88-prbqp", service="team18-app", version="v1.0"}	
  duration_validation_req{container="team18-app", endpoint="metrics", instance="10.244.1.2:4200", job="team18-app", namespace="default", pod="team18-app-v1-65b8cf7b-kfznc", service="team18-app", version="v2.0"}
  ```

---

### :car: Assignment 5 – Traffic Management


#### Continuous Experimentation

Add `192.168.56.90 team18.local` at the end of your local `etc/hosts` file, for the app to be accessible in https://team18.local/.

Please refer to `docs/continuous-experimentation.md` for the documentation about the experiment.

#### Traffic Management

#### 1. Installing Istio and necessary CRDs

This step should be already done by the Ansible playbooks you ran in the previous step. Ensure you have run the following commands from your host machine:

```bash
cd VM
echo Installing Istio and necessary CRDs
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

To check that everything is installed correctly, run the following command:

```bash
vagrant ssh ctrl 
istioctl version
kubectl get pods -n istio-system
```
You should get this:
```plaintext
vagrant@ctrl:~$ istioctl version
client version: 1.25.2
control plane version: 1.25.2
data plane version: 1.25.2 (2 proxies)

vagrant@ctrl:~$ kubectl get pods -n istio-system
NAME                                   READY   STATUS    RESTARTS   AGE
istio-egressgateway-8547bd8df7-qs4k4   1/1     Running   0          39m
istio-ingressgateway-d6c84fd47-dt2m4   1/1     Running   0          39m
istiod-77c5b4fdc8-lnkrv                1/1     Running   0          39m
```

#### 2. Deploying the Application with Istio
This step should also be done by now with the right Ansible playbook executed. Again, ensure you have ran the following commands from your host machine:

```bash
cd VM
echo Deploying the application with Istio
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/cluster-configuration.yml
```

We deployed 2 versions of the app, `team18-app-v1` and `team18-app-v2` with 80-20 traffic split between them. You can check the status of the pods and services using:

```bash
vagrant ssh ctrl
kubectl get pods
kubectl get services
```
You should see both versions of the app running, like this:

```plaintext
vagrant@ctrl:~$ kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
team18-app-v1-db78d66c8-qkqs9           2/2     Running   0          20m
team18-app-v2-fbf5b5994-xcs5s           2/2     Running   0          20m
team18-model-service-6bd5979755-7zf8g   1/1     Running   0          4h7m

vagrant@ctrl:~$ kubectl get services
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kubernetes             ClusterIP   10.96.0.1      <none>        443/TCP    4h42m
team18-app             ClusterIP   10.99.168.89   <none>        80/TCP     21m
team18-model-service   ClusterIP   10.106.15.34   <none>        5050/TCP   4h30m
```

To verify the custom routing, you can execute the command below. You should see `v1` appear 8 times and `v2` appear 2 times, indicating the 80-20 traffic split.

```bash
for i in {1..10}; do                                                        
  curl -s -k http://192.168.56.91/metrics -H "Host: team18.local"
done
```

We also implemented sticky sessions for the app, so that users will always be directed to the same version of the app they started with when there is a special header in their request. Check it by running the following commands!

```bash 
curl -k http://192.168.56.91/metrics -H "Host: team18.local" -H "experiment: v1"
curl -k http://192.168.56.92/metrics -H "Host: team18.local" -H "experiment: v2"
```
When you do requests to specific versions, you should see the version appear as part of the hist_duration_pred_req metric, like this:

```plaintext
hist_duration_pred_req{le="0.1", version="v1.0"} 0 # for v1
```

#### 3. 🚦 Rate Limiting via Istio

This project implements request throttling using **Istio’s local rate limiting** feature, enforced at the Istio ingress gateway.

##### ✅ Rate Limiting Details

- **Limit**: 10 requests per minute  
- **Scope**: Per client connection (typically per IP)  
- **Status Code on Limit**: `429 Too Many Requests`  
- **Implementation**: Istio `EnvoyFilter` (configured in `istio-rate-limit.yaml`)

##### 🧪 How to Test

You can test the rate limit feature in a new terminal using `curl` like so:

<!-- This assumes the MetalLB LoadBalancer IP is not changed since the moment of writing this -->
<!-- This command sends 15 http requests in silent mode, outputting only the HTTP respnonse headers -->

```bash
for i in {1..15}; do
  curl -s -o /dev/null -w "%{http_code}\n" http://192.168.56.91/
done
```

The first 10 requests should return a `200 - OK` response.
After the 10th request, subsequent responses should return a `429 - Too Many Requests` error.
