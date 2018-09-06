# Inspec test for recipe codenamephp_localmail::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'localmail-1.0' do
  title 'Install postfix and mail client'
  desc 'Install postfix and mailclient and make sure all mails are relayed to local'

  describe package('postfix') do
    it { should be_installed }
  end

  describe package('sylpheed') do
    it { should be_installed }
  end
end
