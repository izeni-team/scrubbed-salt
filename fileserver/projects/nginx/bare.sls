#!jinja|yaml


{% set nginx_conf = pillar.nginx_conf|default() %}
{% set split_ends = pillar.split_ends|default() %}
{% set frontend_only = pillar.frontend_only|default() %}
{% set project_name = pillar.project_name|default('izeni') %}
{% set django_project_name = pillar.django_project_name|default(project_name) %}
{% set fqdn = pillar.fqdn|default('deploy.izeni.com') %}

nginx_ppa:
  pkgrepo.managed:
    - ppa: nginx/stable

nginx_installed:
  pkg.latest:
    - name: nginx
    - refresh: true


webroot_dir:
  file.directory:
    - name: /opt/webroot
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data


nginx_conf_symlink:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - name: /etc/nginx/sites-enabled/default
    - force: true

nginx_conf_generic:
  file.managed:
    - name: /etc/nginx/sites-available/default
    - source: salt://projects/nginx/bare.conf
    - template: jinja

nginx_running:
  service.running:
    - name: nginx
    - enable: true
    - reload: true

nginx_restart:
  cmd.run:
    - name: service nginx restart
    - user: root
