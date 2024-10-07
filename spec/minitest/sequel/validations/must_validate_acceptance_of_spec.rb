# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_validate_acceptance_of(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_acceptance_of(:urlslug)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when validating the acceptance of Post#urlslug' do
        assert_no_error { _(@m).must_validate_acceptance_of(:urlslug) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating a valid option' do
        it ':accept' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :acceptance for :urlslug column with: { accept: 'f' } but found: { accept: '1' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, accept: 'f')
          end
        end

        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :acceptance for :urlslug column with: { message: 'dummy' } but found: { message: 'is not accepted' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, message: 'dummy')
          end
        end
      end

      describe 'when validating an invalid option' do
        %i[nil_message too_long too_short wrong_length].each do |t|
          it ":#{t}" do
            msg = /the following invalid option\(s\) was found: \{ :#{t};  \}/

            assert_error_raised(msg) do
              _(@m).must_validate_acceptance_of(:urlslug, { t.to_sym => 'dummy' })
            end
          end
        end

        it ':is' do
          msg = /the following invalid option\(s\) was found: \{ :is;  \}/

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, { is: 10 })
          end
        end

        it ':minimum' do
          msg = /the following invalid option\(s\) was found: \{ :minimum;  \}/

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, { minimum: 10 })
          end
        end

        it ':maximum' do
          msg = /the following invalid option\(s\) was found: \{ :maximum;  \}/

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, { maximum: 10 })
          end
        end

        it ':within' do
          msg = /the following invalid option\(s\) was found: \{ :within;  \}/

          assert_error_raised(msg) do
            _(@m).must_validate_acceptance_of(:urlslug, { within: 10..20 })
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :acceptance for :title column, but no validations are defined for :title/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { _(@m).must_validate_acceptance_of(:title) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          _(@m).must_validate_acceptance_of(:does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#must_validate_acceptance_of(:attribute, :opts, :msg)
end
