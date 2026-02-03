#!/usr/bin/env bash
set -e

SERVICE_NAME=demo.service

# starting a dummy service that will fail to start due to errstart

echo "starting a dummy service with typo in execstart"

sudo cp ../service.unit /etc/systemd/system/$SERVICE_NAME

sudo systemctl daemon-reload

sudo systemctl start $SERVICE_NAME || true


sudo systemctl --no-pager status $SERVICE_NAME

