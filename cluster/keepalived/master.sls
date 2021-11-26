include:
  - modules.cluster.keepalived.install

master-configfile:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/keepalived/files/master.conf.j2
    - template: jinja

create-scriptdir:
    file.directory:
    - name: /opt/scripts
    - user: root
    - group: root
    - mode: 0644
    - makedirs: true

start-master-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - require:
      - pkg: download-keepalived
    - watch:
      - file: /etc/keepalived/keepalived.conf
