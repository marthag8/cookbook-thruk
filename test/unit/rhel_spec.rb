describe 'thruk::rhel' do
  context 'When all attributes are default, on centos 6.6 platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes yum-epel' do
      expect(chef_run).to include_recipe('yum-epel::default')
    end

    it 'includes yum' do
      expect(chef_run).to include_recipe('yum::default')
    end

    it 'add thruk yum repo' do
      expect(chef_run).to create_yum_repository('labs_consol_stable')
    end

    it 'installs thruk' do
      expect(chef_run).to install_package('thruk').with(version: '2.00-1')
    end
  end
end
