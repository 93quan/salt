include:
  - modules.redis.install

redis-slavefile:
  file.managed:
    - name: {{ pillar['install-redisdir'] }}/conf/redis.conf
    - source: salt://modules/master/files/redis.conf.j2
    - template: jinja

redis-slave-service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['install-redisdir'] }}/conf/redis.conf
