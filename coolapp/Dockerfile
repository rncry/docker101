# We're going to use our first image that we built as a base
FROM foobar

RUN yum install -y PyQt4

# Install some reasonable TTF fonts for Qt!
ADD msttcorefonts-2.5-2.noarch.rpm /tmp/ttf/
RUN \
   rpm -i /tmp/ttf/msttcorefonts-2.5-2.noarch.rpm && \
   rm -f /tmp/ttf/msttcorefonts-2.5-2.noarch.rpm
# Tell Qt where these prettier fonts are
ENV QT_QWS_FONTDIR /usr/share/fonts/msttcorefonts
RUN yum install -y ttmkfdir xorg-x11-fonts*

##
# Disable X11 SHM extension use
##
ENV QT_X11_NO_MITSHM 1

# ADD will copy a file from your local host folder to the path specified inside the image
ADD coolapp.py /usr/local/bin/coolapp

# Make it executable in the image
# Not actually necessary in this case as the file is already executable on the host,
# but this is included for completeness
RUN chmod +x /usr/local/bin/coolapp

CMD /usr/local/bin/coolapp