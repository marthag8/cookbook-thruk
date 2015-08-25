require 'chefspec'
ChefSpec::Coverage.start!
require 'chefspec/berkshelf'

Dir['./test/unit/support/*.rb'].sort.each { |f| require f }
