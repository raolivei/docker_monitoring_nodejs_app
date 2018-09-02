#!/bin/sh

echo "Subject: Daily app-website report" > mail.txt
echo "" >> mail.txt
echo "Este é um relatório simples que mostra a frequência das requisições no website e o respectivo código de resposta  :" >> mail.txt
echo "" >> mail.txt
echo "Frequencia | Código de resposta" >> mail.txt
sudo docker exec -t nginx-proxy  awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn >> mail.txt
cat mail.txt | /usr/sbin/sendmail rafa.oliveira1@gmail.com
