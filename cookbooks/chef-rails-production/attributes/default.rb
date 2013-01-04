default["user"] = "webmaster"

default["ruby_version"] = "1.9.3-p327"
default["rbenv"] = {
  "user_installs" => [
    {
      "user" => node["user"],
      "rubies" => [node["ruby_version"]],
      "global" => node["ruby_version"],
      "local" => node["ruby_version"],
      "gems" => [
        "name" => "bundler",
        "name" => "rake"
      ]
    }
  ]
}