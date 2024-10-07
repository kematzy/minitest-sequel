# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_length(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_length_of(:title, is: 10)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the exact length of Post#title' do
        assert_no_error { assert_validates_exact_length(@m, :title, 10) }

        assert_no_error { assert_validates_length(@m, :title, { is: 10 }) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      let(:str) { /Expected .* to validate :length for :title column/ }

      describe 'when validating an incorrect provided option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { message: 'dummy', is: '10' } but found: { message: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { message: 'dummy' })
          end
        end

        it ':nil_message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { is: '10', nil_message: 'dummy' } but found: { nil_message: 'is not present' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { nil_message: 'dummy' })
          end
        end

        it ':too_long' do
          msg = /with: { is: '10', too_long: 'dummy' } but found: { too_long: 'is too long' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { too_long: 'dummy' })
          end
        end

        it ':too_short' do
          msg = /with: { is: '10', too_short: 'dummy' } but found: { too_short: 'is too short' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { too_short: 'dummy' })
          end
        end

        it ':wrong_length' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { is: '10', wrong_length: 'dummy' } but found: { wrong_length: 'is the wrong length' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { wrong_length: 'dummy' })
          end
        end

        it ':is' do
          msg = /validate :length for :title column with: { is: '15' } but found: { is: '10' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 15, { is: 10 })
          end
        end

        it ':minimum' do
          msg = /:title column with: { is: '10', minimum: '10' } but found: { minimum: '' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { minimum: 10 })
          end
        end

        it ':maximum' do
          msg = /for :title column with: { is: '10', maximum: '20' } but found: { maximum: '' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { maximum: 20 })
          end
        end

        it ':within' do
          msg = /for :title column with: { is: '10', within: '10..20' } but found: { within: '' }/

          assert_error_raised(msg) do
            assert_validates_exact_length(@m, :title, 10, { within: 10..20 })
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        msg = /for :author_id column, but no validations are defined for :author_id/

        assert_error_raised(msg) { assert_validates_exact_length(@m, :author_id, 10) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_exact_length(@m, :does_not_exist, 10)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_length(:model, :attribute, :opts, :msg)
end
