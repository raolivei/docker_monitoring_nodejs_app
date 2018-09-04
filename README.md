docker_monitoring_nodejs_app
====================

Solution built with Docker. Services:
app (node.js code to cluster (load balance) node instances per CPUl;
nginx-proxy (reverse proxy for app);
prometheus (metrics database);
cadvisor (metrics collector);
grafana (reports dashboard).

Tests run on Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server), but the architecture is flexible enough to work on later Ubuntu versions and MacOS.


## deploy.sh
Run `$ ./deploy.sh` in your shell and provide root password when asked. It will install the prerequisites, setup the daily job and deploy the solution. It will do all the magic for you.

Alternativelly, you can deploy manually by following the lines below.

## Prerequisites:
Make sure that your host has connection to the internet. It is necessary for receiving daily emails (website workload)
* Ubuntu Server 18.04.1 LTS, configured with:
** Docker Engine version 1.13 or higher
** Docker Compose version 1.21.2 or higher
** Git
** ssmtp


## Install

1. Open your Terminal and leverage your access:
`$ sudo su`

2. Clone (or download from GitHub) this repository on your Docker host
`$ git clone https://github.com/raolivei/port-listener-app`

3. Go to port-listener-app directory
$ `cd  port-listener-app`

4. Run the `deploy.sh` script to start the deployment.
```bash
$ ./deploy.sh
```
The script is going to:
1. Install docker, docker-compose, git and SSMTP to your machine;

## Build (re-build) the containers and start the application:
`docker-compose up --build`


=======

## List of Containers
* app ``http://localhost:3000``
* nginx-proxy ``http://localhost:80`` ; ``https://localhost:443``
* iperf3 XXXX
* Prometheus (metrics database) ``http://localhost:9090``
* cAdvisor (containers metrics collector) ``http://localhost:7070``
* Grafana (visualize metrics) ``http://localhost:2020``


### app:
- listens for port 3000, this port is mirrored to your docker host;
- prints "Hello world!" and the number of CPUS in the docker host (CPU number might be limited in Docker preferences->Advanced menu);
- it has a cluster configured that is going to create one node instance per CPU;

### nginx-proxy:
- configured to reverse proxy app container. It is going to redirect both HTTP and HTTPS requests 
- for HTTP requests: `http://localhost:80`
- for HTTPS requests: `https://localhost:443`
You should see the "Hello World" message followed by the number of CPUs.

### Prometheus:
- it has its database configured to store metrics collected from cadvisor
- Raw metrics can be inspected by visiting ``http://localhost:9090/metrics/``
*All data from Prometheus is persistent as docker volumes were specified in docker-compose.yml.*


### cAdvisor:
- cadvisor is configured to collect metrics from all containers and store them on prometheus database


### Grafana:
- Grafana dashboard is configured with metric graphs for monitoring.
- Navigate to `http://<host-ip>:2020` and login with user **admin** password **admin**. You can change the credentials in the compose file or by supplying the `ADMIN_USER` and `ADMIN_PASSWORD` environment variables on compose up (see Install instructions).

-----
Stress test:
In a new shell session, you can vizualize the node process workload distribution individually by running this command
`$ docker exec -it app "top | grep /usr/local/bin/node`"

In a new shell session, run the commands below to start a utility that will generate requests to nginx proxy ports 80 and 443:
`$ docker run --rm --network=docker_monitoring_nodejs_app_container-net --anme=wrk_stress williamyeh/wrk -t9 -c10 -d30s -H 'Host: docker_host' --timeout 5s http://nginx-proxy:443/ `

`$ docker run --rm --network=docker_monitoring_nodejs_app_container-net --anme=wrk_stress williamyeh/wrk -t9 -c10 -d30s -H 'Host: docker_host' --timeout 5s http://nginx-proxy:80/ `

It is also possible to stress test the app itself on port 3000:
`docker run --rm --network=chaordic_container-net  williamyeh/wrk -t9 -c10 -d30s -H 'Host: localhost' --timeout 5s http://app:3000/`

Monitoring:
You can monitor the workload results by accessing Grafana dashboard 'containers-monitor':
http://localhost:2000/dashboard/db/containers-monitor

The last two graphs refer to network input/output. It is also interesting to monitor memory and cpu usage.


### EMAIL ####

Make sure Docker host (where SSMTP should reside) has connection to the internet.

***
ssmtp.conf = This file contains the ssmtp server configuration. SSMTP is installed in the docker host by the `deploy.sh` script.
Use this configuration file to add/change smtp server address and account credentials.

*** Alternatively, you can opt to deploy it manually by executing the `deploy.sh` steps in your shell. This solution is intended to work in either Ubuntu or macOS. ***


### crontab.sh
Cron is going to send daily emails at 1 PM by default.
To change hours/minutes of the daily job, change the variables `Min` and `Hour` inside ``crontab.sh``:
`#Define hours and minutes for the daily job
Min="00"
Hour="13"
...`


## Grafana metrics:
### container-monitor Dashboard

- CPU Load: sum(rate(container_cpu_user_seconds_total{image!=""}[1m])) / count(machine_cpu_cores) * 100
- CPU Cores: machine_cpu_cores
- Memory load: sum((go_memstats_frees_total)/(go_memstats_alloc_bytes_total))*1000
- Used Memory: sum(container_memory_usage_bytes{image!=""})
- Storage Load: sum((container_fs_inodes_free)/(container_fs_inodes_total))
- Used Storage: sum(container_fs_usage_bytes)
- Running Containers: scalar(count(container_memory_usage_bytes{image!=""}) > 0)
- File System Load: sum(container_fs_inodes_free/container_fs_inodes_total)*10
- I/O Usage: sum(irate(container_fs_reads_bytes_total[5m])); sum(irate(container_fs_writes_bytes_total[5m])); sum(irate(container_fs_io_time_seconds_total[5m]))
- Container CPU Usage: sum by (name) (rate(container_cpu_usage_seconds_total{image!=""}[1m])) / scalar(count(machine_cpu_cores)) * 100
- Container Memory Usage: sum by (name)(container_memory_usage_bytes{image!=""})
- Container Cached Memory Usage: sum by (name) (container_memory_cache{image!=""})
- Container Network Input: sum by (name) (rate(container_network_receive_bytes_total{image!=""}[1m]))
- Container Network Output: sum by (name) (rate(container_network_transmit_bytes_total{image!=""}[1m]))

![containers-monitor](https://github.com/raolivei/perfdata-monitor-app/blob/master/grafana-screens/containers-monitor.png)
