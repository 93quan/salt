#/bin/bash
cd /usr/local/redis-6.2.6
make MALLOC=libc USE_SYSTEMD=yes && \
make install PREFIX={{ pillar['install_redisdir'] }}