# Horde Docker Setup

An example for a Horde Groupware and Webmail setup with MariaDB as storage backend and a minimal dovecot installation for testing.
If you want to use this setup in production, a lot of additional work is probably required

This setup comes with 

 * imp (webmail)
 * passwd (password)
 * turba (addressbook)
 * kronolith (calendar)
 * nag (tasks)
 * content (non-ui tagger service)

The dovecot server uses the horde user database as authentication backend.

# Usage

## Configuring the application

See the .env file for configuration. Don't forget to change the passwords first thing before setting up anything but a localhost-only dev scenario.

Any additional config like a motd.local file can be placed in the original_config\apps\horde folder for the horde base app or app\$app for other apps. Existing files will not be overwritten.

## Startup

Run `docker-compose up` inside the directory with the docker-compose.yml file

The container entrypoint will copy original_config\apps\$app files to each $app's config/ dir. It will not overwrite existing files.

Depending on the content of the env file, the entrypoint will also configure database access, wait for DB connection to succeed, run schema migrations and inject an initial user into the authentication backend.

