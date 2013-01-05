default["user"] = "webmaster"

default["authorization"]["sudo"]["groups"] = ["sudo"]
default["authorization"]["sudo"]["users"] = [node["user"]]
default['authorization']['sudo']['passwordless'] = true

default["default_ruby_version"] = "1.9.3-p327"

default["rbenv"]["user_installs"] = [
  {
    "user" => node["user"],
    "rubies" => [node["default_ruby_version"]],
    "global" => node["default_ruby_version"],
    "local" => node["default_ruby_version"],
  }
]

default["database"]["password"] = ""

default["mysql"]["server_debian_password"] = node["database"]["password"]
default["mysql"]["server_root_password"] = node["database"]["password"]
default["mysql"]["server_repl_password"] = node["database"]["password"]

default["postgresql"]["password"]["postgres"] = node["database"]["password"]
default["postgresql"]["pg_hba"] = ["host    #{node['app_name'].gsub('-', '_')}_production     #{node['app_name'].gsub('-', '_')}        127.0.0.1/32            #{node['database']['password'].length > 1 ? 'md5' : 'trust'}"]

default["memcached"]["listen"]  = "127.0.0.1"

default["sysctl"]["parameters"]["fs.file-max"] = "65536"
default["sysctl"]["parameters"]["net.core.somaxconn"] = "4096"
default["sysctl"]["parameters"]["net.core.rmem_max"] = "16777216"
default["sysctl"]["parameters"]["net.core.wmem_max"] = "16777216"
default["sysctl"]["parameters"]["net.ipv4.tcp_fin_timeout"] = "15"
default["sysctl"]["parameters"]["net.ipv4.tcp_keepalive_time"] = "1800"
default["sysctl"]["parameters"]["net.ipv4.tcp_rmem"] = "4096 87380 16777216"
default["sysctl"]["parameters"]["net.ipv4.tcp_wmem"] = "4096 65536 16777216"
default["sysctl"]["parameters"]["net.ipv4.tcp_syncookies"] = "1"
default["sysctl"]["parameters"]["net.ipv4.ip_local_port_range"] = "5000 65535"
default["sysctl"]["parameters"]["vm.swappiness"] = "30"
default["sysctl"]["parameters"]["net.core.netdev_max_backlog"] = "10000"
default["sysctl"]["parameters"]["net.ipv4.tcp_max_syn_backlog"] = "10000"