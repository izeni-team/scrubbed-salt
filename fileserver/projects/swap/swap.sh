#!/bin/bash
set -e

[ -f /var/salt-swap ] || dd if=/dev/zero of=/var/salt-swap bs=1M count=512
chmod 0600 /var/salt-swap
mkswap /var/salt-swap
swapon -a
