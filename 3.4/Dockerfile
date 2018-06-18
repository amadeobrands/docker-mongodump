FROM mongo:3.4
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD backup.sh /backup.sh
ADD start.sh /start.sh
RUN chmod +x /start.sh && chmod +x /backup.sh

VOLUME /backup

ENTRYPOINT ["/start.sh"]
CMD [""]
