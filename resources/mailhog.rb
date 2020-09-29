# frozen_string_literal: true

property :webui_port,
         Integer,
         default: 8025,
         description: 'The local port from where the web ui will be available'
property :sendmail_install_path,
         String,
         default: '/usr/sbin/sendmail',
         description: 'The path to where the mhsendmail binary will be downloaded, should be an executable path'

action :install do
  codenamephp_docker_service 'Install docker'

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

  template 'install sendmail for mailhog' do
    source 'mailhog/sendmail.erb'
    cookbook 'codenamephp_localmail'
    path new_resource.sendmail_install_path
    owner 'root'
    group 'root'
    mode '0755'
  end

  group 'add www-data user to docker group' do
    action :manage
    append true
    group_name 'docker'
    members 'www-data'
  end
end

action :uninstall do
  codenamephp_docker_service 'Install docker'

  docker_container 'remove mailhog container' do
    container_name 'mailhog'
    action %i(stop delete)
  end

  docker_image 'remove mailhog image' do
    action :remove
    repo 'mailhog/mailhog'
  end

  file 'remove sendmail' do
    path new_resource.sendmail_install_path

    action :delete
  end
end
