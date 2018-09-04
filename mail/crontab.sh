#!/bin/bash

#Define hours and minutes for the daily job
Min="20"
Hour="14"

# crontab job to schedule daily emails
MAILDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
crontab -l | grep -v 'getMail.sh'  | crontab -
crontab -l | { cat; echo "$Min     $Hour       *       *       *       $MAILDIR/getMail.sh"; } | crontab -