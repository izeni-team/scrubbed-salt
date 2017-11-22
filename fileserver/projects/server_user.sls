#!jinja|yaml

group_wwwdata:
  group.present:
    - name: www-data

group_admin:
  group.present:
    - name: admin

user_izeni:
  user.present:
    - name: izeni
    - fullname: izeni
    - shell: /bin/bash
    - home: /home/izeni
    - password: $1$gEGjDJ06$EZ150n/zejCuOo1WDTU.Q0
    - groups:
      {% if grains['os_family'] == 'RedHat' %}
      - wheel
      {% elif grains['os_family'] == 'Debian' %}
      - sudo
      - admin
      {% endif %}
      - www-data


nopasswd_sudo:
  file.managed:
    - name: /etc/sudoers.d/izeni
    - user: root
    - group: root
    - mode: 440
    - contents: |
        izeni ALL=(ALL) NOPASSWD:ALL
