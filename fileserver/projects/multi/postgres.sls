#!jinja|yaml

postgres_pkg:
  pkg.installed:
    - name: postgresql

postgres_contrib_pkg:
  pkg.installed:
    - name: postgresql-contrib

postgres_service:
  service.running:
    - name: postgresql
    - sig: postgres

{% for project_name, project_data in pillar.backend_projects.iteritems() %}

{% set db_user = project_data.db_user|default('izeni') %}
{% set db_pass = project_data.db_pass|default('izeni_pass') %}
{% set db_name = project_data.db_name|default('izeni_db') %}


{{ db_user }}:
  postgres_user.present:
    - name: {{ db_user }}
    - createdb: true
    - encrypted: true
    - password: {{ db_pass }}
    - user: postgres

  postgres_database.present:
    - name: {{ db_name }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - template: template0
    - owner: {{ db_user }}
    - user: postgres
    - require:
      - postgres_user: {{ db_user }}
      - service: postgres_service


hstore_extension_{{ project_name }}:
  postgres_extension.present:
    - name: hstore
    - user: postgres
    - maintenance_db: {{ db_name }}


{% endfor %}
