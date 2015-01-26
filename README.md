# Hōwst
##Easy Drupal Setup

###Introduction
Hōwst is how darth vader would have spun up local drupal sites - it is the quick and easy path.  It uses a Virtual Machine to provide an isolated and (hopefully) perfectly configured environment for your local drupal instance.  However, using what can only be some form of sorcery, you can edit all of the drupal directory in /site/code on your local machine (not the VM)...that's a lot better than using VIM!  Plus, you get drush and composer too!

###Dependencies
* Vagrant (version >= 1.7.2)
   * Vagrant-Berkshelf Plugin
   * Vagrant Omnibus Plugin
* Chef Development Kit (Chef-DK)

###What's behind door number 1?
After your VM is up and running, you'll have a ready-to-go drupal instance based on the following stack:
* Nginx
* PHP (duh!)
* MySQL
* Drupal (double-duh!)

###Getting Started
1. Install the dependencies
2. Clone the repo
3. Configure your instance in the Vagrant File.  Available options currently include:
   * Drupal version #
   * Database config (user, password, host, etc.)
   * Drupal install directory (default to /var/www/drupal)
   * To configure the port on your local machine you'll visit, change the `host` parameter of the config.vm.network function in the vagrant file.  Defaults to 8080.
4. Run the following command to bring up your shiny new drupal instance
   vagrant up
5. You should now be able to access the drupal install.php for your shiny new instance at localhost:8080 (or whatever port you specified) on your local machine.
6. ssh-ing is easy.  From the root directory of this repo, simply run the following command
   vagrant ssh
7. Drush is already installed - good practice would be to create a local alias for your new drupal site.  You must be wondering...such an onerous task, there must be an easy way to do it.  Well, you're wrong!  Just kidding, it's wicked easy.  Try the command magic below from your drupal install directory.
   drush site-alias @self --full --with-optional
8. Get Drupally with it!

###The Deets
* Any files in the files/default/drush directory will be copied to the ~/.drush directory on the VM instance.  This is super handy for drush aliases, policy files, etc.  I've included a drush policy file attempting to ensure staging and prod dbs are not overwritten by foolish tooks.
* The NGINX config file can be edited in files/default/nginx

###TODO
1. Add ability to spin up existing sites using git clone, drush sql-sync, and file proxy module.
   
