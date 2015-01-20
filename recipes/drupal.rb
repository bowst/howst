version_7 = "drupal-7.34"
version_8 = "drupal-8.0.0-beta4"
project = node["project"]

if node["drupal_version"] == 7
  version = version_7
  url = "http://ftp.drupal.org/files/projects/#{version_7}.tar.gz"
else
  version = version_8
  url = "http://ftp.drupal.org/files/projects/#{version_8}.tar.gz"
end

site_path = project[:absolute_document_root]

execute "Downloading Drupal Source" do
  command "wget #{url}"
  cwd site_path
  action :run
  not_if do File.exists?(File.join(site_path, ".exists")) end
end

execute "Extract the files" do
  command "tar xvfz #{version}.tar.gz -C #{site_path} --strip-components=1"
  cwd site_path
  action :run
  not_if do File.exists?(File.join(site_path, ".exists")) end
end

execute "Remove the zip file" do
  command "rm -f #{version}.tar.gz"
  cwd site_path
  action :run
  not_if do File.exists?(File.join(site_path, "#{version}.tar.gz")) end
end

execute "Create .exists file" do
  command "touch #{ File.join(site_path, '.exists') }"
  cwd site_path
  action :run
end

execute "Copy settings file" do
  command "sudo cp sites/default/default.settings.php sites/default/settings.php"
  cwd site_path
  action :run
  not_if  do File.exists?(File.join(site_path, "sites/default/settings.php")) end
end

execute "Set permissions" do
  command "sudo chmod a+w #{File.join(site_path, "sites/default/settings.php")}"
  cwd site_path
  action :run
end

execute "Set additional permissions" do
  command "sudo chmod a+w #{File.join(site_path, "sites/default")}"
  cwd site_path
  action :run
end

execute "Change the owner" do
  command "chown -R www-data:www-data #{node['project']['absolute_document_root']} && gpasswd -a www-data vagrant"
  cwd site_path
  action :run
end

service "php5-fpm" do
  action :restart
end
