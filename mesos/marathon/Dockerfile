##
# Dockerfile responsible for running the Marathon Mesos scheduler
##

FROM mesos

MAINTAINER Jim Vanns <jvanns@ilm.com>

# Marathon
EXPOSE 8080

# Download and install the mesos scheduler framework
RUN \
   apt-get update && \
   apt-get -y install marathon

# Add marathon parameters
ADD conf /etc/marathon/conf/

# Our service starter
ADD start-marathon.sh /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-marathon.sh"]
