require "minitest"
require "minitest/sequel/version"
require "sequel"
require "sequel/extensions/inflector" unless "".respond_to?(:classify)

# reopening to add additional functionality
module Minitest::Assertions


  private

  # handles converting `:nil`, `:false` values
  def _convert_value(val)
    v = case val
        when :nil    then nil
        when :false  then false
        when :true   then true
        else
          val
        end
    v
  end

end

require "minitest/sequel/columns"
require "minitest/sequel/associations"
require "minitest/sequel/validations"
