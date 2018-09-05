#!/bin/bash

DESTINATION_PATH=/home/user/Desktop/docker_monitoring_nodejs_app/mail
echo "Subject: CARAAAAI" > $DESTINATION_PATH/mail.txt
echo "" >> $DESTINATION_PATH/mail.txt
echo "Este é um relatório simples que mostra a frequência das requisições no website e o respectivo código de resposta  :" >> $DESTINATION_PATH/mail.txt
echo "" >> $DESTINATION_PATH/mail.txt
echo "Frequencia | Código de resposta" >> $DESTINATION_PATH/mail.txt
sudo docker exec -t nginx-proxy  awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn >> $DESTINATION_PATH/mail.txt
cat $DESTINATION_PATH/mail.txt | /usr/sbin/sendmail rafa.oliveira1@gmail.com