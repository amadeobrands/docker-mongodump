#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"

mkdir -p dump
mongodump -h $MONGO_HOST --ssl \
  --username $MONGO_USERNAME --password $MONGO_PASSWORD \
  --authenticationDatabase admin
tar -zcvf $FILE dump/
rm -rf dump/

echo "Job finished: $(date)"
