#!jinja|yaml

{% set webpack = pillar.webpack|default(False) %}

{% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}
curl:
  pkg.installed

# Pulls init script that fixes ppas / uninstalls lea ppa
node_setup:
  cmd.run:
    - name: | 
        curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    - require:
      - pkg: curl

node-ppa:
  pkgrepo.managed:
    #- ppa: chris-lea/node.js
    {% if grains['os'] == 'Ubuntu' %}
    - name: deb https://deb.nodesource.com/node_6.x trusty main
    {% else %}
    - name: deb https://deb.nodesource.com/node_6.x jessie main
    {% endif %}
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - require:
      - cmd: node_setup
{% endif %}


prerequisites:
  pkg.installed:
    - reload: true
    - pkgs:
      - nodejs
      #- notify-osd
      #- libnotify-bin

install_frontend_tools:
  npm.installed:
    - pkgs:
{% if webpack %}
      - webpack
{% else %}
      - gulp
      - bower
{% endif %}
