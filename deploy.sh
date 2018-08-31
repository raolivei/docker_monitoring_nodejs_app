# script for the docker host Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server)
#!/bin/bash

sudo apt-get update

# Clone git repositry
sudo apt-get -y install git

# sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install docker.io
sudo apt-get -y install docker-compose

sudo usermod -aG docker $USER


# sudo apt-get -y install ssmtp <- I don't need, as I am using nginx-proxy
# sudo apt-get -q ssmtp mailutils; # it was failing...

git clone https://github.com/raolivei/port-listener-app.git

cd port-listener-app/

chmod +x *

# copy ssmtp configuration to Docker Host's address
# cp /mail/ssmtp.conf /etc/ssmtp/ssmtp.conf


# Schedule daily email job
# ./mail/crontab.sh

sudo docker-compose up --build
