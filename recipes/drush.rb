#Copy appropriate composer.json depending on drupal version - edit the appropriate file in files/composer to change
if node["drupal_version"] == 7
  drush_version = "6.*"
else
  drush_version = "dev-master"
end

execute "Adding drush globally" do
  cwd "/home/vagrant"                                                           
  user "vagrant" 
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
  command "composer global require drush/drush:#{drush_version}"
  action :run
end

execute "Add Composer's global bin to $PATH" do
  cwd "/home/vagrant"                                                           
  user "vagrant" 
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
  command "sed -i '1i export PATH=\"$HOME/.composer/vendor/bin:$PATH\"' /home/vagrant/.bashrc"
  action :run
end

remote_directory "/home/vagrant/.drush" do
  files_mode '777'
  files_owner 'vagrant'
  mode '0770'
  owner 'vagrant'
  source 'drush'
end