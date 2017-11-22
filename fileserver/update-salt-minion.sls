fix_master_type:
  file.replace:
    - name: /etc/salt/minion
    - pattern: "master_type: standard"
    - repl: "master_type: str"

fix_hash_type:
  file.replace:
    - name: /etc/salt/minion
    - pattern: "hash_type: md5"
    - repl: "hash_type: sha256"

install_minion:
  cmd.run:
    - name: "curl -L https://bootstrap.saltstack.com | bash -s -- -P"
    - cwd: /
    - require:
      - file: fix_master_type
      - file: fix_hash_type
