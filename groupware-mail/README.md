# Horde Docker Setup

An example for a Horde Groupware and Webmail setup with MariaDB as storage backend and a minimal Dovecot and Postfix installation for development and testing purposes.
If you want to use this setup in production, a lot of additional work is probably required.

This setup comes with these Horde apps:

 * imp (webmail)
 * passwd (password)
 * turba (addressbook)
 * kronolith (calendar)
 * nag (tasks)
 * content (non-ui tagger service)

The setup consists of four containers:

- Horde with Apache and mod_php
- MariaDB
- Postfix
- Dovecot

Dovecot has been configured to use Horde's user database as authentication
backend. Postfix has been configured to lookup domains and users in Horde's
database and use Dovecot for SASL.

## Usage

### Configuring the applications

Copy the template file `.env.dist` to `.env` and make your adjustments. Make
sure to change the passwords, if you use the setup for something else than a
localhost-only development scenario.

Any additional configuration like a `motd.local` file can be placed in the
`original_config/apps/horde` directory for the horde base app or
`original_config/apps/$app` for other apps. Existing files will not be
overwritten.

### Configuring the Imap service

#### Expose the Dovecot port

- Uncomment the imap port 143 in the docker-compose.yml or docker-compose.override.yml file

#### SSL/TLS


- Add files cert.pem and key.pem to the dovecot/ folder

OR

- Provide other certificate files
- edit dovecot/dovecot.conf file SSL/TLS related settings

#### Primary Domain

- fill in the HORDE_DOMAIN variable in .env file


### Startup

Run `./make-mrproper.sh` inside the directory with the `docker-compose.yml`
file.

The container entrypoint will copy the `original_config/apps/` files to each
app's `config/` directory. It will not overwrite existing files.

Depending on the content of the `.env` file, the entrypoint will also configure
database access, wait for DB connection to succeed, run schema migrations and
inject an initial user into the authentication backend.

## Running multiple deployments:

If you want to use multiple setups at the same time for testing you can follow these steps:

+ first copy the directory, e.g.:
````shell
cd ../
cp -r groupware-mail groupware-mail2
````
+ inside the new directory, create another .env file and adapt the variable "CONTAINER_PREFIX" to adapt the containers as well as the network name. E.g:
````
cd groupware-mail2
vim .env
````
+ now you can either adapt the ports in docker-compose.yml or you can stop the running containers (from the old directory) with the ````bin/stop_containers```` script. E.g.:
````shell
cd ../groupware-mail
bin/stop_containser.sh
````
+ in the end you can run make-mrproper.sh in the new directory
````
./make_mrproper.sh
````
