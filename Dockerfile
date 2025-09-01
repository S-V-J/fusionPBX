FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/fusionpbx/repo

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gnupg2 wget curl lsb-release sudo locales

# Add FreeSWITCH repo and key (handling new key location)
RUN wget -O /usr/share/keyrings/freeswitch-archive-keyring.gpg https://files.freeswitch.org/repo/deb/debian-release/freeswitch_archive_gpg.key
RUN echo "deb [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] https://files.freeswitch.org/repo/deb/freeswitch-1.10/$(lsb_release -sc) main" > /etc/apt/sources.list.d/freeswitch.list
RUN apt-get update && \
    apt-get install -y freeswitch freeswitch-meta-all freeswitch-lang-en freeswitch-sounds-en-us-callie

# FusionPBX dependencies + source
RUN apt-get install -y git nginx php php-fpm php-pgsql php-cli php-pear php-cgi php-common php-curl php-mbstring php-xml php-zip
RUN git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx

# PostgreSQL
RUN apt-get install -y postgresql postgresql-contrib

EXPOSE 80 443/tcp \
        5060/udp 5061/tcp \
        5080/tcp 5080/udp \
        16384-32768/udp \
        5432/tcp
