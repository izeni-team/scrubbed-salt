#!jinja|yaml

swapfile:
  mount.swap:
    - name: /var/salt-swap
    - persist: true
    - require:
      - cmd: create_swap

create_swap:
  cmd.script:
    - source: salt://projects/swap/swap.sh
    - user: root
    - group: root
    - shell: /bin/bash
    - unless:
      - file /var/salt-swap 2>&1 | grep -q "Linux/i386 swap"
