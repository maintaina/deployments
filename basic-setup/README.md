# Horde Docker Setup

An example for a basic Horde setup with MariaDB as storage backend.

# Usage

Log into Github's Docker Registry first.

- create Personal Access Token under https://github.com/settings/tokens with the scope _read_packages_
- login on cli using the token as password:
```bash
docker login docker.pkg.github.com --username <your-github-username>
```

Then, run `./setup.sh`. This will execute the following steps:
- spawn the containers using docker-compose
- deploy a basic configuration file for Horde
    - configuring the SQL Auth backend
    - configuring the cookie domain ''
- setting owner of `/srv/www/horde/web` to `wwwrun:www`
- run the Horde DB Migration script to create Hordes database schema
- create an admin user with username "administrator" and password "administrator"
