# frozen_string_literal: true

name 'codenamephp_localmail'
maintainer 'Bastian Schwarz'
maintainer_email 'bastian@codename-php.de'
license 'Apache-2.0'
description 'Cookbook that installs a local mailserver and mail client for local only mail used during development'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.1.0'
chef_version '>= 13.0' if respond_to?(:chef_version)
issues_url 'https://github.com/codenamephp/chef.cookbook.localmail/issues' if respond_to?(:issues_url)
source_url 'https://github.com/codenamephp/chef.cookbook.localmail' if respond_to?(:source_url)

supports 'debian', '~>9.1'

depends 'codenamephp_docker', '~> 3.1'
depends 'docker', '~>7.0'
