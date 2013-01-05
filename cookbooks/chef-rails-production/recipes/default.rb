include_recipe "apt"
include_recipe "users"
include_recipe "ruby_build"
include_recipe "rbenv::user"
include_recipe "nodejs::install_from_package"
include_recipe "nginx::default"
include_recipe "unicorn"
include_recipe "memcached"

%w{imagemagick libmagickcore-dev libmagickwand-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

case node['database']['type']
  when 'postgresql'
    db_type = 'postgresql'
    include_recipe 'postgresql'
    include_recipe 'postgresql::server' if node['database']['server'] == 'true'
  when 'mysql'
    db_type = 'mysql2'
    include_recipe 'mysql'
    include_recipe 'mysql::server' if node['database']['server'] == 'true'
end

template "/home/#{node['user']}/projects/#{node['app_name']}/shared/config/database.yml" do
  user node['user']
  owner node['user']
  source "database.yml.erb"
  variables({:db_type => db_type})
end

db_user = node['app_name'].gsub('-', '_')
db_name = "#{node['app_name'].gsub('-', '_')}_production"

case node['database']['type']
  when 'postgresql'
    pg_user db_user do
      privileges :superuser => false, :createdb => true, :login => user
      if node['database']['password'].length > 1
        password node['database']['password']
      end
    end

    pg_database db_name do
      owner db_user
      encoding 'utf-8'
    end
  when 'mysql'
    db_sql = <<-SQL
      CREATE DATABASE IF NOT EXISTS #{db_name};
      GRANT ALL PRIVILEGES  ON #{db_name}.*
      TO '#{db_user}'@'localhost'#{ " IDENTIFIED BY '#{node["database"]["password"]}'" if node["database"]["password"].size > 0}
      WITH GRANT OPTION;
    SQL

    execute "mysql create db and user" do
      command "mysql -u root -h localhost -e '#{db_sql}' -p #{node['mysql']['server_root_password']}"
    end
end

package "monit" do
  action :install
end

template "/etc/monit/conf.d/#{node['app_name']}" do
  user "root"
  owner "root"
  source "unicorn.monitrc.erb"
end

service "monit" do
  action [:enable, :start]
end

logrotate_app node["app_name"] do
  cookbook "logrotate"
  path "/home/#{node['user']}/projects/#{node['app_name']}/shared/logs"
  options ["missingok"]
  frequency "daily"
  rotate 30
  create "644 webmaster adm"
end

service 'procps' do
  supports :restart => true
  action :nothing
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => 'procps'), :immediately
end