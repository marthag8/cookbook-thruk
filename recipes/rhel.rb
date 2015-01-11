# for mod_fcgid
include_recipe 'yum-epel'

remote_file "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}" do
  action :create_if_missing
  source "#{node['thruk']['pkg_url']}/#{node['thruk']['pkg_name']}"
  backup false
  not_if "rpm -qa | grep -q '^thruk-#{node['thruk']['version']}'"
  notifies :install, 'yum_package[thruk]', :immediately
end

yum_package 'thruk' do
  source "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}"
  action :nothing
end

file 'thruk-cleanup' do
  path "#{Chef::Config[:file_cache_path]}/#{node['thruk']['pkg_name']}"
  action :delete
end
