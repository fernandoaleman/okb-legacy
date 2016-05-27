include_recipe 'okb-base::vagrant'

include_recipe 'apt'

package "vim"

node.default['mysql']['databases'] = %w(1kb_db 1kb_import 1kb_test strangler_legacy_development strangler_legacy_test)
node.default['mysql']['users'] << {
  name: '1kb_admin',
  password: 'password',
  databases: %w(1kb_db 1kb_import 1kb_test)
}

include_recipe 'okb-mysql'

include_recipe "okb-redis"

node.default['okb']['legacy']['server_name'] = 'mydev.1000bulbs.com'
node.default['okb']['legacy']['document_root'] = '/vagrant/public_html'

node.default['rbenv']['user_installs'] = [
  { 'user'    => 'vagrant',
    'rubies'  => ['2.2.5'],
    'global'  => '2.2.5',
    'gems'    => {
      '2.2.5'    => [
        { 'name'    => 'bundler' },
        { 'name'    => 'rake' }
      ]
    }
  }
]

include_recipe 'okb-legacy::default'

include_recipe 'ruby_build'
include_recipe 'ruby_rbenv::user'

cookbook_file "/vagrant/config.ini" do
  user 'vagrant'
end

execute "install rbenv into vagrant's .bashrc" do
  user 'vagrant'
  command <<-EOS
  echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
  EOS
  not_if 'grep "rbenv" /home/vagrant/.bashrc'
end

cookbook_file "/home/vagrant/.ssh/known_hosts" do
  user 'vagrant'
end

execute "./composer.phar install" do
  user 'vagrant'
  cwd '/vagrant'
end

rbenv_path =  "/home/vagrant/.rbenv/shims:/home/vagrant/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

execute "./vendor/bin/phing update" do
  environment "PATH" => rbenv_path
  user 'vagrant'
  cwd '/vagrant'
end

%w(carbonite.yml eden.yml rackspace.yml shipper_LTL.yml wire.yml).each do |config_file|
  cookbook_file "/vagrant/config/#{config_file}" do
    user 'vagrant'
  end
end

execute "./dev-tools/bin/import-catalog" do
  user 'vagrant'
  cwd '/vagrant'
  environment "PATH" => rbenv_path, "RAILS_ENV" => "development"
end