require 'serverspec'

set :backend, :exec

describe "PHP installation" do
  describe "packages that should be installed" do
    %w(
      php5
      php5-mcrypt
      php5-curl
      php5-redis
      php5-mysql
      php5-cli
      php5-geoip
      php5-imagick
      php5-xdebug
      php5-dev
    ).each do |php_package|
      describe package(php_package) do
        it { should be_installed }
      end
    end
  end

  describe "php-yaml installation" do
    describe package('libyaml-dev') do
      it { should be_installed }
    end

    describe command('pecl list') do
      its(:stdout) { should contain 'yaml' }
    end

    describe "yaml.ini is created and symlinked" do
      describe file('/etc/php5/mods-available/yaml.ini') do
        it { should be_file }
        its(:content) { should eq 'extension=yaml.so' }
      end

      describe file('/etc/php5/apache2/conf.d/20-yaml.ini') do
        it { should be_symlink }
        it { should be_linked_to '/etc/php5/mods-available/yaml.ini' }
      end

      describe file('/etc/php5/cli/conf.d/20-yaml.ini') do
        it { should be_symlink }
        it { should be_linked_to '/etc/php5/mods-available/yaml.ini' }
      end
    end
  end

  describe "mcrypt.ini links" do
    describe file('/etc/php5/apache2/conf.d/20-mcrypt.ini') do
      it { should be_symlink }
      it { should be_linked_to '/etc/php5/mods-available/mcrypt.ini' }
    end

    describe file('/etc/php5/cli/conf.d/20-mcrypt.ini') do
      it { should be_symlink }
      it { should be_linked_to '/etc/php5/mods-available/mcrypt.ini' }
    end
  end

  describe "vfsStream installation" do
    describe command("pear list-channels") do
      its(:stdout) { should contain 'pear.bovigo.org' }
    end

    describe command("pear list -a") do
      its(:stdout) { should contain "vfsStream" }
    end
  end
end