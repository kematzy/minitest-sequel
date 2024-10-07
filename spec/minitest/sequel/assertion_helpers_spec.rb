# frozen_string_literal: true

require_relative '../../spec_helper'

# rubocop:disable Lint/BooleanSymbol
describe Minitest::Assertions do
  describe '_convert_value(:val)' do
    describe 'converts' do
      it ':nil to nil' do
        assert_nil _convert_value(:nil)
      end

      it ':false to false' do
        assert_equal false, _convert_value(:false)
      end

      it ':true to true' do
        assert_equal true, _convert_value(:true)
      end
    end

    describe 'does not convert' do
      it 'string value' do
        assert_equal 'test', _convert_value('test')
      end

      it 'integer value' do
        assert_equal 42, _convert_value(42)
      end
    end
  end
end
# rubocop:enable Lint/BooleanSymbol
