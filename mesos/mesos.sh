#!/bin/bash

set -eux

declare -a COMMON_DOCKER_OPTS=(
'--selinux-enabled=false'
)

declare -a COMMON_DOCKER_RUN_OPTS=(
'-i' \
'-t' \
'-d' \
'--net=host' \
'-v' \
'/var/log:/var/log')

DOCKER_REPO=
if [ $# -ge 2 ]; then
	DOCKER_REPO="${2}/"
fi

run()
{
	exec docker ${COMMON_DOCKER_OPTS[@]} run \
		${COMMON_DOCKER_RUN_OPTS[@]} \
		"$@"
}

case "$1" in
slave)
	run \
	-v /sys:/sys \
	-v /usr/bin/docker:/usr/bin/docker:ro \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /lib64/libdevmapper.so.1.02:/lib/libdevmapper.so.1.02:ro \
	"${DOCKER_REPO}mesos/slave"
	;;
master)
	run "${DOCKER_REPO}mesos/master"
	;;
zookeeper)
	run "${DOCKER_REPO}zookeeper"
	;;
chronos)
	run "${DOCKER_REPO}chronos"
	;;
marathon)
	run "${DOCKER_REPO}marathon"
	;;
*)
	exit 1
	;;
esac
