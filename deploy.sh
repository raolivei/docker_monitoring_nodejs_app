# script for the docker host Ubuntu Server 18.04.1 LTS (https://www.ubuntu.com/download/server)
#!/bin/bash

sudo apt-get update

# Clone git repositry
sudo apt-get -y install git

sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install docker.io
sudo apt-get -y install docker-compose

sudo usermod -aG docker $USER


sudo apt -y install ssmtp
# sudo apt-get -q ssmtp mailutils; # it was failing...

cp ssmtp.conf /etc/ssmtp/ssmtp.conf

git clone https://github.com/raolivei/port-listener-app.git

cd port-listener-app/

sudo docker-compose up --build


chmod +x mail.sh

# add cron job to send daily emails, first line is to delete existing jobs, change date/time in cron format from the second line
crontab -l | grep -v 'mail-script.sh'  | crontab -
crontab -l | { cat; echo "10     21       *       *       *       mail.sh"; } | crontab -
