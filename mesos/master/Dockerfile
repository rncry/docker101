##
# Dockerfile responsible for running the Mesos Master daemon
##

FROM mesos

MAINTAINER Jim Vanns <jvanns@ilm.com>

# Mesos Master
EXPOSE 5050

# Add mesos master parameters
ADD conf /etc/mesos-master/

# Our service starter
ADD start-mesos.sh /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-mesos.sh"]
