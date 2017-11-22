#!jinja|yaml

server_repo_pkgs:
  pkg.installed:
    - pkgs:
      - ntpd
      - htop
      - iotop
      - iftop
      - git
      - tig
      - tmux
      - screen
      - byobu
      - graphviz
{% if grains['os'] == 'CentOS' %}
      - freetype-devel
      - openjpeg-devel
      - libxml2-devel
      - libxslt-devel
      - libpqxx-devel
      - python-devel
      - python-pip
{% else %}
      - git-flow
      - ack-grep
      - vim-nox
      - libfreetype6-dev
      {% if grains['os'] == 'Ubuntu' %}
      - libjpeg8-dev
      {% else %}
      - libjpeg62-turbo-dev
      {% endif %}
      - libxml2-dev
      - libxslt1-dev
      - lib32z1-dev
      - postgresql-server-dev-all
      - python-dev
      - python-pip
      - python3-dev
      - python3-pip
{% endif %}

pip_ssl:
  pip.installed:
    - name: 'requests[security]'
    - require:
      - pkg: server_repo_pkgs
