#
# Cookbook:: codenamephp_localmail
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'codenamephp_localmail::default' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the default jre' do
      expect(chef_run).to install_package('default-jre')
    end

    it 'installs the jar file' do
      expect(chef_run).to create_remote_file('Download MockMock.jar').with(
        source: 'https://github.com/tweakers-dev/MockMock/blob/master/release/MockMock.jar?raw=true',
        path: '/var/opt/MockMock.jar',
        owner: 'root',
        group: 'root',
        mode: 0o755
      )
    end

    it 'installs the init script' do
      expect(chef_run).to create_template('Manage service startup script').with(
        source: 'mockmock.erb',
        path: '/etc/init.d/mockmock',
        owner: 'root',
        group: 'root',
        mode: 0o755
      )
    end

    it 'starts and enables the service' do
      expect(chef_run).to start_service('mockmock')
      expect(chef_run).to enable_service('mockmock')
    end
  end
end
