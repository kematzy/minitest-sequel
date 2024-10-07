# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_confirmation(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_confirmation_of(:password)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when validating the confirmation of Dummy#password' do
        assert_no_error { assert_validates_confirmation(@m, :password) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      let(:str) { /Expected .* to validate :confirmation for :password column/ }

      describe 'when validating a valid option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :confirmation for :password column with: { message: 'dummy' } but found: { message: 'is not confirmed' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_confirmation(@m, :password, message: 'dummy')
          end
        end
      end

      describe 'when validating an invalid option' do
        %i[nil_message too_long too_short wrong_length].each do |t|
          it ":#{t}" do
            msg = /the following invalid option\(s\) was found: \{ :#{t};  \}/

            assert_error_raised(msg) do
              assert_validates_confirmation(@m, :password, { t.to_sym => 'dummy' })
            end
          end
        end

        it ':is' do
          msg = /the following invalid option\(s\) was found: \{ :is;  \}/

          assert_error_raised(msg) do
            assert_validates_confirmation(@m, :password, { is: 10 })
          end
        end

        it ':minimum' do
          msg = /the following invalid option\(s\) was found: \{ :minimum;  \}/

          assert_error_raised(msg) do
            assert_validates_confirmation(@m, :password, { minimum: 10 })
          end
        end

        it ':maximum' do
          msg = /the following invalid option\(s\) was found: \{ :maximum;  \}/

          assert_error_raised(msg) do
            assert_validates_confirmation(@m, :password, { maximum: 10 })
          end
        end

        it ':within' do
          msg = /the following invalid option\(s\) was found: \{ :within;  \}/

          assert_error_raised(msg) do
            assert_validates_confirmation(@m, :password, { within: 10..20 })
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :confirmation for :title column, but no validations are defined for :title/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          assert_validates_confirmation(@m, :title)
        end
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_confirmation(@m, :does_not_exist, 10)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_confirmation(:model, :attribute, :opts, :msg)
end
