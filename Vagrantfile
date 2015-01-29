# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "howst"

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then 
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = "chef/ubuntu-14.04"

  # The url from where the 'config.vm.box' box will be fetched if it
  # is not a Vagrant Cloud box and if it doesn't already exist on the 
  # user's system.
  # config.vm.box_url = "https://vagrantcloud.com/chef/ubuntu-14.04/version/1/provider/virtualbox.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: "dhcp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder File.join(Dir.pwd, 'site/code'), "/var/www/drupal", :create => true,
    :"mount_options" => ["dmode=770,fmode=770"] 
      

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid
  
  #config info
  DOC_ROOT = "/var/www/drupal"
  DB = "drupal"
  DB_USER = "drupal_user"
  DB_HOST = "127.0.0.1"
  DB_PASS = "develop"
  
  #THIS IS FOR EXISTING SITES ONLY
  #Do NOT include `@` before the alias.  Include alias files in the files/default/drush directory.
  #NOTE - ensure your settings.php file is configured for the db info below.
  IS_EXISTING_SITE = true
  GIT_REPO = 'ssh://codeserver.dev.0774ae1e-50bd-4d52-9bc6-38b75b65ff75@codeserver.dev.0774ae1e-50bd-4d52-9bc6-38b75b65ff75.drush.in:2222/~/repository.git'
  SITE_ALIAS = 'dev' 
  IS_PANTHEON = true
  
  
  #STEP TO PREP FOR EXISTING SITES
  if IS_EXISTING_SITE 
    #Pull existing REPO
    config.vm.provision :host_shell do |host_shell|
        host_shell.inline = "git clone #{GIT_REPO} #{File.join(Dir.pwd, 'site/code')}" 
    end
    #pull down the db
    $guest_script = <<-SCRIPT
      drush @#{SITE_ALIAS} sql-dump | tail -n +2 > /home/vagrant/db.sql
      drush sql-cli < /home/vagrant/db.sql --db-url='mysql://root:vagrant@127.0.0.1/drupal'
    SCRIPT
    #create db script
    config.vm.provision "shell", inline: "echo \"#{$guest_script}\" > /home/vagrant/pull-db.sh"
    #add script as command
    config.vm.provision "shell", inline: "echo \"alias pull-db='sh /home/vagrant/pull-db.sh'\" >> /home/vagrant/.bashrc"
    #make the drupal root the landing directory
    config.vm.provision "shell", inline: "echo \"cd /var/www/drupal\" >> /home/vagrant/.bashrc"
    #file should be fine, use stage file proxy  
  end
  
  #Provision Dependency Stack
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'vagrant'
      },
      drupal_version: 7,
      project: {
        absolute_document_root: DOC_ROOT
      },
      database: {
        name: DB,
        user: DB_USER,
        host: DB_HOST,
        pass: DB_PASS
      },
      existing: {
        is_existing: IS_EXISTING_SITE,
        is_pantheon: IS_PANTHEON
      }
    }

    chef.run_list = [
        "recipe[howst::mysql]",
        "recipe[howst::php]",
        "recipe[howst::nginx]",
        "recipe[composer]",
        "recipe[git]",
        "recipe[howst::drupal]",
        "recipe[howst::database]",
        "recipe[vim]",
        "recipe[howst::drush]"
    ]
  end
end
