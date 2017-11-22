#!jinja|yaml


{% set project_name = pillar.project_name %}
{% set django_project_name = pillar.django_project_name|default(project_name) %}
{% set django_settings_module = pillar.django_settings_module|default(pillar.project_name + '.settings.production') %}
{% set python_path = pillar.python_path|default('') %}
{% set static_script = pillar.static_script|default() %}


{% for x in ["media", "static"] %}

.{{ x }}:
  file.directory:
    - name: /var/media/{{ django_project_name }}/{{ x }}
    - user: www-data
    - group: www-data
    - mode: 2775
    - makedirs: True

{% endfor %}

{% if static_script %}
static_script:
  cmd.run:
    - name: |
        bash /opt/src/{{ project_name }}-backend/{{ static_script }}
    - require_in:
      - module: project_collectstatic
    - env:
      - LC_ALL: 'en_US.UTF-8'
    - cwd: /opt/src/{{ project_name }}-backend
{% endif %}

project_collectstatic:
  module.run:
    - name: django.collectstatic
    - settings_module: {{ django_settings_module }}
    - pythonpath: /opt/src/{{ project_name }}-backend/{{ python_path }}
    - bin_env: /opt/virtualenvs/{{ project_name }}
