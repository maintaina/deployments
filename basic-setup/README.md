# Horde Docker Setup

An example for a basic Horde setup with MariaDB as storage backend.

# Usage

## Configuring the application

See the .env file for configuration. Don't forget to change the passwords first thing before setting up anything but a localhost-only dev scenario.

Any additional config like a motd.local file can be placed in the original_config\apps\horde folder for the horde base app or app\$app for other apps. Existing files will not be overwritten.

## Startup

Run `docker-compose up` inside the directory with the docker-compose.yml file

The container entrypoint will copy original_config\apps\$app files to each $app's config/ dir. It will not overwrite existing files.

Depending on the content of the env file, the entrypoint will also configure database access, wait for DB connection to succeed, run schema migrations and inject an initial user into the authentication backend.

## Running the environment with developer-tools installed in container

Adapt the .env file and set ````ENABLE_DEVELOPER_MODE```` explicitly to yes (it will be "no" per default)

## Running multiple deployments:

If you want to use multiple setups at the same time for testing you can follow these steps:

+ first copy the directory, e.g.:
````shell
cd ../
cp -r basic-setup basic-setup2
````
+ inside the new directory, create another .env file and adapt the variable "CONTAINER_PREFIX" to adapt the containers as well as the network name. E.g:
````
cd basic-setup2
vim .env
````
+ now you can either adapt the ports in docker-compose.yml or you can stop the running containers (from the old directory) with the ````bin/stop_containers```` script. E.g.:
````shell
cd ../basic-setup
bin/stop_containser.sh
````
+ in the end you can run make-mrproper.sh in the new directory
````
./make_mrproper.sh
````

**NB:** the ````bin/```` directory contains some simple scripts to stop and start the containers. This is usefull if you do not want to destroy your containers (when runnign ````docker-compose down````)v
