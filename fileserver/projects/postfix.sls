#!jinja|yaml

postfix_installed:
  pkg.latest:
    - name: postfix
    - refresh: true

postfix_running:
  service.running:
    - name: postfix
    - enable: true
    - reload: true
