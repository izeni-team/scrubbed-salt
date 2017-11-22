#!jinja|yaml


{% set nginx_conf = pillar.nginx_conf|default() %}
{% set split_ends = pillar.split_ends|default() %}
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


{% if nginx_conf %}
nginx_conf_symlink:
  file.symlink:
    - target: {{ nginx_conf }}
    - name: /etc/nginx/sites-enabled/default
    - force: true
    - makedirs: true
{% else %}
nginx_conf_symlink:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - name: /etc/nginx/sites-enabled/default
    - force: true

nginx_conf_generic:
  file.managed:
    - name: /etc/nginx/sites-available/default
    {% if split_ends %}
    - source: salt://projects/nginx/split_ends.conf
    {% else %}
    - source: salt://projects/nginx/generic.conf
    {% endif %}
    - template: jinja
    - context:
        project_name: {{ project_name }}
        django_project_name: {{ django_project_name }}
        fqdn: {{ fqdn }}
{% endif %}

nginx_running:
  service.running:
    - name: nginx
    - enable: true
    - reload: true

nginx_restart:
  cmd.run:
    - name: service nginx restart
    - user: root
