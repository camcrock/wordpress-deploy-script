# Wordpress deploy script

Automated script to import or deploy Wordpress website in SSH
This is based on the Grafikart tutorial : https://www.grafikart.fr/tutoriels/ssh-deploy-wordpress-1060 (thanks!)

## Prerequisites

Works only on MacOS or Linux, to make it work on windows you can try those methods (not tested) :
https://stackoverflow.com/questions/2532234/how-to-run-a-makefile-in-windows
This is the script I use on my OVH shared hosting (pro plan minimum to have SSH access).
You have to enable SSH on your hosting, for OVH hosting plan, follow this tutorial :
- https://docs.ovh.com/fr/hosting/mutualise-le-ssh-sur-les-hebergements-mutualises/

## Getting Started

0. Copy this Makefile in your local Wordpress directory
1. Install wp-cli locally (https://wp-cli.org/) to have it works with the `wp` command.
2. Install wp-cli on your server, the method I use is the following one :
    - upload the `wp-cli.phar` file in a `_scripts/` folder on your server (I put it in the root directory so I use the same for all the projects)

3. Copy this Makefile in the root directory of your local Wordpress installation
4. Replaces the variables in the `envfile` with your own :
    - `phplive=/usr/local/php5.6/bin/php` ## Server php path (this example works for OVH pro shared hosting plan)
    - `wpclilive=/homez.xxx/xxxxxxxxxx/_scripts/wp-cli.phar` ## (to kown this full path you can connect to your server in SSH with the terminal and type the command `pwd`)
    - `path=~/www/websites/mywebsite/` ## path of your project on the server
    - `ssh=xxxxxxxxxx@ssh.clusterxxx.ovh.net` ## SSH credentials
    - `livedomain=http://www.domain.com` ## live URL
    - `localdomain=http://localhost/example` ## local URL
5. Create a database on your OVH
6. Copy the local files on your server, and configure the wp-config.php correctly to connect to your database
7. Create a `../_dbbackups/` folder to store the database backups

### Add your SSH key to the server to avoid typing your password every time

Create a .ssh key on your local computer : https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
Create a .ssh key on your OVH server : https://docs.ovh.com/fr/public-cloud/creation-des-cles-ssh/
On the server in the `/.ssh/` folder add a `authorized_keys` file and add your local SSH public key in it : https://timleland.com/copy-ssh-key-to-clipboard/

### Available tasks

`make help` in you terminal to see all available commands
Run `make import` Import all files from server
Run `make deploy` Deploy files to the server
Run `make dbdeploy` Send the database and replace the URLs
Run `make dbimport` Get the database from the server and replace the URLs
Run `make update` Update local Wordpress core and plugins
