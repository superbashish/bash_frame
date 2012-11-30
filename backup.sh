#!/bin/bash
tar -zcf backup_frame$( date +%F ) /var/spool/cron/crontabs/ /home/frame/ /etc/
scp backup_frame$( date +%F ) user@server:backups/
