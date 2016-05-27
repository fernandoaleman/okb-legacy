include_recipe 'apt'

package "php5"
package "php5-mcrypt"
package "php5-curl"
package "php5-redis"
package "php5-mysql"
package "php5-cli"
package "php5-geoip"
package "php5-imagick"
package "php5-xdebug"
package "php5-dev"

package 'libyaml-dev'

execute "pecl install yaml" do
  command "pecl install yaml"
  not_if 'pecl list | grep "yaml"'
end

file "/etc/php5/mods-available/yaml.ini" do
  action :create
  content 'extension=yaml.so'
end

link "/etc/php5/apache2/conf.d/20-yaml.ini" do
  to "/etc/php5/mods-available/yaml.ini"
end

link "/etc/php5/cli/conf.d/20-yaml.ini" do
  to "/etc/php5/mods-available/yaml.ini"
end

link "/etc/php5/cli/conf.d/20-mcrypt.ini" do
  to "/etc/php5/mods-available/mcrypt.ini"
end

link "/etc/php5/apache2/conf.d/20-mcrypt.ini" do
  to "/etc/php5/mods-available/mcrypt.ini"
end

execute "pear channel-discover pear.bovigo.org" do
  not_if 'pear list-channels | grep "pear.bovigo.org"'
end

execute "pear install bovigo/vfsStream-beta" do
  not_if 'pear list -a | grep "vfsStream"'
end

template "/etc/php5/apache2/php.ini" do
  source "php.apache2.ini.erb"
  variables node['okb']['legacy']['php']
end

cookbook_file "/etc/php5/cli/php.ini" do
  source "php.cli.ini"
end
