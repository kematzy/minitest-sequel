# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_length(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_length_of :title
      @m = @c.new
    end
    describe 'should NOT raise an error' do
      it 'when correctly validating the length of Post#title' do
        assert_no_error { assert_validates_length(@m, :title) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating an incorrect provided option' do
        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { message: 'dummy' } but found: { message: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { message: 'dummy' }) }
        end

        it ':nil_message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { nil_message: 'dummy' } but found: { nil_message: 'is not present' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { nil_message: 'dummy' }) }
        end

        it ':too_long' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { too_long: 'dummy' } but found: { too_long: 'is too long' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { too_long: 'dummy' }) }
        end

        it ':too_short' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { too_short: 'dummy' } but found: { too_short: 'is too short' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { too_short: 'dummy' }) }
        end

        it ':wrong_length' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { wrong_length: 'dummy' } but found: { wrong_length: 'is the wrong length' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_length(@m, :title, { wrong_length: 'dummy' })
          end
        end

        it ':is' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { is: '10' } but found: { is: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { is: 10 }) }
        end

        it ':minimum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { minimum: '10' } but found: { minimum: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { minimum: 10 }) }
        end

        it ':maximum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { maximum: '20' } but found: { maximum: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { maximum: 20 }) }
        end

        it ':within' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :length for :title column with: { within: '10..20' } but found: { within: '' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_length(@m, :title, { within: 10..20 }) }
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_length(@m, :author_id) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_length(@m, :does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_length(:model, :attribute, :opts, :msg)
end
