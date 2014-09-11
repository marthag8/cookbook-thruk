#
# Cookbook Name:: thruk
# Recipe:: default
#
# Copyright 2013, Tech Financials
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_fcgid"
include_recipe "apache2::mod_ssl" if node['thruk']['use_ssl']

apache_site 'default' do
  enable false
end

cookbook_file 'thruk.conf' do
  path '/etc/apache2/conf-available/thruk.conf'
  action :create_if_missing
  only_if do
    Dir.exists?('/etc/apache2/conf-available/')
  end
end

begin
  include_recipe "thruk::#{node['platform_family']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.warn "A thruk recipe does not exist for the platform_family: #{node['platform_family']}"
end

remote_directory "#{node['thruk']['docroot']}/icons" do
  mode 0755
end

template "#{node['apache']['dir']}/sites-available/thruk.conf" do
  source 'thruk-apache2.conf.erb'
  mode 00644
  variables(
    :port => node['thruk']['apache']['port'].empty? ? '80' : node['thruk']['apache']['port']
  )
  if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/thruk.conf")
    notifies :reload, 'service[apache2]', :immediately
  end
end

apache_site 'thruk' do
  enable true
end

directory '/var/cache/thruk' do
  group node['apache']['group']
  mode '0770'
  action :create
end

directory '/var/log/thruk' do
  group node['apache']['group']
  mode '0770'
  action :create
end


file "#{node['apache']['dir']}/conf.d/thruk.conf" do
  action :delete
  notifies :reload, 'service[apache2]', :delayed
end

if node['thruk']['use_ssl']
  cookbook_file "#{node['apache']['dir']}/ssl/#{node['thruk']['cert_name']}.crt" do
    source "certs/#{node['thruk']['cert_name']}.crt"
    notifies :restart, "service[apache2]"
  end

  cookbook_file "#{node['apache']['dir']}/ssl/#{node['thruk']['cert_name']}.key" do
    source "certs/#{node['thruk']['cert_name']}.key"
    notifies :restart, "service[apache2]"
  end

  cookbook_file "#{node['apache']['dir']}/ssl/#{node['thruk']['cert_ca_name']}.crt" do
    source "certs/#{node['thruk']['cert_ca_name']}.crt"
    not_if { node['thruk']['cert_ca_name'].nil? }
    notifies :restart, "service[apache2]"
  end
end

template "#{node['thruk']['conf_dir']}/cgi.cfg" do
  mode 0644
  notifies :restart, 'service[apache2]', :immediately
end

template "#{node['thruk']['conf_dir']}/thruk_local.conf" do
  mode 0644
end

service 'thruk' do
  action [:enable, :start]
  ignore_failure true
  subscribes :restart, "cookbook_file[#{node['thruk']['conf_dir']}/thruk_local.conf]", :delayed
end

