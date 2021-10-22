FROM debian:stable

RUN apt-get update && \
    apt-get install -y \
    locales \
    uudeview \
    rlpr \
    getmail && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ADD start.sh /bin/start.sh
COPY retrieve_mail.sh /bin/retrieve_mail.sh
COPY printmail.sh /bin/printmail.sh

RUN chmod 0700 /bin/start.sh 

CMD ["/bin/sh", "/bin/start.sh"]
