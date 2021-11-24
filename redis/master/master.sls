include:
  - modules.redis.install

redis-masterfile:
  file.managed:
    - name: {{ pillar['install-redisdir'] }}/conf/redis.conf
    - source: salt://modules/master/files/redis.conf.j2
    - template: jinja

redis-master-service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['install-redisdir'] }}/conf/redis.conf
