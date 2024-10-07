# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates(:model, :validation_type, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_presence_of(:title)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating Post#title' do
        assert_no_error { assert_validates(@m, :presence, :title) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) { assert_validates(@m, :presence, :does_not_exist) }
      end

      it 'when validating incorrect provided options' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :title column with: { message: 'dummy' } but found: { message: 'is not present' }/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates(@m, :presence, :title, { message: 'dummy' }) }
      end

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates(@m, :presence, :author_id) }
      end

      it 'when invalid option(s) are passed' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :title column, but the following invalid option\(s\) was found: { :completey_invalid;  }. Valid options are: \[:message\]/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          assert_validates(@m, :presence, :title, { completey_invalid: false })
        end
      end

      it 'when the validation type is wrong for the column' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :numericality for :title column, but no :numericality validation is defined for :title/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          assert_validates(@m, :numericality, :title)
        end
      end

      it 'when no validation is defined for the column' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :id column, but no validations are defined for :id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          assert_validates(@m, :presence, :id)
        end
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) do
          assert_validates(@m, :presence, :id)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates(:model, :validation_type, :attribute, :opts, :msg)
end
