#!/usr/bin/env bash

set -e

SERVICE_NAME=demo.service

echo "starting a dummy service that will fail to start due to bad permissions"

# service.execstart is path is changed to a false one

sudo cp ../service.unit /etc/systemd/system/$SERVICE_NAME

# sudo touch /usr/local/bin/demo-app
sudo chmod 644 /usr/local/bin/demo-app

sudo systemctl daemon-reload

sudo systemctl start $SERVICE_NAME || true

sudo systemctl --no-pager status $SERVICE_NAME