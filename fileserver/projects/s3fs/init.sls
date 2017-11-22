#!jinja|yaml

{% set s3fs = pillar.s3fs_conf|default({}) %}

/home/izeni/.passwd-s3fs:
  file.managed:
    - source: salt://projects/s3fs/passwd-s3fs
    - template: jinja
    - user: izeni
    - group: izeni
    - mode: 600
    - context:
      s3_token: {{ s3fs.s3_token }}
      s3_secret: {{ s3fs.s3_secret }}

/etc/passwd-s3fs:
  file.managed:
    - source: salt://projects/s3fs/passwd-s3fs
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
      s3_token: {{ s3fs.s3_token }}
      s3_secret: {{ s3fs.s3_secret }}

# fstab
mounted:
  mount.mounted:
    - name: {{ s3fs.mount_path }}
    - device: {{ s3fs.bucket }}
    - fstype: fuse.s3fs
    - opts: _netdev,allow_other
    - persist: True
    - mkmnt: True
    - require:
      - file: /etc/passwd-s3fs
      - cmd: install

prereqs:
  pkg.installed:
    - pkgs:
      - build-essential
      - git
      - libfuse-dev
      - libcurl4-openssl-dev
      - libxml2-dev
      - mime-support
      - automake
      - libtool
      - pkg-config
      - libssl-dev

get_source:
  git.latest:
    - name: https://github.com/s3fs-fuse/s3fs-fuse
    - target: /home/izeni/s3fs-source

install:
  cmd.run:
    - name: ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && make install
    - cwd: /home/izeni/s3fs-source
    - unless: which s3fs
    - refresh: True
    - require:
      - pkg: prereqs
      - git: get_source
