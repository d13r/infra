#!/usr/bin/env bash
set -euo pipefail

for service in apache2; do
    if [[ -f "/usr/lib/systemd/system/$service.service" ]]; then
        echo 'Reloading $service...'
        systemctl reload "$service"
        systemctl status "$service"
    else
        echo "$service is not configured."
    fi
done
