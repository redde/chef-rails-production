gem install chef --no-ri --no-rdoc;
ln -s /var/lib/gems/1.8/bin/chef-solo /bin;
apt-get install git -y -q;
cd /tmp && git clone git@github.com/redde/chef-rails-production.git chef-cookbooks
cd /tmp/chef-cookbooks
ruby wizard.rb
./cheffy.sh;