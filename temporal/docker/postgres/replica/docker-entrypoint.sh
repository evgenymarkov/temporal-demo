#!/usr/bin/env bash
set -e

check_variables() {
    if [ -z ${POSTGRES_DB+x} ]; then
        echo "Variable POSTGRES_DB is not set"
        exit 1
    fi

    if [ -z ${POSTGRES_TEST_DB+x} ]; then
        echo "Variable POSTGRES_TEST_DB is not set"
        exit 1
    fi

    if [ -z ${POSTGRES_PORT+x} ]; then
        echo "Variable POSTGRES_PORT is not set"
        exit 1
    fi

    if [ -z ${REPLICATION_USER+x} ]; then
        echo "Variable REPLICATION_USER is not set"
        exit 1
    fi

    if [ -z ${REPLICATION_PASSWORD+x} ]; then
        echo "Variable REPLICATION_PASSWORD is not set"
        exit 1
    fi

    if [ -z ${REPLICATION_SLOT_NAME+x} ]; then
        echo "Variable REPLICATION_SLOT_NAME is not set"
        exit 1
    fi

    if [ -z ${REPLICATION_MASTER_HOST+x} ]; then
        echo "Variable REPLICATION_MASTER_HOST is not set"
        exit 1
    fi

    if [ -z ${REPLICATION_MASTER_PORT+x} ]; then
        echo "Variable REPLICATION_MASTER_PORT is not set"
        exit 1
    fi
}

replace_variables() {
    sed -i "s/\$POSTGRES_PORT/$POSTGRES_PORT/g" /etc/postgresql/postgresql.conf
}

create_db_directories() {
    mkdir -p "$PGDATA"
    chmod 700 "$PGDATA"

    mkdir -p /var/run/postgresql
    chmod 775 /var/run/postgresql

    find "$PGDATA" \! -user postgres -exec chown postgres '{}' +
    find /var/run/postgresql \! -user postgres -exec chown postgres '{}' +
}

main() {
    if [ "$(id -u)" = '0' ]; then
        check_variables
        replace_variables
        create_db_directories
        exec su-exec postgres "$BASH_SOURCE" "$@"
    fi

    if [ -f "$PGDATA/PG_VERSION" ]; then
        echo 'PostgreSQL already initialized'
        /docker-entrypoint-initdb.d/01_check_master.sh
    else
        for script in /docker-entrypoint-initdb.d/*.sh; do
            "./$script"
        done

        echo 'PostgreSQL init process complete'
    fi

    exec "$@"
}

main "$@"
