# docker-entrypoint.sh
#!/bin/sh
ntfy serve &
sleep 2
NTFY_PASSWORD=${NTFY_ADMIN_PASSWORD} ntfy user add --role=admin ${NTFY_ADMIN_USER}
wait
