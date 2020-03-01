# Chef Cookbook Localmail
[![Build Status](https://travis-ci.org/codenamephp/chef.cookbook.localmail.svg?branch=dev)](https://travis-ci.org/codenamephp/chef.cookbook.localmail)

Cookbook that installs a local mailserver and mail client for local only mail used during development.

## Requirements

### Supported Platforms

- Debian Buster (probably works with older versions as well)

### Chef

- Chef 13.0+

### Cookbook Depdendencies

- apt
- codenamephp_docker

## Usage

Add the cookbook to your Berksfile:

```ruby
cookbook 'codenamephp_localmail'
```


Build a wrapper cookbook and use the resources as needed.

### Resources

#### Mailhog

Mailhog is a mail trap for local development. It offers a nice
web UI and also advanced features like a JSON REST API.

This resource installs mailhog as docker container to avoid any other
build or runtime dependencies (short of docker of course, but chances are
docker is already used).

It also install a custom sendmail script that relays the calls to the
sendmail within the docker container.

##### Properties
- `webui_port` (Integer): The port on the host whre the web ui will be available at, defaults to `8025`
- `sendmail_install_path` (String): The path to where the custom sendmail is installed to, defaults to `/usr/sbin/sendmail`

##### Examples

With minimal properties:
```ruby
# Install
codenamephp_localmail_mailhog 'install mailhog'

# Uninstall
codenamephp_localmail_mailhog 'uninstall mailhog' do
  action :uninstall
end
```
With custom port and path:
```ruby
# Install
codenamephp_localmail_mailhog 'install mailhog' do
  webui_port 1234
  sendmail_install_path '/some/other/path'
end

# Uninstall - webui_port is not relevant here
codenamephp_localmail_mailhog 'uninstall mailhog' do
  sendmail_install_path '/some/ohter/path'
end
```