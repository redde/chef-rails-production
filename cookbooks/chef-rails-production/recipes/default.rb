include_recipe "apt"
include_recipe "users"
include_recipe "ruby_build"
include_recipe "rbenv::user"
include_recipe "nodejs::install_from_package"
include_recipe "nginx::default"
include_recipe "unicorn"

%w{imagemagick libmagickcore-dev libmagickwand-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'mysql'
include_recipe 'mysql::server' if node['database']['server'] == 'true'

template "/home/#{node['user']}/projects/#{node['app_name']}/shared/config/database.yml" do
  user node['user']
  owner node['user']
  source "database.yml.erb"
end

db_user = node['app_name'].gsub('-', '_')
db_name = "#{node['app_name'].gsub('-', '_')}_production"

db_sql = <<-SQL
  CREATE DATABASE IF NOT EXISTS #{db_name};
  CREATE USER '#{db_user}'@'localhost'#{ " IDENTIFIED BY '#{node["database"]["password"]}'" if node["database"]["password"].size > 0} ;
  GRANT ALL PRIVILEGES ON #{db_name}.* TO '#{db_user}'@'localhost' WITH GRANT OPTION;
SQL

execute "mysql create db and user" do
  command "mysql -u root -h localhost -e '#{db_sql}' -p #{node['mysql']['server_root_password']}"
end