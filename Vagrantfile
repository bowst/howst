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
  
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'vagrant'
      },
      drupal_version: 8,
      project: {
        absolute_document_root: '/var/www/drupal'
      },
      database: {
        name: "drupal",
        user: "drupal_user",
        host: "127.0.0.1",
        pass: "develop"
      }
    }

    chef.run_list = [
        "recipe[howst::mysql]",
        "recipe[howst::php]",
        "recipe[howst::nginx]",
        "recipe[howst::drupal]",
        "recipe[howst::database]",
        "recipe[composer]",
        "recipe[howst::drush]",
        "recipe[vim]"
    ]
  end
end
