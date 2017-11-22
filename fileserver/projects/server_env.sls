#!jinja|yaml

{% set db_user = pillar.db_user|default('izeni') %}
{% set db_pass = pillar.db_pass|default('izeni') %}
{% set db_name = pillar.db_name|default('izeni_db') %}
{% set db_host = pillar.db_host|default('localhost') %}


env_profile:
  file.managed:
    - name: /etc/profile.d/env_salt.sh
    - contents: |
        #!/bin/sh
        export DB_USER='{{ db_user }}'
        export DB_PASS='{{ db_pass }}'
        export DB_NAME='{{ db_name }}'
        export DB_HOST='{{ db_host }}'
