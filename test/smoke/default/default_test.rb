# Inspec test for recipe codenamephp_localmail::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'localmail-1.0' do
  title 'Install MockMock as local mail server and client'
  desc 'Install MockMock JAR and init script and make sure the service is running and the web ui is reachable'

  describe service('mockmock') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  sleep 10 # meh, but the service needs a moment to spin up and there is no wait in inspec

  describe http('http://localhost:8085') do
    its('status') { should cmp 200 }
    its('body.strip') { should match(Regexp.new('MockMock')) }
  end
end
