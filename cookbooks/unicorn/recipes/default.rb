template "#{node['nginx']['dir']}/sites-available/#{node['app_name']}" do
  source "unicorn-site.erb"
  owner "root"
  group "root"
  mode 00644
end

nginx_site node['app_name'] do
  enable node['app_name']
end

template "/etc/init.d/#{node['app_name']}" do
  user "root"
  owner "root"
  source "unicorn-init.erb"
  mode 00755
end


pre = "/home/#{node['user']}/projects/#{node['app_name']}/shared"
dirs = [
    "/home/#{node['user']}/projects",
    "/home/#{node['user']}/projects/#{node['app_name']}",
    "/home/#{node['user']}/projects/#{node['app_name']}/releases",
    "/home/#{node['user']}/projects/#{node['app_name']}/shared",
    "#{pre}/uploads",
    "#{pre}/config",
    "#{pre}/log",
    "#{pre}/tmp",
    "#{pre}/pids"
  ]

dirs.each do |dir|
  directory dir do
    owner node['user']
    user node['user']
    group node['user']
    mode 00775
    action :create
  end
end

template "/home/#{node['user']}/projects/#{node['app_name']}/shared/config/unicorn.rb" do
  user node['user']
  owner node['user']
  source "unicorn.rb.erb"
end