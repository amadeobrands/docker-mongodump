#!/bin/bash

set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
export MONGO_HOST=${MONGO_HOST:-mongo}
export MONGO_PORT=${MONGO_PORT:-27017}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="MONGO_HOST='$MONGO_HOST'"
    CRON_ENV="$CRON_ENV\nMONGO_PORT='$MONGO_PORT'"
    CRON_ENV="$CRON_ENV\nMONGO_USERNAME='$MONGO_USERNAME'"
    CRON_ENV="$CRON_ENV\nMONGO_PASSWORD='$MONGO_PASSWORD'"
    CRON_ENV="$CRON_ENV\nMONGO_DB='$MONGO_DB'"
    CRON_ENV="$CRON_ENV\nPARAMS='$PARAMS'"
    CRON_ENV="$CRON_ENV\nS3_PATH='$S3_PATH'"
    if [[ -v MONGO_SSL ]]; then
      CRON_ENV="$CRON_ENV\nMONGO_SSL='$MONGO_SSL'"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi
