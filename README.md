# Chef Cookbook Localmail
[![Build Status](https://travis-ci.org/codenamephp/chef.cookbook.localmail.svg?branch=dev)](https://travis-ci.org/codenamephp/chef.cookbook.localmail)

Cookbook that installs a local mailserver and mail client for local only mail used during development.

## Requirements

### Supported Platforms

- Debian Stretch

### Chef

- Chef 13.0+

### Cookbook Depdendencies

- apt

## Usage

Add the cookbook to your Berksfile:

```ruby
cookbook 'codenamephp_localmail'
```

Add the gui cookbook to your runlist, e.g. in a role:

```json
{
  "name": "default",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "run_list": [
	  "recipe[codenamephp_localmail]"
  ]
}
```

### Cookbooks

#### Default

The default cookbooks installs the default-jre and downloads [MockMock][mockmock_url] and installs it as a local service. A web ui is started (by default on http://localhost:8085) to view the mail.

### Attributes
- `default['codenamephp_localmail']['mockmock']['urls']['jar']` The url to the Mockmock source file, defaults to `'https://github.com/tweakers-dev/MockMock/blob/master/release/MockMock.jar?raw=true'`
- `default['codenamephp_localmail']['mockmock']['paths']['jar']` The path to where the jar file will be installed, defaults to `'/var/opt/MockMock.jar'`
- `default['codenamephp_localmail']['mockmock']['ports']['smtp']` The smtp port MockMock will listen to, defaults to `25`
- `default['codenamephp_localmail']['mockmock']['ports']['web']` The port where the web ui will be listening, defaults to `8085`


[mockmock_url]: https://github.com/tweakers-dev/MockMock/
