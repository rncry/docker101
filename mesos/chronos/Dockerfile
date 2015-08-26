##
# Dockerfile responsible for running the Chronos Mesos scheduler
##

FROM mesos

MAINTAINER Jim Vanns <jvanns@ilm.com>

# Chronos
EXPOSE 4400

# Download and install some the scheduler framework
RUN \
   apt-get update && \
   apt-get -y install chronos

# Eek! Modify the Chronos service! Remove ulimit because
# that doesn't work inside a Docker container.
RUN \
   sed -i.bak 's/ulimit -n [0-9]*//g' /usr/bin/chronos

# Add chronos parameters
ADD conf /etc/chronos/conf/

# Our service starter
ADD start-chronos.sh /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-chronos.sh"]
