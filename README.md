# port-listener-app
<<<<<<< HEAD
## Extract this project

## Leverage your access:
`sudo su`
## Install docker-compose in your machine:
`apt install docker-compose`

## Build the containers and start the application:
`docker-compose up --build`
=======
>>>>>>> 26c003bf2740960f07632e6b5097cf68dee6556d




Stress test: 
Em uma nova sessão do shell, vizualise o worload dos processos node
`$ docker exec -it port-listener top | grep /usr/local/bin/node`

Em uma nova sessao do shell, utilize o seguinte utilitário para gerar load nos nodes:
`˜/wrk-master$ ./wrk -t12 -c400 -d30s https://localhost:443`
`˜/wrk-master$ ./wrk -t12 -c400 -d30s http://localhost:80`

<<pictures>>