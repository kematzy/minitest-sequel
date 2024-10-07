# frozen_string_literal: false

require 'minitest'
require 'minitest/sequel/version'
require 'sequel'
require 'sequel/extensions/inflector' unless ''.respond_to?(:classify)

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  module Assertions
    private

    # handles converting `:nil`, `:false` values
    # rubocop:disable Lint/BooleanSymbol
    def _convert_value(val)
      case val
      when :nil    then nil
      when :false  then false
      when :true   then true
      else
        val
      end
    end
    # rubocop:enable Lint/BooleanSymbol
  end
end

require 'minitest/sequel/columns'
require 'minitest/sequel/associations'
require 'minitest/sequel/validations'
require 'minitest/sequel/plugins'
require 'minitest/sequel/helpers'
