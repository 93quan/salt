include:
  - modules.cluster.keepalived.install

backup-configfile:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/keepalived/files/backup.conf.j2
    - template: jinja

start-backup-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - require:
      - pkg: download-keepalived
    - watch:
      - file: /etc/keepalived/keepalived.conf

