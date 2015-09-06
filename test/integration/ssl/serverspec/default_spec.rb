require 'spec_helper'
require 'default_shared'

describe file('/usr/share/thruk/root/thruk/icons/test.jpg') do
  it { should be_file }
end

describe file('/usr/share/thruk/root/thruk/icons/test.png') do
  it { should be_file }
end

describe command('apachectl -M') do
  its(:stdout) { should contain('ssl_module') }
end

describe command('curl localhost/thruk/') do
  its(:stdout) { should match(/301 Moved Permanently/) }
end

# describe command('curl localhost/thruk/index.html -u thrukadmin:thrukadmin') do
#   its(:stdout) { should contain('This page requires a web browser which supports frames.') }
# end
