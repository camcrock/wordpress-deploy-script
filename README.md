# Work in progress !

# Wordpress deploy script
Automated script to import or deploy wordpress website in SSH
This is based on the Grafikart tutorial : https://www.grafikart.fr/tutoriels/ssh-deploy-wordpress-1060 (thanks!)

## Prerequisites
Works only on MacOS or Linux, to make it work on windows you can try those methodes (not tested) :
https://stackoverflow.com/questions/2532234/how-to-run-a-makefile-in-windows
This is the script I use on my OVH shared hosting (pro plan minimum to have SSH access).
You have to enable SSH on your hosting, for OVH hosting plan, follow this tutorial :
- https://docs.ovh.com/fr/hosting/mutualise-le-ssh-sur-les-hebergements-mutualises/


## Getting Started
0. Copy this Makefile in your local Wordpress directory
1. Install wp-cli locally (https://wp-cli.org/) to have it works with the 'wp' commande.
2. Install wp-cli on your server, the methode I use is the following one :
    - upload the `wp-cli.phar` file in a `_scripts/` folder on your server (I put it in the root directory so I use the same for all the projects)

3. Copy this Makefile in the root directory of your local wordpress installation
4. Replaces the variables in the Makefile with your own :
    - phplive=/usr/local/php5.6/bin/php ## Server php path (this example works for OVH pro shared hosting plan)
    - wpclilive=/homez.716/superclanh/scripts/wp-cli.phar ## (path to wp-cli)
    - path=~/www/websites/philomate/ ## path of your project on the server
    - ssh=xxxxxxxxxx@ssh.clusterxxx.ovh.net ## ssh credentials
    - livedomain=http://www.domain.com ## live URL
    - localdomain=http://localhost/example ## local URL
5. Create a database on your ovh
6. Copy the local files on your server, and replace the wp-config database variables with the server ones


### Add your SSH key to the server to avoide typing your password every time
Create a .ssh key on your local computeur : https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
Create a .ssh key on your OVH server : https://docs.ovh.com/fr/public-cloud/creation-des-cles-ssh/
In the `/.ssh/` folder add a `authorized_keys` file and add your local SSH public key in it : https://timleland.com/copy-ssh-key-to-clipboard/


### Available tasks
Run `make deploy` to deploy the files
Run `make dbdeploy` to deploy the database
`make help` in you terminal to see the other available commands
