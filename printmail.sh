#!/bin/bash
MAILDIR=/home/mail2print/Mail
LOGFILE=/var/log/mail/mail2print.log
ATTACH_DIR=/home/mail2print/Mail/attachments
PRINTER=${PRINTER}
PURGE=${PURGE}

find /var/log/mail -type f -mtime +${PURGE} -exec rm -f {} \;

if [ -d ${MAILDIR}/new ]
then
	COUNT=`ls ${MAILDIR}/new | wc -l`
	if [ ${COUNT} -ne 0 ]
	then
		for i in ${MAILDIR}/new/*
		do
			#echo "[printmail] Processing : $i" | tee -a ${LOGFILE}
			uudeview $i -iqn -p ${ATTACH_DIR}/

			# process file attachments with space
			cd ${ATTACH_DIR}
			NBATTACH=`ls ${ATTACH_DIR} | wc -l`
			if [ ${NBATTACH} -ne 0 ]
			then
				for e in ./*
				do
					a=`echo $e | tr "[:blank:]" "_"`
					if [ $? -eq 0 ]
					then
						mv "$e" "$a"
					fi
				done
				for f in *.PDF
				do
					mv $f ${f%.*}.pdf
				done

				# end of patch
				#echo "[printmail] Printing PDFs" | tee -a ${LOGFILE}
				for x in ${ATTACH_DIR}/*.pdf
				do
					#echo "[printmail] Printing : $x" | tee -a ${LOGFILE}
					rlpr --printer=${PRINTER} $x
					#echo "[printmail] Deleting file : $x" | tee -a ${LOGFILE}
					rm -f $x | tee -a ${LOGFILE}
				done

				#echo "[printmail] Clean up and remove any other attachments" | tee -a ${LOGFILE}
				for y in ${ATTACH_DIR}/*
				do
					rm -f $y
				done
			fi
			
#			# delete mail
			#echo "[printmail] Deleting mail : $i" | tee -a ${LOGFILE}
			rm $i | tee -a ${LOGFILE}
		done
	fi
fi
