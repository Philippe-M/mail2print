# mail2print

Mail2print est un container docker qui permet de relever automatiquement une boite mail et d'imprimer les pièces jointes aux formats pdf, ensuite déplacer les mails dans un dossier IMAP "archives".

Mail2print is a docker container which allows you to automatically collect a mailbox and print attachments in pdf formats, then move the mails to an IMAP "archives" folder.

## Configuration
Par défaut la configuration de getmail est stockée dans le répertoire /etc/mail2print du container.

Trois variables sont disponibles et nécessaire pour faire fonctionner correctement le container.

- TIMECRON : définit le temps, en secondes, entre chaque lancement de getmail pour relever la boite mail. Par défaut la valeur est à 300 secondes
- PRINTER : définit le nom de la file d'attente de l'imprimante et son IP. Ex : print@192.168.0.1. L'imprimante doit être compatible LPD. Les tests ont été réalisés sur une Canon LBP1238P.
- PURGE : definit le nombre de jour entre chaque suppression du fichier log /var/log/mail/mail2print


By default the getmail configuration is stored in the /etc/mail2print directory of the container.

Three variables are available and necessary to make the container work correctly.

- TIMECRON: defines the time, in seconds, between each launch of getmail to collect the mailbox. By default the value is 300 seconds
- PRINTER: defines the name of the printer queue and its IP. Ex: print@192.168.0.1. The printer must be LPD compatible. The tests were carried out on a Canon LBP1238P.
- PURGE: defines the number of days between each deletion of the log /var/log/mail/ mail2print file 

### /etc/mail2print/getmail.conf

```
[retriever]
type = SimpleIMAPRetriever 
server = server.mail.com
username = username
password = password
mailboxes = ("INBOX",)
move_on_delete = INBOX.INBOX.archives 

[destination]
type = Maildir
path = /home/mail2print/Mail/

[options]
delete = true
delete_after = 0
read_all = false
keep = true
```

## Usage

```
docker-compose up --build
```
