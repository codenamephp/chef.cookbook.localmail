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

    it 'includes the apt cookbook' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'installs postfix from package' do
      expect(chef_run).to install_package('postfix')
    end
  end
end
