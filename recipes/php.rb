package 'php5'
package 'php-pear'
package 'php5-fpm'
package 'php5-gd'
package 'php5-mysql'

#only do this for pantheon
if node['existing']['is_pantheon']
  package 'drush'
end
  
