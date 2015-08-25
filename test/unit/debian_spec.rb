describe 'thruk::debian' do
  context 'When all attributes are default, on ubuntu 14.10 platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.10')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds thruk apt repo' do
      expect(chef_run).to add_apt_repository('labs-thruk')
    end

    it 'installs thruk' do
      expect(chef_run).to install_package('thruk')
    end
  end
end
