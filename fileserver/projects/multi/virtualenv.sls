#!jinja|yaml

# Installing from Ubuntu repos is actually kind of nice
virtualenvwrapper_installed:
  pkg.installed:
    - name: virtualenvwrapper

# Update pip to use pip's pip
pip_latest:
  pip.installed:
    - name: pip
    - upgrade: True


{% for project_name, project_data in pillar.backend_projects.iteritems() %}


{% set python_bin = project_data.python_bin|default('/usr/bin/python3') %}
{% set django_settings_module = project_data.django_settings_module|default(project_name + '.settings.production') %}
{% set python_path = pillar.python_path|default('') %}
{% set frontend_env = pillar.frontend_env|default() %}

project_venv_{{ project_name }}:
  virtualenv.managed:
    - name: /opt/virtualenvs/{{ project_name }}
    - cwd: /opt/src/{{ project_name }}/
    - python: {{ python_bin }}
    - user: izeni

project_file_{{ project_name }}:
  file.managed:
    - name: /opt/virtualenvs/{{ project_name }}/.project
    - contents: /opt/src/{{ project_name }}/{{ python_path }}
    - user: izeni

postactivate_config_block_{{ project_name }}:
  file.managed:
    - name: /opt/virtualenvs/{{ project_name }}/bin/postactivate
    - contents: |
        export DJANGO_SETTINGS_MODULE="{{ django_settings_module }}"
        {% if project_data.db_name|default() %}
        export DB_NAME={{ project_data.db_name }}
        export DB_PASS={{ project_data.db_pass }}
        export DB_USER={{ project_data.db_user }}
        export DB_HOST={{ project_data.db_host }}
        {% endif %}
        {% if frontend_env %}
        export NODE_ENV={{ frontend_env }}
        {% endif %}
    - user: izeni

{% endfor %}
