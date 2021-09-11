# frozen_string_literal: true

name 'codenamephp_localmail'
maintainer 'Bastian Schwarz'
maintainer_email 'bastian@codename-php.de'
license 'Apache-2.0'
description 'Cookbook that installs a local mailserver and mail client for local only mail used during development'
version '3.2.0'
chef_version '>= 15.3'
issues_url 'https://github.com/codenamephp/chef.cookbook.localmail/issues'
source_url 'https://github.com/codenamephp/chef.cookbook.localmail'

supports 'debian'

depends 'codenamephp_docker', '~> 3.1'
depends 'docker', '~>8.0'
