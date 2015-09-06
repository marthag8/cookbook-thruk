
# apache-related tests
describe service('httpd'), if: os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('apache2'), if: %w(debian ubuntu).include?(os[:family]) do
  unless (os[:family] == 'debian' && os[:release] == '8.1') || (os[:family] == 'ubuntu' && os[:release] == '15.04')
    it { should be_enabled }
  end
  it { should be_running }
end

describe command('apachectl -M') do
  %w(rewrite php5 fcgid).each do |mod|
    its(:stdout) { should contain("#{mod}_module") }
  end
end

describe command('apachectl -D DUMP_VHOSTS') do
  its(:stdout) { should_not contain('000-default') }
  its(:stdout) { should contain('sites-enabled/thruk.conf') }
end

describe file('/etc/httpd/conf.d/thruk.conf'), if: os[:family] == 'redhat' do
  it { should_not exist }
end

describe file('/etc/httpd/conf-enabled/thruk.conf'), if: os[:family] == 'redhat' do
  it { should_not exist }
end

describe file('/etc/apache2/conf.d/thruk.conf'), if: %w(debian ubuntu).include?(os[:family]) do
  it { should_not exist }
end

describe file('/etc/apache2/conf-enabled/thruk.conf'), if: %w(debian ubuntu).include?(os[:family]) do
  it { should_not exist }
end

describe file('/etc/apache2/conf-enabled/thruk_cookie_auth_vhost.conf'), if: %w(debian ubuntu).include?(os[:family]) do
  it { should_not exist }
end

# thruk tests
describe file('/usr/share/thruk/root/thruk/icons') do
  it { should be_directory }
end

# plugins
%w(dashboard minemap mobile panorama reports2 statusmap).each do |plugin|
  describe file("/etc/thruk/plugins/plugins-enabled/#{plugin}") do
    it { should be_symlink }
  end
end

describe file('/etc/thruk/thruk_local.conf') do
  it { should exist }
  its(:content) { should match(/logo_path_prefix/) }
end

describe file('/etc/thruk/cgi.cfg') do
  it { should exist }
  its(:content) { should match(/authorized_for_system_information=thrukadmin/) }
end

describe service('thruk') do
  unless (os[:family] == 'debian' && os[:release] == '8.1') || (os[:family] == 'ubuntu' && os[:release] == '15.04')
    it { should be_enabled }
  end
  it { should be_running }
end
