# REMLA Group Project – Group 18

This project implements a complete MLOps pipeline using Docker, Kubernetes, Helm, and Prometheus/Grafana. It features a restaurant sentiment analysis model served via REST APIs and deployed using container orchestration tools.

## 📚 Table of Contents

* [📌 Overview of Components](#-overview-of-components)
* [🚀 Running the Application](#-running-the-application)
  * [🔪 Assignment 1 – Local Development with Docker Compose](#-assignment-1--local-development-with-docker-compose)
  * [⚙️ Assignment 2 – Provisioning Kubernetes Cluster (Vagrant + Ansible)](#-assignment-2--provisioning-kubernetes-cluster-vagrant--ansible)
  * [☕️ Assignment 3 – Kubernetes Deployment & Monitoring](#-assignment-3--kubernetes-deployment--monitoring)
* [📊 App Monitoring](#-app-monitoring)
* [📁 File Structure](#-file-structure)
* [🗓️ Progress Log](#-progress-log)
* [🧠 Notes](#-notes)

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
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/cluster-configuration.yml
```

> Use `vagrant ssh <name>` (e.g., ctrl, node-1) to access individual VMs.

#### 3. Access Kubernetes Dashboard

1. Open: `https://192.168.56.90/`
2. Get the token:

   ```bash
   vagrant ssh ctrl
   kubectl -n kubernetes-dashboard create token admin-user
   ```

---

### ☕️ Assignment 3 – Kubernetes Deployment & Monitoring

Continue from the previous step after provisioning the cluster.

#### 1. Install Helm Chart

Copy and deploy the chart:

```bash
scp -r ./deploy/ vagrant@192.168.56.100:/home/vagrant/
vagrant ssh ctrl
helm install release deploy/
```

> Helm auto-injects values from `values.yaml` into Kubernetes manifests.

#### 2. Create Container Registry Secret

```bash
kubectl create secret docker-registry ghcr-secret \
--docker-server=ghcr.io \
--docker-username=GITHUB_USERNAME \
--docker-password=GHCR_PAT \
--docker-email=you@example.com
```

#### 3. Validate the Deployment

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

#### 4. Monitoring Setup (Prometheus + Grafana)

Install the monitoring stack:

Open a new terminal, use the command to access the VM:

```bash
ssh -L 3000:localhost:3000 -L 9090:localhost:9090 vagrant@192.168.56.100
```

Inside the VM, run

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

You can check the status of the Prometheus using:

```bash
kubectl get servicemonitor -n monitoring
```

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
> Grafana dashboards are defined in JSON files (see `grafana/team18-dashboard.json`), import manually through:

##### Grafana Dashboard

To import the custom dashboard:

1. Access Grafana at <http://localhost:3000>
2. Go to Dashboards > Import
3. Upload `dashboards/team18-dashboard.json`
4. Click Import

---

## 📊 App Monitoring

The app exposes Prometheus metrics such as:

* `app_request_count` (Counter)
* `prediction_duration_seconds` (Histogram)
* `user_feedback_score` (Gauge)

A `ServiceMonitor` is used for automatic metric discovery.

---

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

---

## 🧠 Notes

* Do **not** store secrets in source files. Use Kubernetes `Secrets`.
* Helm charts should support custom values and be re-installable.
* Use `--kubeconfig` or set `KUBECONFIG` to interact with your cluster from host.
