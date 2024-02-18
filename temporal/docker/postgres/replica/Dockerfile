FROM postgres:16-alpine

COPY pg_hba.conf /etc/postgresql/pg_hba.conf
COPY postgresql.conf /etc/postgresql/postgresql.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY init_scripts/* /docker-entrypoint-initdb.d/

ENTRYPOINT ["/docker-entrypoint.sh"]
