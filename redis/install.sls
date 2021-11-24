redis-yilai:
  pkg.installed:
    - pkgs:
      - make 
      - gcc
      - gcc-c++ 
      - tcl-devel 
      - systemd-devel

redis-jieya:
  archive.extracted:
    - name: /usr/local
    - source: salt://modules/redis/files/redis-6.2.6.tar.gz
    - if_missing: /usr/local/redis-6.2.6

{{ pillar['install-redisdir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - unless: test -d {{ pillar['install-redisdir'] }}/conf

redis-install:
  cmd.script:
    - name: salt://modules/redis/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['install-redisdir'] }}/bin

redis-configfile:
  file.managed:
    - names:
      - {{ pillar['install-redisdir'] }}/conf/redis.conf:
        - source: salt://modules/redis/files/redis.conf.j2
        - template: jinja 
      - /usr/local/bin/redis-server:
        - source: salt://modules/redis/files/redis-server
        - mode: 0755
      - /usr/lib/systemd/system/redis_server.service:
        - source: salt://modules/redis/files/redis_server.service.j2
        - template: jinja

redis-start:
  service.running:
    - enable: true
    - require:
      - {{ pillar['install-redisdir'] }}/conf/redis.conf
    - reload: true
    - watch:
      - file: {{ pillar['install-redisdir'] }}/conf/redis.conf
