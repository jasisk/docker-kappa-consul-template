#!/bin/ash

[ -f /tmp/kappa.pid ] && PID=$(cat /tmp/kappa.pid)

if [ ! -z ${PID} ]; then
  kill $PID;
  wait $PID;
fi

kappa -c /opt/kappa/config.json &
echo $! > /tmp/kappa.pid
