FROM ubuntu:20.04

MAINTAINER sparkyao

RUN apt-get update && apt-get -y install curl cron netcat systemd systemd-sysv dbus dbus-user-session

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ADD healthcheck.sh /root

RUN chmod +x /root/healthcheck.sh

ADD docker-entrypoint.sh /

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["journalctl","-f","-u","vpnhealthcheck.service"]