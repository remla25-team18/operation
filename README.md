# REMLA Group Project | Group 18



## How to Run the Project

### Assignment 3 – Kubernetes Deployment & Monitoring

#### ✨ Step 1: Boot the VMs

Navigate to the project VM folder and start the virtual machines:

```bash
cd VM
chmod +x create-keys.sh # make sure the create-keys.sh script is executable
./create-keys.sh        # create the ssh keys for the VMs
vagrant up              # create the VMs and provision them
```

#### ⚙️ Step 2: Configure the Cluster with Ansible

Run the provisioning scripts from your host:

```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/cluster-configuration.yml
```

#### 🔐 Step 3: Access the Cluster via SSH

Forward Prometheus port and connect:

```bash
ssh -L 9090:localhost:9090 vagrant@192.168.56.100
```

#### 📃 Step 4: Create Secret for GitHub Container Registry

Replace placeholders with your credentials:

```bash
kubectl create secret docker-registry ghcr-secret \
--docker-server=ghcr.io \
--docker-username=GITHUB_USERNAME \
--docker-password=GHCR_PAT \
--docker-email=you@example.com
```

This allows Kubernetes to pull your app and model images.

#### 🔄 Step 5: Validate Pods and Services

Run the following to ensure all pods and services are active:

```bash
kubectl get pods
kubectl get services
kubectl get nodes -o wide
```

#### 📊 Step 6: Install Prometheus + Grafana via Helm

Install monitoring stack into the cluster:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

Check the pod status:

```bash
kubectl get pods -n monitoring
```

#### 🔹 Step 7: Access Prometheus

Forward Prometheus UI port:

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

Visit [http://localhost:9090](http://localhost:9090) in your browser.

### Assignment 2 – VM Infrastructure & Cluster Setup

1. Navigate to the VM folder:

   ```bash
   cd VM
   ```

2. Boot the VMs:

   ```bash
   vagrant up
   ```

3. Verify VM status:

   ```bash
   vagrant status
   ```

   You should see:

   ```
   ctrl     running (virtualbox)
   node-1   running (virtualbox)
   node-2   running (virtualbox)
   ```

4. Provision the cluster:

   ```bash
   ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
   ```

5. Destroy the environment when done:

   ```bash
   vagrant destroy -f
   ```

> ⚠️ Note: Destroying removes all VMs. Rebuilding them will take time.

### Assignment 1 – Docker Compose Operation

Run the full project stack locally using Docker Compose:

```bash
cd operation
docker-compose up
```

Then open:
[http://127.0.0.1:4200](http://127.0.0.1:4200)

> ℹ️ Check the terminal output to confirm the actual port.

![Docker Port Output](Assets/docker_port.png)

---

## 📂 Repositories

| Repository                                                         | Description                                                                    |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| [operation](https://github.com/remla25-team18/operation)           | Coordinates model versioning, execution instructions, and Docker Compose.      |
| [app](https://github.com/remla25-team18/app)                       | Flask web app (frontend + backend) to interact with model and gather feedback. |
| [model-service](https://github.com/remla25-team18/model-service)   | REST API that hosts the sentiment analysis model.                              |
| [model-training](https://github.com/remla25-team18/model-training) | Training pipeline that generates and versions the model.                       |
| [lib-ml](https://github.com/remla2)                                | Shared ML preprocessing utilities. Used in training and service.               |
| [lib-version](https://github.com/remla25-team18/lib-version)       | Library to manage and expose software version.                                 |

---

## 📅 Progress Log

### Assignment 3

* **Kubernetes:** Deployed app and model-service using manifests.
* **Monitoring:** App exposes multiple metrics (counters, gauges) auto-scraped via ServiceMonitor.
* **Helm:** Helm chart used to manage Prometheus and Grafana.
* **Grafana:** Not yet integrated.

### Assignment 2

* **Infrastructure:** Vagrant + Ansible used to provision 1 control-plane and 2 worker nodes.
* **Idempotent Provisioning:** Ansible tasks use conditionals, variables, and loops for robust automation.

### Assignment 1

* **Docker Compose:** Project is runnable via a single `docker-compose up` command.
* **Versioning:** Pre-release versioning system with GitHub Actions.
* **Modular Libraries:** `lib-ml` and `lib-version` reused across multiple services.
* **REST APIs:** Clear, OpenAPI-based HTTP endpoints used for model inference and app communication.
