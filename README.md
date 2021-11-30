# deployments
Various premade deployments to develop or run Horde environments

For more information on each deployment-setup, please read the README.md file in the respective directories.

## basic-setup

* The Horde Base app with mariadb database connection and SQL Auth, an initial user injected.
* Use this to test drive your custom app.
* Database schema autoinstalls

## groupware-webmail

Horde with webmail, calendar, tasks, notes, etc.
* Apps come with some generic config
* Database schema autoinstalls
* Webmail will connect to a Dovecot and a Postfix container
