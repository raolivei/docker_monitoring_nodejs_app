#!/bin/sh  

#awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn | tee output.txt | mail -s "Access log" rafa.oliveira1@gmail.com

#awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn


#export mailbody="awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn"
echo "From: info@nginx.local" > /tmp/mail.txt
echo "To: rafa.oliveira1@gmail.com" >> mail.txt
echo "Subject: Daily app-website report" >> mail.txt
echo "" >> mail.txt
echo "Hello World from CONTAINER!" >> mail.txt
#awk '{print $9}' /etc/nginx/logs/access.log | sort | uniq -c | sort -rn >> mail.txt
cat mail.txt | sendmail rafa.oliveira1@gmail.com
