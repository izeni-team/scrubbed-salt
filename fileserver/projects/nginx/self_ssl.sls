#!jinja|yaml


{% set fqdn = pillar.fqdn|default('deploy.izeni.com') %}



install-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - python-dev
      - python-pip
      - libssl-dev
      - libffi-dev
      - openssl

pyopenssl:
  pip.installed:
    - name: pyopenssl
    - upgrade: true



ca_key_path:
  file.directory:
    - name: /etc/pki/tls/certs
    - makedirs: true


cert_self_signed:
  module.run:
    - name: tls.create_self_signed_cert
    - tls_dir: tls
    - bits: 2048
    - CN: {{ fqdn }}
