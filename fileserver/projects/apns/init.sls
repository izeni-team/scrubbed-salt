#!jinja|yaml

{% set project_name = pillar.project_name %}
{% set apns_cert_name = pillar.apns_cert_name|default('apns.pem') %}

.generic_cert_directory:
  file.directory:
    - name: /etc/certs
    - makedirs: true

.apns_cert:
  file.managed:
    - name: /etc/certs/apns.pem
    - source: salt://projects/certs/{{ project_name }}/{{ apns_cert_name }}
    - mode: 644
    - require:
      - file: .generic_cert_directory
