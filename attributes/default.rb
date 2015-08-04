
default['thruk']['version'] = '1.86'

default['thruk']['major'] = node['platform_version'].to_i

if node['platform_family'] == 'debian'
  default['thruk']['machine'] = node['kernel']['machine'] == 'x86_64' ? 'amd64' : node['kernel']['machine']
  default['thruk']['pkg_url'] = "http://download.thruk.org/pkg/v#{node['thruk']['version']}/#{node['platform_family']}#{node['thruk']['major']}/#{node['thruk']['machine']}"

  default['thruk']['pkg_name'] = "thruk_#{node['thruk']['version']}_#{node['platform_family']}#{node['thruk']['major']}_#{node['thruk']['machine']}.deb"

else
  default['thruk']['machine'] = node['kernel']['machine']
  default['thruk']['pkg_url'] = "http://download.thruk.org/pkg/v#{node['thruk']['version']}/#{node['platform_family']}#{node['thruk']['major']}/#{node['thruk']['machine']}"

  # packages on rhel have a -1 added if there is no minor version
  if node['thruk']['version'] =~ /-/
    default['thruk']['pkg_name'] = "thruk-#{node['thruk']['version']}.#{node['platform_family']}#{node['thruk']['major']}.#{node['thruk']['machine']}.rpm"
  else
    default['thruk']['pkg_name'] = "thruk-#{node['thruk']['version']}-1.#{node['platform_family']}#{node['thruk']['major']}.#{node['thruk']['machine']}.rpm"
  end
end

default['thruk']['packages'] = %w(libcairo2 libcurl3 libfontconfig1 libfreetype6 libgd2-xpm libjpeg62 libmysqlclient16 libpng12-0 libxpm4 xvfb)

default['thruk']['dir'] = '/usr/share/thruk'
default['thruk']['docroot'] = '/usr/share/thruk/root/thruk'
default['thruk']['log_dir'] = '/var/log/thruk'
default['thruk']['conf_dir'] = '/etc/thruk'
default['thruk']['htpasswd'] = '/etc/thruk/htpasswd'
default['thruk']['use_ssl'] = false

default['thruk']['cert_name'] = node['fqdn']
default['thruk']['cgi']['admin_group'] = 'admins'
default['thruk']['cgi']['read_groups'] = 'all'
default['thruk']['cgi']['lock_authors_names'] = 1

default['thruk']['logo_path_prefix'] = '/thruk/icons/'
default['thruk']['start_page'] = '/thruk/cgi-bin/tac.cgi'
default['thruk']['first_day_of_week'] = 1
default['thruk']['use_strict_host_authorization']  = 0
default['thruk']['enable_shinken_features'] = 0

default['thruk']['cmd_defaults']['ahas'] = 0
default['thruk']['cmd_defaults']['broadcast_notification'] = 0
default['thruk']['cmd_defaults']['force_check'] = 0
default['thruk']['cmd_defaults']['force_notification'] = 0
default['thruk']['cmd_defaults']['send_notification'] = 1
default['thruk']['cmd_defaults']['sticky_ack'] = 1
default['thruk']['cmd_defaults']['persistent_comments'] = 1
default['thruk']['cmd_defaults']['persistent_ack'] = 0
default['thruk']['cmd_defaults']['ptc'] = 0
default['thruk']['cmd_defaults']['use_expire'] = 0

default['thruk']['plugins'] = %w(dashboard minemap mobile panorama reports2 statusmap)
