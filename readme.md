# Running applications using docker-compose
- Create docker-compose.env file 
- Copy content of docker-compose-example.env file to docker-compose.env file
- Fill docker-compose.env file with correct values
- in terminal run : docker-compose --env-file ./docker-compose.env up

# SSL Certificate Renew And Post-Renew
- Get new certificates from zero ssl
- Run Following command in the folder where certificate files are present : 
    ```cat certificate.crt ca_bundle.crt > certificate2.crt```
- Restart containers

TODO : Try cloudflare's ssl certificates

# Automatic Database Backups
- Database backups are done using a cronjob. It uses a shell script whose path is present in a cronjob.
Path : ``` /var/automation/backup-automation/backup.sh```

# Project Paths on server
- Simsan : ```/var/simsan_internal```
- Automation : ``` /var/automation/backup-automation/```

# Setup CheapSSL
- Get CSR from /dinesh/simsan_ssl folder (Also contains private key)
- Go to Cheapssl and regenrate SSL certificate
- Verify DNS
- Download the SSL certificate
