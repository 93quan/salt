#!/bin/bash

haproxy_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhaproxy\b'|wc -l)
if [ $haproxy_status -lt 1 ];then
    systemctl stop keepalived
fi
