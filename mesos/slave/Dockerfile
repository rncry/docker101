##
# Dockerfile responsible for running the Mesos Slave agent
##

FROM mesos

MAINTAINER Jim Vanns <jvanns@ilm.com>

# Mesos Slave
EXPOSE 5051

# Add mesos slave parameters
ADD conf /etc/mesos-slave/

# Our service starter
ADD start-mesos.sh /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-mesos.sh"]
