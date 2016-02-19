#!/bin/ash
set -e

if [ "$1" = 'consul-template' ]; then
    CONSUL_CONNECT=${CONSUL_CONNECT:-172.17.0.1:8500}

    chown -R kappa:kappa /opt/kappa/ /data/consul-template
    shift
    exec gosu kappa consul-template \
         -config=/data/consul-template/config.d \
         -consul=${CONSUL_CONNECT} "$@"
fi

exec "$@"
