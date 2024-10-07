# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_uniqueness(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_uniqueness_of(:urlslug)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'with valid unique Post#urlslug' do
        assert_no_error { assert_validates_uniqueness(@m, :urlslug) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating a valid option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /validate :uniqueness for :urlslug column with: { message: 'msg' } but found: { message: 'is already taken' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_uniqueness(@m, :urlslug, message: 'msg') }
        end
      end

      describe 'when validating an invalid option' do
        %i[nil_message too_long too_short wrong_length].each do |t|
          it ":#{t}" do
            msg = /the following invalid option\(s\) was found: \{ :#{t};  \}/

            assert_error_raised(msg) do
              assert_validates_uniqueness(@m, :urlslug, { t.to_sym => 'dummy' })
            end
          end
        end

        it ':is' do
          msg = /the following invalid option\(s\) was found: \{ :is;  \}/

          assert_error_raised(msg) do
            assert_validates_uniqueness(@m, :urlslug, { is: 10 })
          end
        end

        it ':minimum' do
          msg = /the following invalid option\(s\) was found: \{ :minimum;  \}/

          assert_error_raised(msg) do
            assert_validates_uniqueness(@m, :urlslug, { minimum: 10 })
          end
        end

        it ':maximum' do
          msg = /the following invalid option\(s\) was found: \{ :maximum;  \}/

          assert_error_raised(msg) do
            assert_validates_uniqueness(@m, :urlslug, { maximum: 10 })
          end
        end

        it ':within' do
          msg = /the following invalid option\(s\) was found: \{ :within;  \}/

          assert_error_raised(msg) do
            assert_validates_uniqueness(@m, :urlslug, { within: 10..20 })
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        msg = /validate :uniqueness for :title column, but no validations are defined for :title/

        assert_error_raised(msg) { _(@m).must_validate_uniqueness_of(:title) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_uniqueness(@m, :does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_uniqueness(:model, :attribute, :opts, :msg)
end
