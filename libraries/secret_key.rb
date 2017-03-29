module Thruk
  module Helpers
    def secret_key(node)
      require 'digest'
      node.normal_unless['thruk']['secret_key'] = Digest::MD5.new.hexdigest Random.new_seed.to_s
      return node['thruk']['secret_key']
    end
  end
end