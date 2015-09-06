require 'spec_helper'

if os[:family] == 'redhat'
  describe yumrepo('epel') do
    it { should be_enabled }
  end

  describe yumrepo('labs_consol_stable') do
    it { should be_enabled }
  end

  describe package('thruk') do
    it { should be_installed }
  end
end
