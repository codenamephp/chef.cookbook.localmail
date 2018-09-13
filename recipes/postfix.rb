#
# Cookbook:: codenamephp_localmail
# Recipe:: postfix
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

include_recipe 'apt'

package 'postfix' do
  response_file 'postfix/preseed.erb'
end
package 'postfix-pcre'

package 'make'

cookbook_file 'install makefile for managing configurations' do
  path '/etc/postfix/Makefile'
  source 'postfix/Makefile'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :run, 'execute[generate config]', :delayed
end

execute 'generate config' do
  command 'make'
  cwd '/etc/postfix'
  user 'root'
  action :nothing # only when notified
  notifies :restart, 'service[postfix]', :delayed
end

directory 'create main.cf.d dropfolder' do
  path '/etc/postfix/main.cf.d'
  mode 0o755
end

file 'copy default main.cf to dropfolder' do
  path '/etc/postfix/main.cf.d/010-main.cf'
  content(lazy { ::File.open('/etc/postfix/main.cf').read })
  action :create_if_missing
  notifies :run, 'execute[generate config]', :delayed
end

template 'apply chef header config' do
  path '/etc/postfix/main.cf.d/000-chef_header.cf'
  source 'postfix/main.cf.d/000-chef_header.cf'
  owner 'root'
  group 'root'
  notifies :run, 'execute[generate config]', :delayed
end

template 'apply local config' do
  path '/etc/postfix/main.cf.d/100-local.cf'
  source 'postfix/main.cf.d/100-local.cf.erb'
  owner 'root'
  group 'root'
  notifies :run, 'execute[generate config]', :delayed
end

cookbook_file 'copy destination table for local config' do
  path '/etc/postfix/mydestinations'
  source 'postfix/mydestinations'
  notifies :restart, 'service[postfix]', :delayed
end

service 'postfix' do
  action %i[enable start]
end
