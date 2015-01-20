package 'php5'
package 'php-pear'
package 'php5-fpm'
package 'php5-gd'
package 'php5-mysql'

execute 'Update Pear' do
  command "pear channel-discover pear.drush.org"
  action :run
  not_if 'pear list-all -c  pear.drush.org | grep drush/drush -c'
end

execute 'Install Drush' do
  command "pear install drush/drush"
  action :run
  not_if 'pear list-all -c  pear.drush.org | grep drush/drush -c'
end
  
