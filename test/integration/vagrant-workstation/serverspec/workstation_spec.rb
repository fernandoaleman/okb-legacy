require 'serverspec'

set :backend, :exec

describe "Workstation Setup" do
  describe "mysql databases" do
    describe service('mysql-1kb') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(3306) do
      it { should be_listening }
    end
  end

  describe "redis setup" do
    describe service('redis6379') do
      it { should be_running }
    end

    describe port(6379) do
      it { should be_listening }
    end
  end

  describe file("/vagrant/config.ini") do
    it { should exist }
  end
end