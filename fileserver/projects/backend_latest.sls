#!jinja|yaml

# Make sure we have the latest code for the revision from the git remote
# Make sure the latest pip requirements are installed


include:
  - .deploy_key



{% set project_name = pillar.project_name|default('izeni') %}
{% set git_upstream = pillar.git_upstream|default('git@dev.izeni.net:izeni/izeni-django-template.git') %}
{% set git_revision = pillar.git_revision|default('master') %}
{% set requirements_file = pillar.requirements_file|default('requirements.txt') %}
{% set dependencies_script = pillar.dependencies_script|default() %}



latest_code:
  git.latest:
    - name: {{ git_upstream }}
    - rev: {{ git_revision }}
    - target: /opt/src/{{ project_name }}-backend/
    - user: izeni
    - identity: /home/izeni/.ssh/deploy_key

# We don't want to log to files here but some copies of the django template we have do
temp_log_directory:
  file.directory:
    - name: /opt/src/{{ project_name }}-backend/logs/
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data
    - recurse:
      - user
      - group
      - mode

#latest_requirements:
#  pip.installed:
#    - requirements: /opt/src/{{ project_name }}-backend/{{ requirements_file }}
#    - bin_env: /opt/virtualenvs/{{ project_name }}
#    - use_wheel: true
#    - find_links: http://office.izeni.net/flexshare/pywheel/ubuntu12_04/
#    - allow_all_external: true
#    - allow_unverified: all
#    - require:
#      - git: latest_code

{% if dependencies_script %}
dependencies_script:
  cmd.wait:
    - name: |
        sh /opt/src/{{ project_name }}-backend/{{ dependencies_script }}
    - watch:
      - git: latest_code
{% endif %}

latest_requirements:
  cmd.wait:
    - user: izeni
    - shell: /bin/bash
    - name: |
        source /opt/virtualenvs/{{ project_name }}/bin/activate
        eval `ssh-agent -s`
        ssh-add /home/izeni/.ssh/deploy_key
        pip install --use-wheel \
        --find-links=http://office.izeni.net/flexshare/pywheel/ubuntu12_04/ \
        --requirement /opt/src/{{ project_name }}-backend/{{ requirements_file }} \
        #--trusted-host office.izeni.net
    - watch:
      - git: latest_code
