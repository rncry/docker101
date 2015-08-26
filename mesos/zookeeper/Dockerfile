##
# Dockerfile responsible for running the Zookeeper coordination service
##

FROM mesos

MAINTAINER Jim Vanns <jvanns@ilm.com>

# ZooKeeper ports
# Client connections
EXPOSE 2181
# Followers
EXPOSE 2888
# Leader election
EXPOSE 3888

# Add zookeeper parameters
#ADD conf/zoo.cfg /etc/zookeeper/conf/zoo.cfg

# Our service starter
ADD start-zookeeper.sh /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-zookeeper.sh"]
