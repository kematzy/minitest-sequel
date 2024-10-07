# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_max_length(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_length_of :title, maximum: 10
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the exact length of Post#title' do
        assert_no_error { assert_validates_max_length(@m, :title, 10) }

        assert_no_error { assert_validates_length(@m, :title, { maximum: 10 }) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating an incorrect provided option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { message: 'dummy', maximum: '10' } but found: { message: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { message: 'dummy' })
          end
        end

        it ':nil_message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '10', nil_message: 'dummy' } but found: { nil_message: 'is not present' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { nil_message: 'dummy' })
          end
        end

        it ':too_long' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '10', too_long: 'dummy' } but found: { too_long: 'is too long' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { too_long: 'dummy' })
          end
        end

        it ':too_short' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '10', too_short: 'dummy' } but found: { too_short: 'is too short' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { too_short: 'dummy' })
          end
        end

        it ':wrong_length' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '10', wrong_length: 'dummy' } but found: { wrong_length: 'is the wrong length' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { wrong_length: 'dummy' })
          end
        end

        it ':maximum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '15' } but found: { maximum: '10' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 15, { maximum: 10 })
          end
        end

        it ':is' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { is: '20', maximum: '10' } but found: { is: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { is: 20 })
          end
        end

        it ':minimum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '10', minimum: '20' } but found: { minimum: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { minimum: 20 })
          end
        end

        it ':within' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { within: '10..20', maximum: '10' } but found: { within: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_max_length(@m, :title, 10, { within: 10..20 })
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_max_length(@m, :author_id, 10) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_max_length(@m, :does_not_exist, 10)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_max_length(:model, :attribute, :opts, :msg)
end
