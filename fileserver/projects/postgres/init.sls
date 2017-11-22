#!jinja|yaml


{% set postgres_version = pillar.postgres_version|default('9.4') %}


repo_add:
  cmd.run:
    - name: echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

repo_key:
  cmd.run:
    - name: wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

repo:
  cmd.run:
    - name: apt-get update

postgres_pkg:
  pkg.installed:
    - name: postgresql-{{ postgres_version }}
    - refresh: true

postgres_contrib_pkg:
  pkg.installed:
    - name: postgresql-contrib-{{ postgres_version }}

postgres_service:
  service.running:
    - name: postgresql
    - sig: postgres



{% set db_user = pillar.db_user|default('izeni') %}
{% set db_pass = pillar.db_pass|default('izeni_pass') %}
{% set db_name = pillar.db_name|default('izeni_db') %}


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


hstore_extension:
  postgres_extension.present:
    - name: hstore
    - user: postgres
    - maintenance_db: {{ db_name }}
