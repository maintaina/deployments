#!/bin/bash


docker-compose up -d

sleep 5

docker exec horde_postfix zypper -n install -y vim less telnet

docker exec horde_postfix postconf smtpd_tls_security_level=none
docker exec horde_postfix postconf smtpd_sasl_auth_enable=yes
docker exec horde_postfix postconf smtpd_sasl_type=dovecot
docker exec horde_postfix postconf smtpd_sasl_path=inet:horde_dovecot:34343
docker exec horde_postfix postconf smtpd_sasl_security_options=noanonymous
docker exec horde_postfix postconf 'smtpd_sasl_local_domain=$myhostname'
docker exec horde_postfix postconf smtpd_client_restrictions=permit_sasl_authenticated,reject
docker exec horde_postfix postconf smtpd_sender_login_maps=hash:/etc/postfix/virtual
docker exec horde_postfix postconf smtpd_sender_restrictions=reject_sender_login_mismatch
docker exec horde_postfix postconf smtpd_recipient_restrictions=reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject

docker exec horde_postfix sh -c "echo 'submission inet n       -       n       -       -       smtpd' >> /etc/postfix/master.cf"

docker exec horde_postfix postconf maillog_file=/dev/stdout
