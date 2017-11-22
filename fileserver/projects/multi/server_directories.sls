#!jinja|yaml



{% set split_ends = pillar.split_ends|default(false) %}

opt_directories:
  file.directory:
    - names:
      - /opt/src/
      {% for project_name, project_data in pillar.backend_projects.iteritems() %}
      - /opt/src/{{ project_name }}/
      {% endfor %}
      {% if split_ends %}
      - /opt/src/frontend/
      {% endif %}
      - /opt/virtualenvs/
    - makedirs: true
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data

log_directory:
  file.directory:
    - names:
      {% for project_name, project_data in pillar.backend_projects.iteritems() %}
      - /var/log/{{ project_name }}/
      {% endfor %}
    - makedirs: true
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data
    - recurse:
      - user
      - group
      - mode

