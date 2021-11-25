include:
  - modules.haproxy.rsyslog

haproxy-yilai:
  pkg.installed:
    - pkgs:
      - make 
      - gcc 
      - pcre-devel 
      - bzip2-devel 
      - openssl-devel 
      - systemd-devel

/usr/local:
  archive.extracted:
    - source: salt://modules/haproxy/files/haproxy-2.4.8.tar.gz
    - if_missing: /usr/local/haproxy-2.4.8

haproxy-user:
  user.present:
    - name: haproxy
    - shell: /sbin/nologin
    - createhome: false
    - system: true

haproxy-install:
  cmd.script:
    - name: salt://modules/haproxy/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['haproxy_installdir'] }}

/usr/sbin/haproxy:
  file.symlink:
    - target: {{ pillar['haproxy_installdir'] }}/sbin/haproxy

/etc/sysctl.conf:
  file.append:
    - text:
      - net.ipv4.ip_nonlocal_bind = 1
      - net.ipv4.ip_forward = 1
  cmd.run:
    - name: sysctl -p

haproxy-conf:
  file.directory:
    - name: {{ pillar['haproxy_installdir'] }}/conf
    - user: root
    - group: root
    - mode: 0755
    - makedirs: true

haproxy-configfiles:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - names: 
      - /usr/local/haproxy/conf/haproxy.cfg:
        - source: salt://modules/haproxy/files/haproxy.cfg.j2
      - /usr/lib/systemd/system/haproxy.service:
        - source: salt://modules/haproxy/files/haproxy.service.j2
    - template: jinja
