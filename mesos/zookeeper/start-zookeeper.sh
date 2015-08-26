#!/bin/sh

set -eux

# Run this as the service because
# it sets up all the jars, environment
# etc. for us.
service zookeeper start

# Then run an interactive shell to stop
# docker quiting on us and terminating the
# damn zookeeper daemon.

# THIS FUCKING SUCKS
exec /bin/bash -l
