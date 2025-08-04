#!/usr/bin/env bash
set -euo pipefail

target_size=$1

if [[ -f /swap.img ]]; then
    current_size=$(stat -c %s /swap.img)
    if [[ $current_size -eq $target_size ]]; then
        exit
    fi

    echo "Removing /swap.img..."
    sed -i.bak '/^\/swap\.img\b/d' /etc/fstab
    swapoff /swap.img
    rm -f /swap.img
fi

if [[ $target_size -gt 0 ]]; then
    echo "Creating /swap.img..."
    target_size_mb=$((target_size / 1024 / 1024))
    dd if=/dev/zero of=/swap.img bs=1MiB count="$target_size_mb"
    chmod 600 /swap.img
    mkswap /swap.img
    swapon /swap.img
    echo '/swap.img none swap sw 0 0' >> /etc/fstab
fi
