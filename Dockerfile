FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y wget gnupg2 lsb-release
RUN wget https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/debian/pre-install.sh && chmod +x pre-install.sh && ./pre-install.sh
RUN cd /usr/src/fusionpbx-install.sh/debian && ./install.sh
EXPOSE 80 443 5060/udp 5060/tcp 5080/udp 5080/tcp 16384-32768/udp
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
