
node['thruk']['packages'].each do |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}" do
  action :create_if_missing
  source "#{node['thruk']['pkg_url']}/#{node['thruk']['pkg_name']}"
  backup false
  not_if "dpkg-query -W thruk | grep -q '^thruk[[:blank:]]#{node['thruk']['version']}$'"
  notifies :install, 'dpkg_package[thruk]', :immediately
end

dpkg_package 'thruk' do
  source "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}"
  action :nothing
end

file 'thruk-cleanup' do
  path "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}"
  action :delete
end
