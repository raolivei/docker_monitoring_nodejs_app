#!/bin/bash

# crontab job to schedule daily emails
MAILDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
crontab -l | grep -v 'getMail.sh'  | crontab -
crontab -l | { cat; echo "00     12       *       *       *       $MAILDIR/getMail.sh"; } | crontab -