# frozen_string_literal: true

control 'mailhog-uninstall-1.0' do
  title 'Uinstall mailhog'
  desc 'Remove mailhog from docker and mhsendmail'

  docker_image('mailhog/mailhog') do
    it { should_not exist }
  end

  docker_container('mailhog') do
    it { should_not exist }
    it { should_not be_running }
  end

  describe command('sendmail') do
    it { should_not exist }
  end
end
