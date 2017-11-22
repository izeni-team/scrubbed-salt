#!jinja|yaml

{% set project_name = pillar.project_name|default('izeni') %}
{% set python_bin = pillar.python_bin|default('/usr/bin/python') %}
{% set django_settings_module = pillar.django_settings_module|default(pillar.project_name + '.settings.production') %}
{% set python_path = pillar.python_path|default('') %}
{% set frontend_env = pillar.frontend_env|default() %}
{% set project_envs = pillar.project_envs|default({}) %}
{% set additional_domains = pillar.additional_domains|default([]) %}

{% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}
# Installing from Ubuntu repos is actually kind of nice
virtualenvwrapper_installed:
  pkg.installed:
    - name: virtualenvwrapper
{% elif grains['os'] == 'CentOS' %}

virtualenvwrapper_installed:
  pip.installed:
    - name: virtualenvwrapper

{% endif %}
# Update pip to use pip's pip
pip_latest:
  pip.installed:
    - name: pip
    - upgrade: True


project_venv:
  virtualenv.managed:
    - name: /opt/virtualenvs/{{ project_name }}
    - cwd: /opt/src/{{ project_name }}-backend/
    - python: {{ python_bin }}
    - user: izeni

project_file:
  file.managed:
    - name: /opt/virtualenvs/{{ project_name }}/.project
    - contents: /opt/src/{{ project_name }}-backend/{{ python_path }}
    - user: izeni

postactivate_config_block:
  file.managed:
    - name: /opt/virtualenvs/{{ project_name }}/bin/postactivate
    - contents: |
        export DJANGO_SETTINGS_MODULE="{{ django_settings_module }}"
        export DB_NAME={{ pillar.db_name }}
        export DB_PASS="{{ pillar.db_pass }}"
        export DB_USER={{ pillar.db_user }}
        export DB_HOST={{ pillar.db_host }}
        export FQDN="{{ pillar.fqdn }}"
        export ADDITIONAL_DOMAINS="{{ additional_domains | join(' ') }}"
        {% if frontend_env %}
        export NODE_ENV={{ frontend_env }}
        {% endif %}
        {% for key, value in project_envs.items() %}
        export {{ key }}={{ value }}
        {% endfor %}
    - user: izeni
