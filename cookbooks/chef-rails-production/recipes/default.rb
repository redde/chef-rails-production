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