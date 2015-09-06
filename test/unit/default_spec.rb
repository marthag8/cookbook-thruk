describe 'thruk::default' do
  context 'When all attributes are default, on centos 6.6 platform' do
    before do
      stub_command('/usr/sbin/httpd -t').and_return('Syntax OK')
      stub_command('which php').and_return('/usr/bin/php')
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes apache recipes' do
      %w(apache2 apache2::mod_rewrite apache2::mod_php5 apache2::mod_fcgid).each do |inc|
        expect(chef_run).to include_recipe(inc)
      end
    end

    it 'does not includes apache2::mod_ssl' do
      expect(chef_run).to_not include_recipe('apache2::mod_ssl')
    end

    it 'includes thruk::rhel' do
      expect(chef_run).to include_recipe('thruk::rhel')
    end

    it 'creates icons dir' do
      expect(chef_run).to create_remote_directory('/usr/share/thruk/root/thruk/icons')
    end

    it 'creates thruk_local.conf template' do
      expect(chef_run).to create_template('/etc/thruk/thruk_local.conf')
    end

    it 'deletes apache conf.d/thruk.conf' do
      expect(chef_run).to delete_file('/etc/httpd/conf.d/thruk.conf')
    end

    it 'create plugins-enabled directory' do
      expect(chef_run).to create_directory('/etc/thruk/plugins/plugins-enabled')
    end

    it 'installs plugins' do
      %w(dashboard minemap mobile panorama reports2 statusmap).each do |plugin|
        expect(chef_run).to create_link("/etc/thruk/plugins/plugins-enabled/#{plugin}").with(to: "/etc/thruk/plugins/plugins-available/#{plugin}")
      end
    end

    it 'does not create ssl key' do
      expect(chef_run).to_not create_cookbook_file('/etc/httpd/ssl/fauxhai.local.key')
    end

    it 'does not create ssl cert' do
      expect(chef_run).to_not create_cookbook_file('/etc/httpd/ssl/fauxhai.local.crt')
    end

    it 'does not create /etc/default/thruk' do
      expect(chef_run).to_not create_template('/etc/default/thruk')
    end

    it 'installs apache site thruk.conf' do
      expect(chef_run).to create_template('/etc/httpd/sites-available/thruk.conf')
    end

    it 'create cgi.cfg template' do
      expect(chef_run).to create_template('/etc/thruk/cgi.cfg')
    end

    it 'will enable the thruk apache site' do
      expect(chef_run).to_not run_execute('/usr/sbin/a2ensite thruk.conf')
    end

    it 'sets up thruk service' do
      expect(chef_run).to enable_service('thruk')
      expect(chef_run).to start_service('thruk')
    end
  end

  context 'When all use_ssl is true, on centos 6.6 platform' do
    before do
      stub_command('/usr/sbin/httpd -t').and_return('Syntax OK')
      stub_command('which php').and_return('/usr/bin/php')
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6') do |node|
        node.set['thruk']['use_ssl'] = true
        node.set['thruk']['cert_ca_name'] = 'test_bundle'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes apache2::mod_ssl' do
      expect(chef_run).to include_recipe('apache2::mod_ssl')
    end

    it 'creates ssl key' do
      expect(chef_run).to create_cookbook_file('/etc/httpd/ssl/fauxhai.local.key')
    end

    it 'creates ssl cert' do
      expect(chef_run).to create_cookbook_file('/etc/httpd/ssl/fauxhai.local.crt')
    end

    it 'creates ssl ca cert' do
      expect(chef_run).to create_cookbook_file('/etc/httpd/ssl/test_bundle.crt')
    end

    it 'does creates /etc/default/thruk' do
      expect(chef_run).to create_template('/etc/default/thruk')
    end
  end
end
