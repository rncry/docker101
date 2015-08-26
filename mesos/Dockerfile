##
# Dockerfile responsible for installing the Mesos framework
##

FROM mesos/mesosbase:latest
MAINTAINER Jim Vanns <jvanns@ilm.com>

WORKDIR /tmp
ENV URL deb http://repos.mesosphere.io/

# Add the Mesosphere APT repository to get Mesos component
RUN \
   apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
   echo "${URL}$(lsb_release -is | tr A-Z a-z) $(lsb_release -cs) main" | \
   tee /etc/apt/sources.list.d/mesosphere.list

# Download and install
RUN \
   apt-get update && \
   apt-get -y install mesos

# Add common mesos master and slave parameters
ADD conf /etc/mesos/
ADD env /etc/default/mesos
