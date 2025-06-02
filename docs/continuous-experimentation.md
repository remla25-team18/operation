# Continuous Experimentation

## 1. Objective

We want to determine whether users click the buttons faster in a UI where:
- Condition A: "True" is <span style="color:green">green</span> and "False" is <span style="color:red">red</span> (conventional coloring)
- Condition B: Both buttons are <span style="color:yellow">yellow</span> (neutral coloring)

The illustration below shows the two conditions:
<div align="center">

![Condition A](../assets/version1.png)  
**Figure 1: Condition A**


![Condition B](../assets/version2.png)  
**Figure 2: Condition B**

</div> 

## 2. Hypothesis

**Users will click the buttons in Condition A faster than in Condition B.**

This is a falsifiable hypothesis and can be tested using collected interaction time metrics.

## 3. Experimental Design

- We deployed **two versions** of the application:
  - Version A: Green/Red buttons
  - Version B: Yellow/Yellow buttons
- Each version runs in a separate Kubernetes deployment.
- Both versions expose an HTTP endpoint `/metrics` that includes:
  - `duration_validation_req`: Time taken from the model sends back prediction to user clicking the feedback.

## 4. Monitoring and Visualization

In Prometheus, you can query the metric `duration_validation_req` to compare the two versions. The `version` label will indicate which version of the app the metric belongs to.

![Prometheus Query](../assets/Prometheus.png)

In Grafana, ...

**TODO**

## 5. Conclusion

**TODO**

The experiment will help us determine if the color of the buttons affects user interaction speed. By analyzing the collected metrics, we can validate or refute our hypothesis.

criteria:

dashboard support: