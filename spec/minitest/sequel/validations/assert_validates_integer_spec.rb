# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_integer(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_numericality_of(:id, only_integer: true)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the presence of Post#title' do
        assert_no_error { assert_validates_integer(@m, :id) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when validating a valid provided options' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :numericality for :id column with: { message: 'dummy', only_integer: 'true' } but found: { message: 'is not a number' }/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_integer(@m, :id, { message: 'dummy' }) }
      end

      describe 'when validating an incorrect provided option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :numericality for :id column with: { message: 'dummy', only_integer: 'true' } but found: { message: 'is not a number' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_integer(@m, :id, { message: 'dummy' }) }
        end

        %i[nil_message too_long too_short wrong_length].each do |t|
          it ":#{t}" do
            msg = /the following invalid option\(s\) was found: \{ :#{t};  \}/

            assert_error_raised(msg) { assert_validates_integer(@m, :id, { t.to_sym => 'dummy' }) }
          end
        end

        it ':is' do
          # rubocop:disable Layout/LineLength
          msg = /invalid option\(s\) was found: \{ :is;  \}. Valid options are: \[:message, :only_integer\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_integer(@m, :id, { is: 10 }) }
        end

        it ':minimum' do
          # rubocop:disable Layout/LineLength
          msg = /invalid option\(s\) was found: \{ :minimum;  \}. Valid options are: \[:message, :only_integer\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_integer(@m, :id, { minimum: 10 }) }
        end

        it ':maximum' do
          # rubocop:disable Layout/LineLength
          msg = /invalid option\(s\) was found: \{ :maximum;  \}. Valid options are: \[:message, :only_integer\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_integer(@m, :id, { maximum: 20 }) }
        end

        it ':within' do
          # rubocop:disable Layout/LineLength
          msg = /invalid option\(s\) was found: \{ :within;  \}. Valid options are: \[:message, :only_integer\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_integer(@m, :id, { within: 10..20 }) }
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        msg = /validate :numericality for :title column, but no validations are defined for :title/

        assert_error_raised(msg) { assert_validates_integer(@m, :title) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_integer(@m, :does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_integer(:model, :attribute, :opts, :msg)
end
