#
# Cookbook:: codenamephp_localmail
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

include_recipe 'apt'

package 'default-jre'

remote_file 'Download MockMock.jar' do
  source node['codenamephp_localmail']['mockmock']['urls']['jar']
  path node['codenamephp_localmail']['mockmock']['paths']['jar']
  owner 'root'
  group 'root'
  mode 0o755
  notifies :restart, 'service[mockmock]', :delayed
end

template 'Manage service startup script' do
  source 'mockmock.erb'
  path '/etc/init.d/mockmock'
  owner 'root'
  group 'root'
  mode 0o755
  notifies :restart, 'service[mockmock]', :delayed
end

service 'mockmock' do
  action %i[enable start]
end
