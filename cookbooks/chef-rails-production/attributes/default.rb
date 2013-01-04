default["user"] = "webmaster"

default["authorization"]["sudo"]["groups"] = ["sudo"]
default["authorization"]["sudo"]["users"] = [node["user"], "vagrant"]
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