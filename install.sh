ECHO "Installing Git"
apt-get install git -y -q;
ECHO "Cloning recipes"
cd /tmp && git clone git@github.com/redde/chef-rails-production.git chef-cookbooks;
cd /tmp/chef-cookbooks;
ECHO "Running wizard"
ruby wizard.rb;
ECHO "Installing chef gem"
gem install chef --no-ri --no-rdoc;
ln -s /var/lib/gems/1.8/bin/chef-solo /bin;
ECHO "Starting provisioning"
./cheffy.sh;