require 'spec_helper'

if %w(debian ubuntu).include?(os[:family])

  describe command('apt-cache policy') do
    its(:stdout) { should contain('labs.consol.de/repo/stable') }
  end

  describe package('thruk') do
    it { should be_installed.with_version('2.00') }
  end

end
