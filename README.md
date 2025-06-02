# REMLA Group Project – Group 18

This project implements a complete MLOps pipeline using Docker, Kubernetes, Helm, and Prometheus/Grafana. It features a restaurant sentiment analysis model served via REST APIs and deployed using container orchestration tools.

## 📚 Table of Contents

- [REMLA Group Project – Group 18](#remla-group-project--group-18)
  - [📚 Table of Contents](#-table-of-contents)
  - [📌 Overview of Components](#-overview-of-components)
  - [🚀 Running the Application](#-running-the-application)
    - [🔪 Assignment 1 – Local Development with Docker Compose](#-assignment-1--local-development-with-docker-compose)
    - [⚙️ Assignment 2 – Provisioning Kubernetes Cluster (Vagrant + Ansible)](#️-assignment-2--provisioning-kubernetes-cluster-vagrant--ansible)
      - [1. Boot the Virtual Machines](#1-boot-the-virtual-machines)
      - [2. Provision the Cluster](#2-provision-the-cluster)
      - [3. Create Container Registry Secret](#3-create-container-registry-secret)
      - [4. Apply the Kubernetes Configuration](#4-apply-the-kubernetes-configuration)
      - [5. Access Kubernetes Dashboard](#5-access-kubernetes-dashboard)
    - [☕️ Assignment 3 – Kubernetes Deployment \& Monitoring](#️-assignment-3--kubernetes-deployment--monitoring)
      - [1. Install Helm Chart \[Skip fo now\]](#1-install-helm-chart-skip-fo-now)
      - [3. Validate the Deployment](#3-validate-the-deployment)
      - [4. Monitoring Setup (Prometheus + Grafana)](#4-monitoring-setup-prometheus--grafana)
        - [Visit in host machine](#visit-in-host-machine)
  - [📊 App Monitoring](#-app-monitoring)
  - [📁 File Structure](#-file-structure)
  - [🗓️ Progress Log](#️-progress-log)
    - [✅ Assignment 1](#-assignment-1)
    - [✅ Assignment 2](#-assignment-2)
    - [✅ Assignment 3](#-assignment-3)
    - [✅ Assignment 4](#-assignment-4)
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

### 🔪 Assignment 1 – Local Development with Docker Compose

1. Navigate to the `operation` repository:

   ```bash
   cd operation
   docker-compose up
   ```

2. Open the app:

   [http://127.0.0.1:4200](http://127.0.0.1:4200)

> Docker Compose launches the entire stack: frontend, app backend, and model-service.

---

### ⚙️ Assignment 2 – Provisioning Kubernetes Cluster (Vagrant + Ansible)

#### 1. Boot the Virtual Machines

Make sure you have Vagrant and VirtualBox installed. Navigate to the `VM` directory in the `operation` repository:


If you have run the project and have the ssh keys already created, you can directly run `vagrant up` to start the VMs.
 If you haven't created the keys yet, run the following commands:
```bash
cd VM
chmod +x create-keys.sh
./create-keys.sh
vagrant up
```

> This creates 1 controller (192.168.56.100) and 2 workers (192.168.56.101+).

#### 2. Provision the Cluster

```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

> Use `vagrant ssh <name>` (e.g., ctrl, node-1) to access individual VMs.
> 
#### 3. Create Container Registry Secret

To allow Kubernetes to pull images from GitHub Container Registry (GHCR), create a secret with your GitHub credentials. After connecting to the controller VM using `vagrant ssh ctrl`, run the following command: 

**Replace the paramater with your own info.**

```bash
kubectl create secret docker-registry ghcr-secret \
--docker-server=ghcr.io \
--docker-username=GITHUB_USERNAME \
--docker-password=GHCR_PAT \
--docker-email=you@example.com
```

#### 4. Apply the Kubernetes Configuration

Under the `operation/VM` directory, run the following command to apply the Kubernetes configuration:

```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/cluster-configuration.yml
```


#### 5. Access Kubernetes Dashboard

1. Open: `https://192.168.56.90/` on your host machine.
2. In the ssh terminal, run this to get the token:

   ```bash
   kubectl -n kubernetes-dashboard create token admin-user
   ```
3. Copy the token and paste it into the dashboard login page, you should be able to see the app and model-service pods running.

---

### ☕️ Assignment 3 – Kubernetes Deployment & Monitoring

#### 1. Install Helm Chart [Skip fo now]

> **⚠️ Lemon's note: Not verified, will modify in the future, skip this whole step now!!!**
> 
In the root directory ('operation'), copy the chart:
```bash
cd ..
scp -r ./helm/ vagrant@192.168.56.100:/home/vagrant/
```

Then deploy the chart:

```bash
cd VM
vagrant ssh ctrl
helm install release helm/
```


#### 3. Validate the Deployment

```bash
vagrant ssh ctrl
kubectl get pods
kubectl get services
kubectl get ingress
```

#### 4. Monitoring Setup (Prometheus + Grafana)

Install the monitoring stack:

Open a new terminal, use the command to access the VM using SSH:

```bash
ssh -L 3000:localhost:3000 -L 9090:localhost:9090 vagrant@192.168.56.100
```

Inside the ssh terminal, run

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

**After installing Prometheus, you need to reapply the kubernetes configuration again. Use the terminal on the local host and make sure you're under `operation/VM`, run `ansible-playbook -u vagrant -i 192.168.56.100, provisioning/cluster-configuration.yml` again.**

Then you can check the status of the Prometheus using:

```bash
kubectl get servicemonitor -n monitoring
```

You should see the `team18-app-servicemonitor` listed, indicating that Prometheus is set to scrape metrics from the app services.

Make sure you exit ssh and enter again (using the first command of this forth step), so the changes are reflected, when you do the following commands:

```bash
# Forward Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090

# In a separate terminal (or backgrounded process)
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```

##### Visit in host machine

* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)
* Default credentials: `admin/prom-operator`

> Custom app-specific metrics (counters, gauges) are auto-scraped by Prometheus via `ServiceMonitor`.
> Grafana dashboards are defined in JSON files (see `helm/grafana/team18-dashboard.json`), import manually through:

1. Access Grafana at <http://localhost:3000>
2. Go to Dashboards > Import
3. Upload `dashboards/team18-dashboard.json`
4. Click Import

---

## 📊 App Monitoring

The app exposes Prometheus metrics such as:

**TODO**
* `app_request_count` (Counter)
<!-- * `prediction_duration_seconds` (Histogram)
* `user_feedback_score` (Gauge) -->

A `ServiceMonitor` is used for automatic metric discovery.

---

### Assignment 5 - Istio Service Mesh

#### 🚦 Rate Limiting via Istio

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
for i in {1..15}; do curl -s -o /dev/null -w "%{http_code}\n" http://192.168.56.90/; done
```

The first 10 requests should return a `200 - OK` response.
After the 10th request, subsequent responses should return a `429 - Too Many Requests` error.


## 📁 File Structure

To be reorganized.

---

## 🗓️ Progress Log

### ✅ Assignment 1

* Docker Compose setup with modular app and model.
* Versioned model, reusable libraries (`lib-ml`, `lib-version`).

### ✅ Assignment 2

* Cluster provisioned via Vagrant + Ansible.
* All tasks are idempotent and modular.

### ✅ Assignment 3

* Kubernetes deployment via Helm.
* Monitoring with Prometheus and Grafana.
* Exposes custom metrics and dashboards.


### ✅ Assignment 4

* Automated Tests
* Continuous Training
* Project Organization
* Pipeline Management with DVC
* Code Quality: Pylint has a non-standard configuration and one custom rule for the ML code smell Randomness Uncontrolled. The project additionally applies flake8 and bandit, which have a non-default configuration. All three linters are automatically run as part of the GitHub workflow

---

## 🧠 Notes

* Do **not** store secrets in source files. Use Kubernetes `Secrets`.
* Helm charts should support custom values and be re-installable.
* Use `--kubeconfig` or set `KUBECONFIG` to interact with your cluster from host.