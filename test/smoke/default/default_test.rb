# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'localmail-1.0' do
  title 'Install mailserver for localmail'
  desc 'Install a mailserver, make sure mails can be sent but are only delivered locally'

  sleep(5) # adding sleep to give postfix some time to start

  describe service('postfix') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe command('printf "Subject: This is a test\nMy message" | sudo sendmail test@test.de') do
    its('exit_status') { should eq 0 }
  end

  describe file('/var/mail/root') do
    it { should exist }
    its('content.strip') { should match(/Subject: This is a test/) }
  end
end
