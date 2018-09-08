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
	  "recipe[codenamephp_localmail::postfix]"
  ]
}
```

### Cookbooks

#### Default

As per usual, the default cookbook is a no-op since it makes it easier to choose the tools by just adding the recipes which causes less concerns for backwards
compatiblity.

#### Postfix

Installs [postfix][postfix_url] in "local only" mode by preseeding the apt install. It also adds a main.cf.d folder and a make file that reads all .cf files from the folder and combines
them to the main.cf config so managing config becomes easier.

All mails are relayed to a local user. The user can be chosen via the attributes.

### Attributes
- `default['codenamephp_localmail']['postfix']['preseed']['main_mailer_type']` The mailer type used when preseeding the postfix install, defaults to `Local only`
- `default['codenamephp_localmail']['postfix']['preseed']['mailname']` The mailname used when preseeding the postfix install, defaults to `stretch.localdomain`
- `default['codenamephp_localmail']['postfix']['local']['user_relay']` The user the mails will be relayed to, defaults to `wwwdev@localhost` which means the mails will be relayed to the wwwdev user


[postfix_url]: http://www.postfix.org/
