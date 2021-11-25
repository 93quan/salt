keepalived-install:
  pkg.installed:
    - name: keepalived

keepalived-config:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/keepalived/files/keepalived.conf.j2
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: keepalived-install
    - template: jinja
    - defaults:
{% if grains['fqdn'] == "node5" %}
      ROUTER_ID: xm01
      STATE: MASTER
      PRIORITY: 150
{% elif grains['fqdn'] == "node6" %}
      ROUTER_ID: xm02
      STATE: BACKUP
      PRIORITY: 100
{% endif %}

keepalived-service:
  service.running:
    - name: keepalived
    - enable: true
    - require:
      - file: keepalived-config
    - reload: true
    - watch: 
      - file: keepalived-config
