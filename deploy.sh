# script for the docker host Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server)
#!/bin/bash

echo "Enter the email address to receive daily emails:"
read EmailAddress
echo $EmailAddress > mail/EmailAddress.txt

sudo apt-get update

# sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install docker.io
sudo apt-get -y install docker-compose

sudo usermod -aG docker $USER


sudo chmod -R +x *

# install ssmtp as email sender
sudo apt install -y ssmtp

# copy ssmtp configuration to Docker Host's address
sudo cp mail/ssmtp.conf /etc/ssmtp/ssmtp.conf


# Schedule daily email job
./mail/cronJob.sh

# Deploy docker_monitoring_nodejs_app
sudo docker-compose up --build
