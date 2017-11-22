#!jinja|yaml

include:
  - .deploy_key


{% set project_name = pillar.project_name|default('izeni') %}
{% set frontend_git_upstream = pillar.frontend_git_upstream|default('git@dev.izeni.net:izeni/izeni-django-template.git') %}
{% set frontend_git_revision = pillar.frontend_git_revision|default('master') %}
{% set frontend_working_dir = pillar.frontend_working_dir|default('') %}
{% set frontend_env = pillar.frontend_env|default('production') %}


{% if not grains['os'] == 'CentOS' %}
frontend_latest_code:
  git.latest:
    - name: {{ frontend_git_upstream }}
    - rev: {{ frontend_git_revision }}
    - target: /opt/src/{{ project_name }}-frontend/
    - user: izeni
    - identity: /home/izeni/.ssh/deploy_key
{% endif %}

webpack:
  npm.installed: []

dependencies_install:
  cmd.wait:
    - cwd: /opt/src/{{ project_name }}-frontend//{{ frontend_working_dir }}
    - user: izeni
    - shell: /bin/bash
    - name: |
        npm install
{% if not grains['os'] == 'CentOS' %}
    - watch:
      - git: frontend_latest_code
{% endif %}

build_project:
  cmd.run:
    - cwd: /opt/src/{{ project_name }}-frontend/{{ frontend_working_dir }}
    - user: izeni
    - shell: /bin/bash
    - name: |
        NODE_ENV={{ frontend_env }} webpack --bail

link_frontend:
  file.symlink:
    - name: /opt/frontend
    - target: /opt/src/{{ project_name }}-frontend/{{ frontend_working_dir }}/build
    - force: true
