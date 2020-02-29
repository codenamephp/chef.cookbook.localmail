property :webui_port,
         Integer,
         required: true,
         default: 8025,
         description: 'The local port from where the web ui will be available'
property :mhsendmail_source_uri,
         required: true,
         default: 'https://github.com/mailhog/mhsendmail/releases/latest/download/mhsendmail_linux_amd64',
         description: 'Source from where the mhsendmail will be downloaded'
property :mhsendmail_install_path,
         required: true,
         default: '/usr/sbin/sendmail',
         description: 'The path to where the mhsendmail binary will be downloaded, should be an executable path'

action :install do
  include_recipe 'codenamephp_docker::service'

  docker_image 'pull mailhog image' do
    action :pull_if_missing
    repo 'mailhog/mailhog'
  end

  docker_container 'run mailhog' do
    container_name 'mailhog'
    repo 'mailhog/mailhog'
    port ['1025:1025', "#{new_resource.webui_port}:8025"]
    restart_policy 'always'
  end

  package 'remove sendmail package' do
    package_name 'sendmail'
    action :purge
  end

  file 'remove mhsendmail' do
    path new_resource.mhsendmail_install_path
    action :delete
  end

  remote_file 'download mhsendmail' do
    source new_resource.mhsendmail_source_uri
    path new_resource.mhsendmail_install_path
    owner 'root'
    group 'root'
    mode '0755'
    action :create_if_missing
  end
end

action :uninstall do
  include_recipe 'codenamephp_docker::service'

  docker_container 'remove mailhog container' do
    container_name 'mailhog'
    action %i[stop delete]
  end

  docker_image 'remove mailhog image' do
    action :remove
    repo 'mailhog/mailhog'
  end

  file 'remove mhsendmail' do
    path new_resource.mhsendmail_install_path
    action :delete
  end
end
