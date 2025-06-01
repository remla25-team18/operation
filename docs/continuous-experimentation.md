# Continuous Experimentation

## 1. Objective

We want to determine whether users click the buttons faster in a UI where:
- Condition A: "True" is <span style="color:green">green</span> and "False" is <span style="color:red">red</span> (conventional coloring)
- Condition B: Both buttons are blue (neutral coloring)

## 2. Hypothesis

**Users will click the buttons in Condition A faster than in Condition B.**

This is a falsifiable hypothesis and can be tested using collected interaction time metrics.

## 3. Experimental Design

- We deployed **two versions** of the application:
  - Version A: Green/Red buttons
  - Version B: Blue/Blue buttons
- Each version runs in a separate Kubernetes deployment.
- Both versions expose an HTTP endpoint `/metrics` that includes:
  - `button_click_duration_seconds` (histogram): Time taken from button visibility to click.

## 4. Metric Description

We expose the following Prometheus metric from both versions:

```plaintext
# HELP button_click_duration_seconds Time from rendering to button click.
# TYPE button_click_duration_seconds histogram
button_click_duration_seconds_bucket{le="0.1",version="A"} 20
button_click_duration_seconds_bucket{le="0.2",version="A"} 50
...
button_click_duration_seconds_sum{version="A"} 123.4
button_click_duration_seconds_count{version="A"} 100
