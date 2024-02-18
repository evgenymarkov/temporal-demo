#!/usr/bin/env bash
set -e

pg_is_ready() {
    dbname=$1

    PGPASSWORD="$REPLICATION_PASSWORD" psql \
        --host "$REPLICATION_MASTER_HOST" \
        --port "$REPLICATION_MASTER_PORT" \
        --dbname "$dbname" \
        --username="$REPLICATION_USER" \
        --command "SELECT 1" \
        --no-password
}

function check_db() {
    dbname=$1
    retries=40

    until pg_is_ready "$dbname" &> /dev/null || [ $retries -eq 0 ]; do
        echo "Waiting for PostgreSQL database $dbname. Remaining number of attempts: $retries."
        retries=$((retries - 1))
        sleep 2
    done
}

check_db "$POSTGRES_DB"
check_db "$POSTGRES_TEST_DB"
