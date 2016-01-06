require 'minitest'
require 'minitest/sequel/version'
require 'sequel'
require 'sequel/extensions/inflector' unless ''.respond_to?(:classify)

# reopening to add additional functionality
module Minitest::Assertions
  
  
  
  end
  
end

require 'minitest/sequel/columns'
require 'minitest/sequel/associations'
require 'minitest/sequel/validations'
