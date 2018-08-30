FROM nginx:1.15-alpine

# Add edge repo for Alpine - it contains mailutils
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing mailutils

# Intall SSMTP MAILUTILS
RUN apk update && apk add -q ssmtp mailutils

# Copy ssmtp configuration file
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

COPY mail-script.sh mail-script.sh
RUN chmod +x mail-script.sh
#RUN mail-script.sh | tee output.txt | mail -s "Access log" rafa.oliveira1@gmail.com


RUN crontab -l | { cat; echo "34     21       *       *       *       mail-script.sh"; } | crontab -
