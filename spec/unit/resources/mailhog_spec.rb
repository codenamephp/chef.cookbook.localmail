require 'spec_helper'

describe 'codenamephp_localmail_mailhog' do
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

      is_expected.to create_if_missing_remote_file('download mhsendmail').with(
        source: 'https://github.com/mailhog/mhsendmail/releases/latest/download/mhsendmail_linux_amd64',
        path: '/usr/sbin/sendmail',
        owner: 'root',
        group: 'root',
        mode: '0755'
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

  context 'Install with custom source uri and install path' do
    recipe do
      codenamephp_localmail_mailhog 'install mailhog' do
        mhsendmail_source_uri 'https://localhost/source'
        mhsendmail_install_path '/some/path'
      end
    end

    it {
      is_expected.to create_if_missing_remote_file('download mhsendmail').with(
        source: 'https://localhost/source',
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

      is_expected.to delete_file('remove mhsendmail').with(
        path: '/usr/sbin/sendmail'
      )
    }
  end

  context 'Uninstall with custom install path' do
    recipe do
      codenamephp_localmail_mailhog 'uninstall mailhog' do
        action :uninstall
        mhsendmail_install_path '/some/path'
      end
    end

    it {
      is_expected.to delete_file('remove mhsendmail').with(
        path: '/some/path'
      )
    }
  end
end
