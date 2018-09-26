FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl tar perl libnet-ssleay-perl libauthen-pam-perl expect tzdata supervisor samba && \
    mkdir /opt/webmin && curl -sSL https://prdownloads.sourceforge.net/webadmin/webmin-1.890.tar.gz | tar xz -C /opt/webmin --strip-components=1 && \
    mkdir -p /var/webmin/ && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error

COPY /scripts/entrypoint.sh /
COPY /scripts/config.exp /
COPY /scripts/supervisord.conf /

RUN chmod +x entrypoint.sh

ENV nostart=true
ENV nouninstall=true
ENV noportcheck=true
ENV ssl=0
ENV login=admin
ENV password=admin
ENV atboot=false

RUN  /opt/webmin/setup.sh

#RUN /usr/bin/expect /config.exp

VOLUME /etc/webmin/

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/usr/bin/perl","/opt/webmin/miniserv.pl","/etc/webmin/miniserv.conf"]
#CMD ["/etc/webmin/start", "--nofork"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
