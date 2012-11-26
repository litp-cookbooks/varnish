require 'securerandom'

case platform
  when "smartos"
    default["varnish"]["packages"] = "varnish"
    default["varnish"]["vcl"] = "/opt/local/etc/default.vcl"
    default["varnish"]["secret"] = "/opt/local/etc/varnish.secret"
end

default["varnish"]["backends"] = [
    # {"name" => "server1", "host" => "1.2.3.4", "port" => "80"}
    # {
    #   "name" => "a",
    #   "host" => "a.com",
    #   "port" => "80",
    #   "probe" => {
    #     "url" => "/",
    #     "interval" => "5s",
    #     "timeout" => "1s",
    #     "window" => "5",
    #     "threshold" => "3"
    #   }
    # }
]
default["varnish"]["backend"]["search"] = nil
default["varnish"]["backend"]["port"] = "80"

default["varnish"]["recv"] = {}

default["varnish"]["management_interface"]["enabled"] = false
default["varnish"]["management_interface"]["interface"] = "lo0"
default["varnish"]["management_interface"]["port"] = "8081"

set_unless["varnish"]["management_interface"]["secret"] = SecureRandom.hex
