include:
  - modules.cluster.haproxy.install
  - modules.cluster.keepalived.install

haproxy-backup-conf-keepalived:
  file.managed:
    - names:
      - /etc/keepalived/keepalived.conf:
        - source: salt://modules/cluster/haproxy/files/keepalived-backup.conf.j2
        - template: jinja
      - /opt/scripts/notify.sh:
        - source: salt://modules/cluster/haproxy/files/notify.sh
        - mode: '0755'

haproxy-backup-service-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: haproxy-backup-conf-keepalived

haproxy-backup-service-keepalived-dead:
  service.dead:
    - name: keepalived.service
    - enable: false
