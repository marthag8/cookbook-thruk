require 'spec_helper'

if %w(debian ubuntu).include?(os[:family])

  describe file('/var/lib/apt/periodic/update-success-stamp') do
    it { should exist }
  end

  describe command('apt-cache policy') do
    its(:stdout) { should contain('labs.consol.de/repo/stable') }
  end

  describe package('thruk') do
    it { should be_installed }
  end

end
