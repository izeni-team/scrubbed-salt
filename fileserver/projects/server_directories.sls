#!jinja|yaml

{% set project_name = pillar.project_name|default('izeni') %}
{% set split_ends = pillar.split_ends|default(false) %}

opt_directories:
  file.directory:
    - names:
      - /opt/src/
      - /opt/src/{{ project_name }}-backend/
      {% if split_ends %}
      - /opt/src/{{ project_name }}-frontend/
      {% endif %}
      - /opt/virtualenvs/
    - makedirs: true
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data

log_directory:
  file.directory:
    - name: /var/log/{{ project_name }}/
    - makedirs: true
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data
    - recurse:
      - user
      - group
      - mode


django_log_file:
  file.managed:
    - name: /var/log/{{ project_name }}/django.log
    - makedirs: true
    - dir_mode: 775
    - file_mode: 664
    - user: izeni
    - group: www-data
    - recurse:
      - user
      - group
      - mode


