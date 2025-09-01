FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/fusionpbx/repo

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gnupg2 wget curl lsb-release sudo locales git build-essential

# FreeSWITCH dependencies and build tools
RUN apt-get install -y autoconf automake devscripts gawk g++ git-core libjpeg-dev libncurses5-dev libtool make python3-dev libtiff-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev libedit-dev libldns-dev libpq-dev memcached libmemcached-dev

# Get, build, and install FreeSWITCH
RUN git clone https://github.com/signalwire/freeswitch.git /usr/src/freeswitch
WORKDIR /usr/src/freeswitch
RUN ./bootstrap.sh && ./configure --enable-core-pgsql-support && make && make install
RUN make sounds-install moh-install
WORKDIR /home/fusionpbx/repo

# FusionPBX web UI
RUN apt-get install -y nginx php php-fpm php-pgsql php-cli php-pear php-cgi php-common php-curl php-mbstring php-xml php-zip
RUN git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx

# PostgreSQL database
RUN apt-get install -y postgresql postgresql-contrib

EXPOSE 80 443/tcp 5060/udp 5061/tcp 5080/tcp 5080/udp 16384-32768/udp 5432/tcp
