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

### Attributes
