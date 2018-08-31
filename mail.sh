#!/bin/bash

echo "Subject: Daily app-website report" > mail.txt
echo "" >> mail.txt
echo "Hello World from Docker Host!, The lines beelow have the data you want:" >> mail.txt
echo "" >> mail.txt
sudo docker exec -t nginx-proxy  awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn >> mail.txt
sudo cat mail.txt | /usr/sbin/sendmail rafa.oliveira1@gmail.com