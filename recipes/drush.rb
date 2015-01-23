#Copy appropriate composer.json depending on drupal version - edit the appropriate file in files/composer to change
if node["drupal_version"] == 7
  drush_version = "6.*"
else
  drush_version = "dev-master"
end

execute "Adding drush globally" do
  command "composer global require drush/drush:#{drush_version}"
  action :run
end