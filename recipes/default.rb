#
# Cookbook:: codenamephp_localmail
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

include_recipe 'apt'

package 'postfix'

# install postfix config

package 'sylpheed'

# install account for localmail
