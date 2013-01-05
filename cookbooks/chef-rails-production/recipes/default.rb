include_recipe "apt"
include_recipe "users"
include_recipe "ruby_build"
include_recipe "rbenv::user"
include_recipe "nodejs::install_from_package"
include_recipe "nginx::default"

template "#{node['nginx']['dir']}/sites-available/#{node['app_name']}" do
  source "unicorn-site.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site node['app_name'] do
  enable node['app_name']
end