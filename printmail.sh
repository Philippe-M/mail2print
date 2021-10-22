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

			cd ${ATTACH_DIR}
                        # process file attachments (Thank's NeoX)
                        for e in ./*
                        do
				# calcul le nouveau nom en replaçant les espaces par _ et PDF par pdf
				nouveau_nom=`echo $(basename "$e") | tr "[:blank:]" "_" | tr "PDF" "pdf"`

				# extrait l'extension
				extension=${nouveau_nom##*.}

				# renomme sous la nouvelle nomenclature
				mv "$(basename "$e")" $nouveau_nom

				# regarde si c'est un PDF et l'imprime
				if [ ${extension} = "pdf" ]
				then
					rlpr --printer=${PRINTER} $nouveau_nom
				fi

				# efface la piece jointe
				rm -f $nouveau_nom
                        done
		
			# delete mail
			#echo "[printmail] Deleting mail : $i" | tee -a ${LOGFILE}
			rm $i | tee -a ${LOGFILE}
		done
	fi
fi
