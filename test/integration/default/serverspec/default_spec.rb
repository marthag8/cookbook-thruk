require 'spec_helper'
require 'default_shared'

describe command('apachectl -M') do
  its(:stdout) { should_not contain('ssl_module') }
end

describe command('curl localhost/thruk/') do
  its(:stdout) { should match(/401 (Authorization Required|Unauthorized)/) }
end

describe command('curl localhost/thruk/index.html -u thrukadmin:thrukadmin') do
  its(:stdout) { should contain('This page requires a web browser which supports frames.') }
end
