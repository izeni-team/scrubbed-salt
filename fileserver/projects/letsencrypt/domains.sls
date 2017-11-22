# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "projects/letsencrypt/map.jinja" import letsencrypt with context %}

{% for setname, domainlist in pillar['letsencrypt']['domainsets'].iteritems() %}
create-initial-cert-{{ setname }}-{{ domainlist | join('+') }}:
  cmd.run:
    - unless: ls /etc/letsencrypt/{{ domainlist | join('.check /etc/letsencrypt/') }}.check
    - name: {{ letsencrypt.cli_install_dir }}/certbot-auto -d {{ domainlist|join(' -d ') }} certonly
    - cwd: {{ letsencrypt.cli_install_dir }}
    - require:
      - file: letsencrypt-config

touch /etc/letsencrypt/{{ domainlist | join('.check /etc/letsencrypt/') }}.check:
  cmd.run:
    - unless: test -f /etc/letsencrypt/{{ domainlist | join('.check && test -f /etc/letsencrypt/') }}.check
    - require:
      - cmd: create-initial-cert-{{ setname }}-{{ domainlist | join('+') }}

letsencrypt-crontab-{{ setname }}-{{ domainlist[0] }}:
  cron.present:
    - name: '({{ letsencrypt.cli_install_dir }}/certbot-auto renew && sudo service nginx restart)'
    - month: '*'
    - minute: '0'
    - hour: '0'
    - daymonth: '1'
    - identifier: letsencrypt-{{ setname }}-{{ domainlist[0] }}
    - require:
      - cmd: create-initial-cert-{{ setname }}-{{ domainlist | join('+') }}

{% endfor %}

{% set project_name = pillar.project_name|default('izeni') %}
{% set fqdn = pillar.fqdn|default('') %}
{% if fqdn %}

legacy_cert_symlink:
  file.symlink:
    - name: /etc/pki/tls/certs/{{ fqdn }}.crt
    - target: /etc/letsencrypt/live/{{ fqdn }}/fullchain.pem
    - force: true
    - onlyif:
      - ls /etc/letsencrypt/live/{{ fqdn }}/fullchain.pem

legacy_key_symlink:
  file.symlink:
    - name: /etc/pki/tls/certs/{{ fqdn }}.key
    - target: /etc/letsencrypt/live/{{ fqdn }}/privkey.pem
    - force: true
    - onlyif:
      - ls /etc/letsencrypt/live/{{ fqdn }}/privkey.pem
{% endif %}

