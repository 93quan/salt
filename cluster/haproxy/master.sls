include:
  - modules.cluster.haproxy.install
  - modules.cluster.keepalived.install

haproxy-master-conf-keepalived:
  file.managed:
    - names:
      - /opt/scripts/check_haproxy.sh:
        - source: salt://modules/cluster/haproxy/files/check_haproxy.sh
        - mode: 0755
      - /etc/keepalived/keepalived.conf:
        - source: salt://modules/cluster/haproxy/files/keepalived-master.conf.j2
        - template: jinja

haproxy-master-service-keepalived:
  service.running:
    - name: keepalived
    - enable: true
    - reload: true
    - watch:
      - file: haproxy-master-conf-keepalived
