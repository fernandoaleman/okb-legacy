include_recipe 'apt'

package "libapache2-mod-php5"

include_recipe "1kb_ssl"

file '/var/www/html/info.php' do
  action :create
  content '<?php phpinfo(); ?>'
end

template "/etc/apache2/sites-available/#{node['okb']['legacy']['server_name']}.conf" do
  source   "1kb.conf.erb"
  cookbook "okb-legacy"
  variables :server_name     => node['okb']['legacy']['server_name'],
            :server_aliases  => node['okb']['legacy']['server_aliases'],
            :document_root   => node['okb']['legacy']['document_root'],
            :strangler_url   => node['okb']['legacy']['strangler_url'],
            :suggestions_url => node['okb']['legacy']['suggestions_url'],
            :static_url      => node['okb']['legacy']['static_url']
end

execute "a2enmod ssl"
execute "a2enmod proxy_http"
execute "a2enmod rewrite"
execute "a2ensite #{node['okb']['legacy']['server_name']}"

execute "a2dissite 000-default.conf"

service "apache2" do
  action :restart
end
