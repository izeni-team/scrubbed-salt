#!jinja|yaml

# Make sure we have the latest code for the revision from the git remote
# Make sure the latest pip requirements are installed


include:
  - .deploy_key

{% set project_name = pillar.project_name|default('izeni') %}
{% set frontend_git_upstream = pillar.frontend_git_upstream|default('git@dev.izeni.net:izeni/izeni-django-template.git') %}
{% set frontend_git_revision = pillar.frontend_git_revision|default('master') %}
{% set frontend_working_dir = pillar.frontend_working_dir|default('') %}
{% set frontend_env = pillar.frontend_env|default('production') %}

frontend_latest_code:
  git.latest:
    - name: {{ frontend_git_upstream }}
    - rev: {{ frontend_git_revision }}
    - target: /opt/src/frontend/
    - user: izeni
    - identity: /home/izeni/.ssh/deploy_key


# When the bower.bootstrap state is available in stable we will change the dependencies_install
# See http://docs.saltstack.com/en/develop/ref/states/all/salt.states.bower.html

dependencies_install:
  cmd.run:
    - cwd: /opt/src/frontend//{{ frontend_working_dir }}
    - user: izeni
    - shell: /bin/bash
    - name: |
        npm install && npm install gulp && bower install --config.interactive=false

build_project:
  cmd.run:
    - cwd: /opt/src/frontend/{{ frontend_working_dir }}
    - user: izeni
    - shell: /bin/bash
    - name: |
        NODE_ENV={{ frontend_env }} gulp compile

link_frontend:
  file.symlink:
    - name: /opt/frontend
    - target: /opt/src/frontend/{{ frontend_working_dir }}/bin
    - force: true
