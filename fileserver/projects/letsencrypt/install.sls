# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "projects/letsencrypt/map.jinja" import letsencrypt with context %}

letsencrypt-client-git:
  git.latest:
    - name: https://github.com/certbot/certbot
    - target: {{ letsencrypt.cli_install_dir }}
