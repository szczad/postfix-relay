FROM debian:stretch-slim
MAINTAINER Grzegorz Szczudlik szczad@gmail.com, Mattias Wadman mattias.wadman@gmail.com
LABEL authors="Grzegorz Szczudlik szczad@gmail.com, Mattias Wadman mattias.wadman@gmail.com"
RUN \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    postfix \
    libsasl2-modules \
    opendkim \
    opendkim-tools \
    rsyslog \
    procps && \
  apt-get clean && \
  mkdir -p /etc/opendkim/keys && \
  rm -rf /var/lib/apt/lists/*
# Default config:
# Open relay, trust docker links for firewalling.
# Try to use TLS when sending to other smtp servers.
# No TLS for connecting clients, trust docker network to be safe
ENV \
  POSTFIX_myhostname=hostname \
  POSTFIX_mydestination=localhost \
  POSTFIX_mynetworks=0.0.0.0/0 \
  POSTFIX_smtp_tls_security_level=may \
  POSTFIX_smtpd_tls_security_level=none
COPY rsyslog.conf /etc/rsyslog.conf
COPY opendkim.conf /etc/opendkim.conf
COPY run /usr/local/bin/postfix-run
VOLUME ["/var/lib/postfix", "/var/mail", "/var/spool/postfix", "/etc/opendkim/keys"]
EXPOSE 25
CMD ["/usr/local/bin/postfix-run"]
