#!jinja|yaml

{% set fqdn = pillar.fqdn %}
{% set ssl_cert_name = pillar.ssl_cert_name|default('cert.crt') %}
{% set ssl_key_name = pillar.ssl_key_name|default('key.key') %}

.cert_directory:
  file.directory:
    - name: /etc/ssl/tls/certs/
    - makedirs: true

.cert_directory2:
  file.directory:
    - name: /etc/pki/tls/certs/
    - makedirs: true

.ssl_cert:
  file.managed:
    - name: /etc/pki/tls/certs/{{ fqdn }}.crt
    - contents_pillar: ssl:cert.crt
    - mode: 644
    - require:
      - file: .cert_directory


.ssl_key:
  file.managed:
    - name: /etc/pki/tls/certs/{{ fqdn }}.key
    - contents_pillar: ssl:key.key
    - mode: 644
    - require:
      - file: .cert_directory

ssl_nginx_restart:
  cmd.run:
    - name: service nginx restart
    - user: root
