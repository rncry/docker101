FROM centos:7

# Add EPEL repos (for python-pip)
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Install common dev tools
RUN yum -y update
RUN yum -y install python python-pip git

ENV foo bar

CMD echo $foo
