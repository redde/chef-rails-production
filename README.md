# Chef cookbooks for rails production

This repo is combination of cookbooks for bootstrapping rails production.
It's developed for Ubuntu/Debian systems, but may work anywhere.

# Installation

Execute this string as a root on the server, then follow the wizard:

    curl https://raw.github.com/redde/chef-rails-production/master/install.rb > install.rb && ruby install.rb

# What inside?
This script makes following with your server:

* Updates system through `apt` cookbook
* Users
* * Modifies sudoers through `sudo` cookbook
* * Adds `node['user']` and `vagrant` passwordless sudo access
* * Creates user defined at `node['user']`, default is `webmaster`, with random password
* * Generates ssh key for `node['user']`
* * Adds known_hosts file for `node['user']` from `node["users"]["known_hosts"]`, default is github.com
* * Adds authorized_keys file for `node['user']` from `node["users"]["authorized_keys"]`, defaults are my machines
* Installs for ruby (default 1.9.3-p327) and rbenv for `node['user']`
* Installs nodejs from package
* Installs nginx from package
* Unicorn
* * Creates nginx site for unicorn
* * Creates init script for unicorn
* * Creates unicorn.rb, `/home/#{node['user']}/projects/#{node['app_name']}/shared/config/unicorn.rb`
* Creates dir structure for rails app in `/home/#{node['user']}/projects/#{node['app_name']}`
* Installs memcached, listening on 127.0.0.1
* Installs imagemagick and libs for image processing
* Database
* * Installs mysql/postgresql client libs depending on `node['database']['type']`, mysql/postgresql
* * Installs mysql/postgresql server depending on `node['database']['server']`, true/false
* * Creates database.yml, `/home/#{node['user']}/projects/#{node['app_name']}/shared/config/database.yml`
* * Creates user `node['app_name'].gsub('-', '_')` and database `#{node['app_name'].gsub('-', '_')}_production`
* Installs monit, creates config for unicorn
* Creates logrotate config for rails app at `/home/#{node['user']}/projects/#{node['app_name']}/shared/logs`
* Creates sysctl.conf with tuned defaults