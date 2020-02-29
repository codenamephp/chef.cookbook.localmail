# frozen_string_literal: true

control 'mailhog.install-1.0' do
  title 'Install mailhog'
  desc 'Install mailhog and mhsendmail'

  docker_image('mailhog/mailhog') do
    it { should exist }
  end

  docker_container('mailhog') do
    it { should exist }
    it { should be_running }
    its('ports') { should eq ['1025:1025', '1234:8025'] }
  end

  describe command('sendmail') do
    it { should exist }
  end

  describe command('sendmail -- test@mailhog.local <<_EOF
        From: App <app@mailhog.local>
        To: Test <test@mailhog.local>
        Subject: Test message

        Some content!

        _EOF
        ') do
    its('exit_status') { should eq 0 }
  end

  describe http('http://localhost:8025/api/v2/messages') do
    its('status') { should eq 200 }
    its('body') { should match(/Subject: Test message/) }
  end
end
