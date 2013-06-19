
default["thruk"]["version"] = "1.72-2"

default["thruk"]["dir"] = "/usr/share/thruk"
default["thruk"]["docroot"] = "/usr/share/thruk/root/thruk"
default["thruk"]["log_dir"] = "/var/log/thruk"
default["thruk"]["conf_dir"] = "/etc/thruk"
default["thruk"]["htpasswd"] = "/etc/thruk/htpasswd"
default["thruk"]["use_ssl"] = false

default["thruk"]["cert_name"] = node["fqdn"]
default["thruk"]["cgi"]["admin_group"] = "admins"
default["thruk"]["cgi"]["read_groups"] = "all"

