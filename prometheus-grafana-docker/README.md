## Scenario: Prometheus Stack
This scenario deploys a Prometheus Stack consisting of Prometheus, Grafana, and Alertmanager. It uses Docker Compose to orchestrate the services.

### Tools Used
- Docker and Compose
- Prometheus, Grafana, and Alertmanager
- AWS EC2
- A makefile and linux Swap


### Goal
 Set up Prometheus and Grafana on an ec2 instance to monitor and observe the server components usage and application performance.

### tasks
1. Create and connect an EC2 instance and install Docker and Docker Compose.
2. configure promtheus, alertmanager in a yml file ""check at prometheus.yaml file in the folder""
3. create a docker compose file including the images for prometheus, node-exporter, alertmanager and hook up the various config files.
4. run the makefile to swap the ec2 ip the app to run
5. Access the Grafana dashboard and add Prometheus as a data source.
6. Create a dashboard in Grafana to visualize the metrics collected by Prometheus.
7. Grafana might not show the metrics .. configure it in the settings by setting a variable name to DB_PRMOETHEUS
8. ** Set up alerting rules in Prometheus and configure Alertmanager to send notifications to your email or Slack.**
