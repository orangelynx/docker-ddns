#!/bin/bash

[ -z "$SHARED_SECRET" ] && echo "SHARED_SECRET not set" && exit 1;
[ -z "$ZONE" ] && echo "ZONE not set" && exit 1;
[ -z "$RECORD_TTL" ] && echo "RECORD_TTL not set" && exit 1;
[ -z "$HOSTS_FILE" ] && echo "HOSTS_FILE not set" && exit 1;

if [ ! -f /var/cache/bind/$ZONE.zone ]
then
	echo "creating zone file..."
	cat > /var/cache/bind/$ZONE.zone <<EOF
\$ORIGIN .
\$TTL 86400	; 1 day
$ZONE		IN SOA	localhost. root.localhost. (
				74         ; serial
				3600       ; refresh (1 hour)
				900        ; retry (15 minutes)
				604800     ; expire (1 week)
				86400      ; minimum (1 day)
				)
			NS	localhost.
\$ORIGIN ${ZONE}.
\$TTL ${RECORD_TTL}
EOF
fi

# If /var/cache/bind is a volume, permissions are probably not ok
chown root:bind /var/cache/bind
chown bind:bind /var/cache/bind/*
chmod 770 /var/cache/bind
chmod 644 /var/cache/bind/*

if [ ! -f /etc/dyndns.json ]
then
	echo "creating REST api config..."
	cat > /etc/dyndns.json <<EOF
{
    "SharedSecret": "${SHARED_SECRET}",
    "Server": "localhost",
    "Zone": "${ZONE}.",
    "Domain": "${ZONE}",
	"RecordTTL": ${RECORD_TTL},
	"HostsFile": "${HOSTS_FILE}",
}
EOF
fi