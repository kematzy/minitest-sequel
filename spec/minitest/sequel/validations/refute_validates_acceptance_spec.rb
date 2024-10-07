# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#refute_validates_acceptance(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_acceptance_of(:urlslug)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when column is NOT validated' do
        assert_no_error { refute_validates_acceptance(@m, :author_id) }

        assert_no_error { refute_validates(@m, :acceptance, :author_id) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when column is validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* NOT to validate :urlslug with :acceptance, but the column :urlslug was validated with :acceptance/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { refute_validates_acceptance(@m, :urlslug) }
      end

      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) { refute_validates_acceptance(@m, :does_not_exist) }
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) { refute_validates_acceptance(@m, :id) }
      end
    end
    # /should raise an error
  end
  # /#refute_validates_acceptance(:model, :attribute, :opts, :msg)
end
