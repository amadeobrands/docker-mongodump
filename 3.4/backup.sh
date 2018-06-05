#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"

mkdir -p dump

args=(
  --host "$MONGO_HOST"
  --username "$MONGO_USERNAME"
  --password "$MONGO_PASSWORD"
  --db "$MONGO_DB"
)
if [[ -v MONGO_SSL ]]; then
    args+=(--ssl)
fi

mongodump "${args[@]}"
tar -zcvf $FILE dump/
rm -rf dump/

echo "Job finished: $(date)"
