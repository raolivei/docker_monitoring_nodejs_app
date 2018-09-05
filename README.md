docker_monitoring_nodejs_app
====================

Solution built for Docker to monitor metrics from a node.js application and send daily emails with a list requisition frequency and response code.
Services:
1. app (node.js code to cluster (load balance) node instances per CPU;
2. nginx-proxy (reverse proxy for app);
3. prometheus (metrics database);
4. cadvisor (metrics collector);
5. grafana (reports dashboard).


*Tests run on Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server), but the architecture is flexible enough to work on later Ubuntu versions.*



## Prerequisites:
Make sure that your host has connection to the internet. It is necessary for receiving daily emails (website workload)
**Ubuntu Server 18.04.1 LTS, configured with:**
* Docker Engine version 1.13 or higher
* Docker Compose version 1.21.2 or higher
* Git



## Deploy
1. Clone (or download from GitHub) this repository on your Docker host
`$ git clone https://github.com/raolivei/docker_monitoring_nodejs_app.git`

2. Go to docker_monitoring_nodejs_app directory
`$ cd  docker_monitoring_nodejs_app`

3. Run `/deploy.sh` in your shell and provide root password when asked. It will install docker, docker-compose, setup ssmtp for the daily job (first email will be sent 30 minutes after deployment time) and deploy the solution. It will do all the magic for you  :+1:
```bash
$ ./deploy.sh
```

*If you need to rebuild the containers (e.g.: image updates, configuration changes), make the necessary changes and run the following command:*
```bash
$ sudo docker-compose up --build`
```


## Stress test
In a new shell session, you can visualize the node process workload distribution individually by running this command
```bash
$ sudo docker exec -it app "top | grep /usr/local/bin/node"`
```
In a new shell session, run the commands below to start a utility that will generate requests to nginx proxy ports **80** and **443**

```bash
$ sudo docker run --rm --network=dockermonitoringnodejsapp_container-net --name=wrk_stressTest williamyeh/wrk -t9 -c10 -d30s -H 'Host: docker_host' --timeout 5s https://nginx-proxy:443
```
```bash
$ sudo docker run --rm --network=dockermonitoringnodejsapp_container-net --name=wrk_stressTest williamyeh/wrk -t9 -c10 -d30s -H 'Host: docker_host' --timeout 5s http://nginx-proxy:80
```
It is also possible to stress test the app itself on port 3000

```bash
sudo docker run --rm --network=dockermonitoringnodejsapp_container-net --name=wrk_stressTest williamyeh/wrk -t9 -c10 -d30s -H 'Host: docker_host' --timeout 5s http://app:3000
```

### Monitoring
You can monitor the workload results by accessing Grafana dashboard 'containers-monitor':
http://localhost:2000/dashboard/db/containers-monitor

The last two graphs refer to network input/output. It is also interesting to monitor memory and cpu usage.



## Daily email notification

Make sure Docker host (where ssmtp package resides) has connection to the internet.

**ssmtp.conf**<br />
This file contains the ssmtp server configuration. SSMTP is installed in the docker host by the `deploy.sh` script.
Use this configuration file to add/change smtp server address and account credentials.

**cronJob.sh**<br />
Cron is going to send daily emails at a pre-defined time of 30 minutes after the first deployment.<br />
To change hours/minutes of the daily job, change the variables `Min` and `Hour` inside ``cronJob.sh``:

```bash
#Define hours and minutes for the daily job
Min=$(date --date='30 minutes' +%M)
Hour=$(date --date='30 minutes' +%H)
...
```


## List of Containers
* app ``http://localhost:3000``
* nginx-proxy ``http://localhost:80`` ; ``https://localhost:443``
* Prometheus (metrics database) ``http://localhost:9090``
* cAdvisor (containers metrics collector) ``http://localhost:7070``
* Grafana (visualize metrics) ``http://localhost:2000``

*The list of running containers can be seen by running* `$ sudo docker ps`

### app:
- listens for port 3000, this port is mirrored to your docker host;
- prints "Hello world!" and the number of CPUS in the docker host (Obs.: Number of CPUs  might be limited in *Docker preferences->Advanced menu*);
- it has a cluster configured that is going to create one node instance per CPU;

### nginx-proxy:
- configured to reverse proxy app container. It is going to redirect both HTTP and HTTPS requests 
- for HTTP requests: `http://localhost:80`
- for HTTPS requests: `https://localhost:443`
You should see the "Hello World" message followed by the number of CPUs.

### Prometheus:
- it has its database configured to store metrics collected from cadvisor
- Raw metrics can be inspected by visiting ``http://localhost:9090/metrics/``<br />
*All data from Prometheus is persistent as docker volumes were specified in docker-compose.yml.*


### cAdvisor:
- cadvisor is configured to collect metrics from all containers and store them on prometheus database.
- cadvisor metrics can be seen in Grafana dashboard.
- cadvisor service uses port 8080 but it is mapped to port 7070 on the docker Host.
- To access cadvisor, simply go to `localhost:7070`


### Grafana:
- Grafana dashboard is configured with metric graphs for monitoring.
- Navigate to `http://<host-ip>:2000` and login with user **admin** password **admin**. You can change the credentials in either the compose file or by supplying the `ADMIN_USER` and `ADMIN_PASSWORD` environment variables on compose up.
```bash
$ ADMIN_USER=admin ADMIN_PASSWORD=admin docker-compose up`
```

Grafana is preconfigured with dashboards and **'prometheus'** as the default data source:
```bashName: prometheus
Type: Prometheus
Url: http://prometheus:9090
Access: proxy
basicAuth: false
```

*All data from Grafana is persistent as docker volumes were specified in docker-compose.yml.*



## Grafana metrics:
### container-monitor Dashboard
URL: http://localhost:2000/dashboard/db/containers-monitor

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

![containers-monitor](https://github.com/raolivei/docker_monitoring_nodejs_app/blob/master/grafana/dashboard-printscreen.png)
