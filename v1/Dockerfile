FROM ubuntu:20.04

MAINTAINER sparkyao

RUN apt-get update && apt-get -y install curl cron netcat

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Add the script to the Docker Image
ADD healthcheck.sh /root/healthcheck.sh

# Give execution rights on the cron scripts
RUN chmod +x /root/healthcheck.sh

RUN echo "*/5 * * * * root /bin/bash -c 'source /root/preload.sh; /root/healthcheck.sh >> /var/log/cron.log'" >> /etc/cron.d/cronjob

RUN touch /var/log/cron.log

# Running the cron job
RUN crontab /etc/cron.d/cronjob

ENTRYPOINT ["/bin/bash","-c","service cron start && crontab -l && tail -f /var/log/cron.log"]
