#
# Cookbook:: codenamephp_localmail
# Spec:: postfix
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'codenamephp_localmail::postfix' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end
    let(:install_makefile) { chef_run.cookbook_file('install makefile for managing configurations') }
    let(:install_chef_header) { chef_run.template('apply chef header config') }
    let(:install_local_cf) { chef_run.template('apply local config') }
    let(:install_local_destinations_table) { chef_run.cookbook_file('copy destination table for local config') }
    let(:copy_main_cf) { chef_run.file('copy default main.cf to dropfolder') }
    let(:generate_config) { chef_run.execute('generate config') }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes apt cookbook' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'will insall postfix from package with preseed' do
      expect(chef_run).to install_package('postfix').with(response_file: 'postfix/preseed.erb')
    end

    it 'will install postfix-pcre package' do
      expect(chef_run).to install_package('postfix-pcre')
    end

    it 'will install make from package' do
      expect(chef_run).to install_package('make')
    end

    it 'will install the makefile for config management and notify config generetion' do
      expect(chef_run).to create_cookbook_file('install makefile for managing configurations')
      expect(install_makefile).to notify('execute[generate config]').to(:run).delayed
    end

    it 'sets up config generation' do
      expect(chef_run).to nothing_execute('generate config').with(
        command: 'make',
        cwd: '/etc/postfix'
      )
      expect(generate_config).to notify('service[postfix]').to(:restart).delayed
    end

    it 'will create main.cf.d dropfolder' do
      expect(chef_run).to create_directory('create main.cf.d dropfolder').with(
        path: '/etc/postfix/main.cf.d',
        mode: 0o755
      )
    end

    it 'will copy default main.cf to dropfolder and regenerate config' do
      allow(File).to receive(:open).and_call_original
      allow(File).to(receive(:open).with('/etc/postfix/main.cf') do
        double = double(File)
        allow(double).to receive(:read).and_return 'some content'
        double
      end)

      expect(chef_run).to create_if_missing_file('copy default main.cf to dropfolder').with(
        path: '/etc/postfix/main.cf.d/010-main.cf',
        content: 'some content'
      )
      expect(copy_main_cf).to notify('execute[generate config]').to(:run).delayed
    end

    it 'will install chef header and regenerate config' do
      expect(chef_run).to create_template('apply chef header config').with(
        path: '/etc/postfix/main.cf.d/000-chef_header.cf',
        source: 'postfix/main.cf.d/000-chef_header.cf',
        owner: 'root',
        group: 'root'
      )
      expect(install_chef_header).to notify('execute[generate config]').to(:run).delayed
    end

    it 'will install chef local.nf and regenerate config' do
      expect(chef_run).to create_template('apply local config').with(
        path: '/etc/postfix/main.cf.d/100-local.cf',
        source: 'postfix/main.cf.d/100-local.cf.erb',
        owner: 'root',
        group: 'root'
      )
      expect(install_local_cf).to notify('execute[generate config]').to(:run).delayed
    end

    it 'will install local destination table and restart postfix' do
      expect(chef_run).to create_cookbook_file('copy destination table for local config').with(
        path: '/etc/postfix/mydestinations',
        source: 'postfix/mydestinations'
      )
      expect(install_local_destinations_table).to notify('service[postfix]').to(:restart).delayed
    end

    it 'starts and enables postfix service' do
      expect(chef_run).to start_service('postfix')
      expect(chef_run).to enable_service('postfix')
    end
  end
end
