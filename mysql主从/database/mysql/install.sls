{% if grains['osmajorrelease'] == 8 %}
ncureses-compat-libs:
  pkg.installed
{% endif %}

{% if grains['osmajorrelease'] == 7 %}
libaio-devel:
  pkg.installed
{% endif %}

mysql-user:
  user.present:
    - name: user
    - system: true
    - createhome: false
    - shell: /sbin/nologin

mysql-jieya:
  archive.extracted:
    - name: /usr/local
    - source: salt://modules/database/mysql/files/mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz
  file.symlink:
    - name: /usr/local/mysql
    - target: /usr/local/mysql-5.7.34-linux-glibc2.12-x86_64

/usr/local/mysql:
  file.directory:
    - user: mysql
    - group: mysql
    - mode: '0755'
    - recurse:
      - user
      - group

{{ pillar['datadir'] }}:
  file.directory:
    - user: mysql
    - group: mysql
    - mode: '0755'
    - makedirs: true
    - recurse:
      - user
      - group

/etc/my.cnf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 0644
    - makedirs: true
    - recurse:
      - user
      - group

mysql-copyfile:
  file.managed: 
    - user: root
    - group: root
    - mode: 0755
    - names:
      - /etc/my.cnf:
        - source: salt://database/mysql/files/my.cnf.j2
      - /usr/lib/systemd/system/mysqld.service:
        - source: salt://database/mysql/files/mysqld.service.j2
      - {{ pillar['install_mysqldir'] }}/support-files/mysql.server:
       - source: salt://database/mysql/files/mysql.server.j2
    - template:
      - jinja

mysql-initialize:
  cmd.run:
    - name: '{{ pillar["install_mysqldir"] }}/bin/mysqld --initialize-insecure --user=mysql --datadir={{ pillar['datadir'] }}'
    - require:
      - archive: /usr/local
      - user: mysql
      - file: /opt/data
    - unless: test  $(ls -l {{ pillar['datadir'] }} |wc -l) -gt 1

mysqld.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: /etc/my.cnf 
