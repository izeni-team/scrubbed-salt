#!jinja|yaml


{% set nginx_conf = pillar.nginx_conf|default() %}
{% set split_ends = pillar.split_ends|default() %}
{% set frontend_only = pillar.frontend_only|default() %}
{% set project_name = pillar.project_name|default('izeni') %}
{% set django_project_name = pillar.django_project_name|default(project_name) %}
{% set fqdn = pillar.fqdn|default('deploy.izeni.com') %}
{% set additional_domains = pillar.additional_domains|default([]) %}
{% set redirect_domains = pillar.redirect_domains|default([]) %}

{% if grains['os'] == 'Ubuntu' %}
nginx_ppa:
  pkgrepo.managed:
    - ppa: nginx/stable
{% endif %}

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

{% if redirect_domains %}
nginx_redirect_conf:
  file.managed:
    - name: /etc/nginx/sites-available/redirects.conf
    - source: salt://projects/nginx/redirects.conf
    - template: jinja
    - context:
      redirect_domains: "{{ redirect_domains | join(' ') }}"
      fqdn: {{ fqdn }}

nginx_redirect_symlink:
  file.symlink:
    - target: /etc/nginx/sites-available/redirects.conf
    - name: /etc/nginx/sites-enabled/redirects.conf
    - force: true
{% endif %}


{% if nginx_conf %}
nginx_conf_symlink:
  file.symlink:
    {% if not frontend_only %}
    - target: /opt/src/{{ project_name }}-backend/{{ nginx_conf }}
    {% else %}
    - target: /opt/src/{{ project_name }}-frontend/{{ nginx_conf }}
    {% endif %}
{% if grains['os'] == 'CentOS' %}
    - name: /etc/nginx/conf.d/default.conf
{% else %}
    - name: /etc/nginx/sites-available/default
{% endif %}
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
{% if grains['os'] == 'CentOS' %}
    - name: /etc/nginx/conf.d/default.conf
{% else %}
    - name: /etc/nginx/sites-available/default
{% endif %}
    {% if split_ends %}
    - source: salt://projects/nginx/split_ends.conf
    {% elif frontend_only %}
    - source: salt://projects/nginx/frontend.conf
    {% else %}
    - source: salt://projects/nginx/generic.conf
    {% endif %}
    - template: jinja
    - context:
        project_name: {{ project_name }}
        django_project_name: {{ django_project_name }}
        fqdn: {{ fqdn }}
        additional_domains: "{{ additional_domains | join(' ')}}"
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
