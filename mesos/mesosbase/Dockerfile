##
# Dockerfile responsible for providing the base Ubuntu image
##

FROM ubuntu:14.04
MAINTAINER Jim Vanns <jvanns@ilm.com>

##
# Set any environment necessary
##
ENV LC_ALL C
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB.UTF-8

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Assume we're root and tell Docker about it
ENV USER root
ENV HOME /root

##
# Build commands. Put each logically-grouped set of
# commands in a single shell pipeline. Not only is
# this good practice and helps maintain readability
# but it also helps the intermediate build stages
# remain cached when changing another (to fix it!).
##

# Locale
RUN \
   apt-get update && \
   apt-get -y install "language-pack-${LANG%%_*}" && \
   locale-gen "$LANG" && \
   update-locale LANG="$LANG"

# Update
RUN \
   apt-get update && \
   apt-get -y upgrade && \
   apt-get -y dist-upgrade && \
   apt-get -y autoremove && \
   apt-get -y autoclean

# Install some sensible base packages
RUN \
   apt-get update && \
   apt-get -y install \
      man vim procps \
      openssh-client dnsutils \
      python python-pip python-dev


# Add a nice toprc for root
ADD .toprc /root/
