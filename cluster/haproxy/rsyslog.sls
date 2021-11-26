/etc/rsyslog.conf:
  file.managed:
    - source: salt://modules/cluster/haproxy/files/rsyslog.conf

stop-rsyslog:
  service.dead:
    - name: rsyslog.service

strt-rsyslog:
  service.running:
    - name: rsyslog.service
