lynx_challenge_docker_app
====================

Solution built with Docker. Services:

1. app (node.js code to cluster (load balance) node instances per CPU;
2. nginx-proxy (reverse proxy for app);
3. iperf 
4. prometheus (metrics database);
5. cadvisor (metrics collector);
6. grafana (reports dashboard).

Tests run on Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server), but the architecture is flexible enough to work on later Ubuntu versions.

## Prerequisites:

* Docker Engine version 1.13
* Docker Compose version 1.21.2
Make sure that your host has connection to the internet.


***
ssmtp.conf = This file contains the ssmtp server configuration. SSMTP is installed in the docker host by the `deploy.sh` script.
Use this configuration file to add/change smtp server address and account credentials.

*** Alternatively, you can opt to deploy it manually by executing the `deploy.sh` steps in your shell. This solution is intended to work in either Ubuntu or macOS. ***




## Install

1. Open your Terminal and leverage your access:
`$ sudo su`

2. Clone (or download from GitHub website) this repository on your Docker host and go to XXXXXX directory
```bash
$ git clone https://github.com/raolivei/XXXXXX
$ cd  xxxxxxxx/
```
3. Run the XXXX script to start the deployment.
```bash
$ ./SCRIPT.sh
```
The script is going to install docker and docker-compose to your machine.

## Build the containers and start the application:
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

### iperf3
This container was written to test maximum network throughput.
`docker run --name=XXXXXX -it -p 5201:5201/tcp -p 5201:5201/udp IMAGE/NAME`
<<<<<<< HEAD

### Prometheus:
- it has its database configured to store metrics collected from cadvisor
- Raw metrics can be inspected by visiting ``http://localhost:9090/metrics/``
*All data from Prometheus is persistent as docker volumes were specified in docker-compose.yml.*


### cAdvisor:
- cadvisor is configured to collect metrics from all containers and store them on prometheus database


### Grafana:
- Grafana dashboard is configured with metric graphs for monitoring.
- Navigate to `http://<host-ip>:2020` and login with user **admin** password **admin**. You can change the credentials in the compose file or by supplying the `ADMIN_USER` and `ADMIN_PASSWORD` environment variables on compose up (see Install instructions).

=======

### Prometheus:
- it has its database configured to store metrics collected from cadvisor
- Raw metrics can be inspected by visiting ``http://localhost:9090/metrics/``
*All data from Prometheus is persistent as docker volumes were specified in docker-compose.yml.*


### cAdvisor:
- cadvisor is configured to collect metrics from all containers and store them on prometheus database


### Grafana:
- Grafana dashboard is configured with metric graphs for monitoring.
- Navigate to `http://<host-ip>:2020` and login with user **admin** password **admin**. You can change the credentials in the compose file or by supplying the `ADMIN_USER` and `ADMIN_PASSWORD` environment variables on compose up (see Install instructions).

>>>>>>> origin/master
-----
Stress test:
Em uma nova sessão do shell, vizualise o worload dos processos node
`$ docker exec -it app "top | grep /usr/local/bin/node`"

Em uma nova sessao do shell, utilize o seguinte utilitário para gerar load nos nodes:
`˜/wrk-master$ ./wrk -t12 -c400 -d30s https://localhost:443`
`˜/wrk-master$ ./wrk -t12 -c400 -d30s http://localhost:80`


### EMAIL ####
docker exec -it nginx-proxy 

access log: /etc/nginx/logs/access.log

get data: awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn

get data: docker exec -it nginx-proxy awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn

start job: docker exec -it nginx-proxy echo "This is the body of the email" | mail -s "This is the subject line" rafa.oliveira1@gmail.com

SEND EMAIL: docker exec -it nginx-proxy awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn | mail rafa.oliveira1@gmail.com


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

### services-monitor Dashboard


- prometheus Uptime: (time() - process_start_time_seconds{instance="localhost:9090",job="prometheus"})
- Memory Usage: sum(container_memory_usage_bytes)
- In-Memory Chunks: prometheus_tsdb_head_chunks
- In-Memory Series: prometheus_tsdb_head_series
- Container CPU Usage: sum(rate(container_cpu_user_seconds_total[1m]) * 100  / scalar(count(machine_cpu_cores))) by (name)
- Container Memory Usage: sum(container_memory_usage_bytes) by (name)
- Chunks to persist: Data Source (default)
- Persistence Urgency: Data Source (default)
- Chunk ops: Data Source (default)
- Checkpoint duration: Data Source (default)
- Prometheus Engine Query Duration 5m rate: rate(prometheus_engine_query_duration_seconds[5m])
- Target Scrapes: rate(prometheus_target_interval_length_seconds_count[5m])
- Scrape Duration: prometheus_target_interval_length_seconds{quantile!="0.01", quantile!="0.05"}
- HTTP Requests: sum(irate(http_request_total[1m]))
- Alerts: Data Source (default)

![services-monitor](https://github.com/raolivei/perfdata-monitor-app/blob/master/grafana-screens/services-monitor.png)
