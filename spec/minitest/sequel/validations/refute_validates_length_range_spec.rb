# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#refute_validates_length_range(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_length_of(:title, within: 10..20)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when column is NOT validated' do
        assert_no_error { refute_validates_length_range(@m, :author_id, 10..20) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when column is validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { refute_validates_length_range(@m, :title, 10..20) }
      end

      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) { refute_validates_length_range(@m, :does_not_exist, 10..20) }
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) { refute_validates_length_range(@m, :id, 10..20) }
      end
    end
    # /should raise an error
  end
  # /#refute_validates_length_range(:model, :attribute, :opts, :msg)
end