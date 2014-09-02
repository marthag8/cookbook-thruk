if node['platform'] == 'debian'
  major = node['platform_version'].to_i
elsif node['platform'] == 'ubuntu'
  major = node['platform_version']
end
machine = node['kernel']['machine']
platform_family = node['platform']

machine = 'amd64' if machine == 'x86_64'

node['thruk']['packages'].each do  |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/thruk_#{node['thruk']['version']}_#{platform_family}#{major}_#{machine}.deb" do
  action :create_if_missing
  source "http://www.thruk.org/files/pkg/v#{node['thruk']['version']}/#{platform_family}#{major}/#{machine}/thruk_#{node['thruk']['version']}_#{platform_family}#{major}_#{machine}.deb"
  backup false
  not_if "dpkg-query -W thruk | grep -q '^thruk[[:blank:]]#{node['thruk']['version']}$'"
  notifies :install, 'dpkg_package[thruk]', :immediately
end

dpkg_package 'thruk' do
  source "#{Chef::Config[:file_cache_path]}/thruk_#{node['thruk']['version']}_#{platform_family}#{major}_#{machine}.deb"
  options '--force-confold'
  action :nothing
end

file 'thruk-cleanup' do
  path "#{Chef::Config[:file_cache_path]}/thruk_#{node['thruk']['version']}_#{platform_family}#{major}_#{machine}.deb"
  action :delete
end
