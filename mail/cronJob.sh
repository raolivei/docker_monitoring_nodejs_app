#!/bin/bash

#Define hours and minutes for the daily job
Min=$(date --date='10 minutes' +%M)
Hour=$(date --date='10 minutes' +%H)

# crontab job to schedule daily emails
MAILDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
crontab -l | grep -v 'getMail.sh'  | crontab -
crontab -l | { cat; echo "$Min     $Hour       *       *       *       $MAILDIR/getMail.sh"; } | crontab -



# We could use the daily folder instead
#crontab -l | { cat; echo "$Min     $Hour       *       *       *       /etc/cron.daily/getMail.sh"; } | crontab -
