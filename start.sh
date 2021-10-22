#!/bin/sh

run()
{
	useradd -d /home/mail2print mail2print
	mkdir -p /home/mail2print/Mail/new
	mkdir -p /home/mail2print/Mail/cur
	mkdir -p /home/mail2print/Mail/tmp
	chown -R mail2print:root /home/mail2print/Mail

	chown -R mail2print:root /etc/mail2print

	chmod 0755 /bin/printmail.sh
	mkdir /home/mail2print/Mail/attachments
	chown -R mail2print:root /home/mail2print/Mail/attachments

	# create log
	mkdir -p /var/log/mail
	touch /var/log/mail/mail2print.log
	chown mail2print:root /var/log/mail/mail2print.log

	# log for docker log command
	tail -n 50 -f /var/log/mail/mail2print.log &

	# start getmail 
	su -s /bin/sh -c '/bin/sh /bin/retrieve_mail.sh' mail2print
}

run
