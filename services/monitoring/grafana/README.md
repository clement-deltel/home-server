# Grafana

## Migration from SQLite to PostgreSQL

- Start the Grafana stack so that the PostgreSQL database can be initialized properly by Grafana:

```bash
docker compose up -d
```

- Wait for Grafana to be done with database initialization by monitor the logs:

```bash
docker logs -f grafana
```

- Exec into the grafana-postgres container

```bash
docker exec -it grafana-postgres /bin/bash
```

- Execute the below commands:

```bash
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".migration_log;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public"."user";'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".org_user;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".org;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".dashboard_acl;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".server_lock;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".kv_store;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".alert_configuration;'
psql -h localhost -p 5432 -U grafana -d grafana_db -c 'delete from "public".alert_configuration_history;'
```

- Run pgloader using the script grafana.load:

```bash
pgloader config/grafana.load
```

> Note: there should be plenty of warnings due to data type casting but no errors. Nothing to worry about.

- Restart the Grafana stack:

```bash
docker compose down -v
docker compose up -d
```
