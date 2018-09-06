# Inspec test for recipe codenamephp_localmail::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'localmail-1.0' do
  title 'Install postfix and thunderbird'
  desc 'Install postfix and thunderbird and make sure all mails are relayed to local'

  describe package('postfix') do
    it { should be_installed }
  end
end
