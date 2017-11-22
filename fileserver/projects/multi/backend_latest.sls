#!jinja|yaml

# Make sure we have the latest code for the revision from the git remote
# Make sure the latest pip requirements are installed


include:
  - .deploy_key

{% for project_name, project_data in pillar.backend_projects.iteritems() %}

{% set git_upstream = project_data.git_upstream %}
{% set git_revision = project_data.git_revision|default('master') %}
{% set requirements_file = project_data.requirements_file|default('requirements.txt') %}
{% set dependencies_script = project_data.dependencies_script|default() %}

latest_code_{{ project_name }}:
  git.latest:
    - name: {{ git_upstream }}
    - rev: {{ git_revision }}
    - target: /opt/src/{{ project_name }}/
    - user: izeni
    - identity: /home/izeni/.ssh/deploy_key

# We don't want to log to files here but some copies of the django template we have do
temp_log_directory_{{ project_name }}:
  file.directory:
    - name: /opt/src/{{ project_name }}/logs/
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
#    - requirements: /opt/src/{{ project_name }}/{{ requirements_file }}
#    - bin_env: /opt/virtualenvs/{{ project_name }}
#    - use_wheel: true
#    - find_links: http://office.izeni.net/flexshare/pywheel/ubuntu12_04/
#    - allow_all_external: true
#    - allow_unverified: all
#    - require:
#      - git: latest_code

{% if dependencies_script %}
dependencies_script_{{ project_name }}:
  cmd.run:
    - name: |
        sh /opt/src/{{ project_name }}/{{ dependencies_script }}

{% endif %}

latest_requirements_{{ project_name }}:
  cmd.run:
    - user: izeni
    - shell: /bin/bash
    - name: |
        source /opt/virtualenvs/{{ project_name }}/bin/activate
        eval `ssh-agent -s`
        ssh-add /home/izeni/.ssh/deploy_key
        pip install --use-wheel \
        --find-links=http://office.izeni.net/flexshare/pywheel/ubuntu12_04/ \
        --requirement /opt/src/{{ project_name }}/{{ requirements_file }} \
        #--trusted-host office.izeni.net

{% endfor %}
