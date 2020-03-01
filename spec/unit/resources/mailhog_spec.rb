# frozen_string_literal: true

require 'spec_helper'

describe 'codenamephp_localmail_mailhog' do
  platform 'debian' # https://github.com/chefspec/chefspec/issues/953

  step_into :codenamephp_localmail_mailhog

  context 'Install with minimal attributes' do
    recipe do
      codenamephp_localmail_mailhog 'install mailhog'
    end

    it {
      is_expected.to include_recipe('codenamephp_docker::service')

      is_expected.to pull_if_missing_docker_image('pull mailhog image').with(
        repo: 'mailhog/mailhog'
      )

      is_expected.to run_docker_container('run mailhog').with(
        container_name: 'mailhog',
        repo: 'mailhog/mailhog',
        port: ['1025:1025', '8025:8025'],
        restart_policy: 'always'
      )

      is_expected.to purge_package('remove sendmail package').with(
        package_name: 'sendmail'
      )

      is_expected.to create_template('install sendmail for mailhog').with(
        source: 'mailhog/sendmail.erb',
        path: '/usr/sbin/sendmail',
        cookbook: 'codenamephp_localmail',
        owner: 'root',
        group: 'root',
        mode: '0755'
      )

      is_expected.to manage_group('add www-data user to docker group').with(
        append: true,
        group_name: 'docker',
        members: ['www-data']
      )
    }
  end

  context 'Install with custom webui port' do
    recipe do
      codenamephp_localmail_mailhog 'install mailhog' do
        webui_port 1234
      end
    end

    it {
      is_expected.to run_docker_container('run mailhog').with(
        port: ['1025:1025', '1234:8025']
      )
    }
  end

  context 'Install with custom install path' do
    recipe do
      codenamephp_localmail_mailhog 'install mailhog' do
        sendmail_install_path '/some/path'
      end
    end

    it {
      is_expected.to create_template('install sendmail for mailhog').with(
        path: '/some/path'
      )
    }
  end

  context 'Uninstall with minimal attributes' do
    recipe do
      codenamephp_localmail_mailhog 'uninstall mailhog' do
        action :uninstall
      end
    end

    it {
      is_expected.to include_recipe('codenamephp_docker::service')

      is_expected.to stop_docker_container('remove mailhog container').with(
        container_name: 'mailhog',
        action: %i[stop delete]
      )

      is_expected.to remove_docker_image('remove mailhog image').with(
        repo: 'mailhog/mailhog'
      )

      is_expected.to delete_file('remove sendmail').with(
        path: '/usr/sbin/sendmail'
      )
    }
  end

  context 'Uninstall with custom install path' do
    recipe do
      codenamephp_localmail_mailhog 'uninstall mailhog' do
        action :uninstall
        sendmail_install_path '/some/path'
      end
    end

    it {
      is_expected.to delete_file('remove sendmail').with(
        path: '/some/path'
      )
    }
  end
end
