FROM debian:jessie
MAINTAINER arminpipp <armin.pipp@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies
RUN apt-get update
# RUN apt-get -y --force-yes install apt-utils
RUN apt-get -y --force-yes install wget git nano make gcc g++ apt-transport-https libavahi-compat-libdnssd-dev sudo nodejs etherwake  && apt-get clean
RUN apt-get -y --force-yes install mc vim htop snmp lsof libssl-dev telnet-ssl imagemagick dialog curl usbutils && apt-get clean

# Firmware flash
RUN  apt-get -y --force-yes install  avrdude git-core gcc-avr avr-libc && apt-get clean

# Install perl packages
RUN apt-get -y --force-yes install libalgorithm-merge-perl \
libclass-isa-perl \
libcommon-sense-perl \
libdpkg-perl \
liberror-perl \
libfile-copy-recursive-perl \
libfile-fcntllock-perl \
libio-socket-ip-perl \
libjson-perl \
libjson-xs-perl \
libmail-sendmail-perl \
libsocket-perl \
libswitch-perl \
libsys-hostname-long-perl \
libterm-readkey-perl \
libterm-readline-perl-perl \
libsnmp-perl \
libnet-telnet-perl \
libmime-lite-perl \
libxml-simple-perl \
libdigest-crc-perl \
libcrypt-cbc-perl \
libio-socket-timeout-perl \
libmime-lite-perl \
libdevice-serialport-perl && apt-get clean


# whatsapp Python yowsup
RUN apt-get -y --force-yes install python-soappy python-dateutil python-pip python-dev build-essential libgmp10 && apt-get clean
# whatsapp images
RUN apt-get -y --force-yes install libtiff5-dev libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python-tk && apt-get clean


# Pyhton stuff
RUN pip install --upgrade pip
RUN pip install python-axolotl --upgrade
RUN pip install pillow --upgrade


RUN pip install yowsup2 --upgrade


# install yowsup-client
WORKDIR /opt
RUN mkdir /opt/yowsup-config
RUN wget -N https://github.com/tgalal/yowsup/archive/master.zip
RUN unzip -o master.zip
RUN rm master.zip


WORKDIR /opt
# install fhem (debian paket)
RUN wget https://debian.fhem.de/fhem.deb
RUN dpkg -i fhem.deb
# RUN rm fhem.deb
RUN echo 'fhem    ALL = NOPASSWD:ALL' >>/etc/sudoers
RUN echo 'attr global pidfilename /var/run/fhem/fhem.pid' >> /opt/fhem/fhem.cfg
RUN apt-get -y --force-yes install supervisor 
RUN mkdir -p /var/log/supervisor





# Do some stuff
RUN echo Europe/Vienna > /etc/timezone && dpkg-reconfigure tzdata
RUN apt-get -y --force-yes install at cron && apt-get clean


# sshd on port 2222 and allow root login / password = fhem!
RUN apt-get -y --force-yes install openssh-server && apt-get clean
RUN sed -i 's/Port 22/Port 2222/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo "root:fhem!" | chpasswd
RUN /bin/rm  /etc/ssh/ssh_host_*
# RUN dpkg-reconfigure openssh-server

RUN apt-get clean && apt-get autoremove


ENV RUNVAR fhem
WORKDIR /root

# SSH / Fhem ports 
EXPOSE 2222 7072 8083 8084 8085

ADD run.sh /root/run.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["./run.sh"]
#CMD ["arg1"]

# last add volumes

# NFS client / autofs
RUN apt-get  -y --force-yes install nfs-common autofs && apt-get clean
RUN echo "/net /etc/auto.net --timeout=60" >> /etc/auto.master


VOLUME /opt/fhem
VOLUME /opt/yowsup-config

# End Dockerfile