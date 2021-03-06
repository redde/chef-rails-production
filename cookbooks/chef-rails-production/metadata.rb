name "chef-rails-production"
version "0.1.0"
description "Chef recipe for ubuntu/debian server configuration for rails production stack"
maintainer "Oleg Bovykin"
maintainer_email "oleg.bovykin@gmail.com"
depends "apt"
depends "users"
depends "nodejs"
depends "ruby_build"
depends "rbenv"
depends "nodejs"
depends "nginx"
depends "ohai"
depends "mysql"
depends 'memcached'