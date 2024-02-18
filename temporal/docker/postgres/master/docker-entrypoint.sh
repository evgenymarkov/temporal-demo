#!/usr/bin/env bash
set -e

check_variables() {
    if [ -z ${POSTGRES_PORT+x} ]; then
        echo "Variable POSTGRES_PORT is not set"
        exit 1
    fi
}

replace_variables() {
    sed -i "s/\$POSTGRES_PORT/$POSTGRES_PORT/g" /etc/postgresql/postgresql.conf
}

main() {
    check_variables
    replace_variables

    exec docker-entrypoint.sh "$@"
}

main "$@"
