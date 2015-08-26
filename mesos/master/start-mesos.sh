#!/bin/sh

set -eux

set_mesos_runtime_params() {
   ip="`ip -o -4 addr show eth0 | awk '{print $4}'`"
   echo ${ip%/*} > "${1}/ip"
}

set_mesos_runtime_params '/etc/mesos-master'

# Run this as the service because it sets
# up all the environment etc. for us.
/usr/bin/mesos-init-wrapper master
