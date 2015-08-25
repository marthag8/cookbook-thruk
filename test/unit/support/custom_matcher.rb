if defined?(ChefSpec)
  ChefSpec.define_matcher :shinken2_module

  def create_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :create, resource_name)
  end

  def add_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
  end
end
