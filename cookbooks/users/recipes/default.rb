include_recipe "sudo"

user node['user'] do
  supports :manage_home => true
  comment "Rails production user"
  home "/home/#{node['user']}"
  shell "/bin/bash"
  password (0...32).map{ ('a'..'z').to_a[rand(26)] }.join
  action :create
  not_if("ls /home | grep #{node['user']}")
end

sudo_group = node["authorization"]["sudo"]["groups"].first || "sudo"

group sudo_group do
  action :modify
  members node['user']
end

group sudo_group do
  action :modify
  members "vagrant"
  append true
  not_if ("ls /home | grep vagrant")
end

execute "generate ssh key for user" do
  user "webmaster"
  command "ssh-keygen -t rsa -q -f /home/#{node['user']}/.ssh/id_rsa -P \"\""
  not_if { File.exists?("/home/#{node['user']}/.ssh/id_rsa") }
end

template "/home/#{node['user']}/.ssh/authorized_keys" do
  user node['user']
  owner node['user']
  source "keys.erb"
  mode 0600
  variables({:keys => node["users"]["authorized_keys"]})
end

template "/home/#{node['user']}/.ssh/known_hosts" do
  user node['user']
  owner node['user']
  source "keys.erb"
  mode 0600
  variables({:keys => node["users"]["known_hosts"]})
end