echo "=========== Installing Git"
apt-get install git-core -y -q;
echo "=========== Cloning recipes"
rm -Rf /tmp/chef-cookbooks
cd /tmp && git clone git://github.com/redde/chef-rails-production.git chef-cookbooks;
cd /tmp/chef-cookbooks;
echo "=========== Running wizard"
ruby wizard.rb &
echo "=========== Installing chef gem"
gem install chef --no-ri --no-rdoc;
ln -s /var/lib/gems/1.8/bin/chef-solo /bin;
echo "=========== Starting provisioning"
./cheffy.sh;
