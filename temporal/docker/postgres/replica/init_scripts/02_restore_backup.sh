#!/usr/bin/env bash
set -e

PGPASSWORD="$REPLICATION_PASSWORD" pg_basebackup \
    --host "$REPLICATION_MASTER_HOST" \
    --port "$REPLICATION_MASTER_PORT" \
    --username "$REPLICATION_USER" \
    --no-password \
    --pgdata "$PGDATA" \
    --slot "$REPLICATION_SLOT_NAME" \
    --format p \
    --wal-method stream \
    --write-recovery-conf \
    --progress
