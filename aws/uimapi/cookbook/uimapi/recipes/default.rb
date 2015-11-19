include_recipe 'apt'
include_recipe 'php'
include_recipe 'mysqld'
include_recipe 'uimapi::packages'
include_recipe 'uimapi::php_setup'

apt_package 'apache2'

apt_package 'git'

directory '/var/www/html/sites' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  recursive true
  action :create
end

cookbook_file "/etc/init.d/script.sh" do
  source "script.sh"
  mode '0755'
end

cookbook_file "/home/ubuntu/.ssh/id_rsa" do
  source "id_rsa"
  owner 'ubuntu'
  group 'ubuntu'
  mode '0400'
end

ssh_known_hosts "github.com" do
  hashed true
  user 'ubuntu'
end

git "/var/www/html/sites" do
  repository "git@github.com:univision/digital-uimapi.git"
  action :sync
  user 'ubuntu'
end

cookbook_file "/etc/apache2/sites-available/uimapi.univision.conf" do
  source "uimapi.univision.conf"
end

cookbook_file "/home/ubuntu/virtualhost-template" do
  source "virtualhost-template"
end

execute "to run script only on first boot" do
  command "ln -s /etc/init.d/script.sh /etc/rc2.d/S99script.sh"
end

execute "enable website" do
  command "ln -s /etc/apache2/sites-available/uimapi.univision.conf /etc/apache2/sites-enabled/"
end

