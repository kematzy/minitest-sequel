# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_presence(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_presence_of(:title)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the presence of Post#title' do
        assert_no_error { assert_validates_presence(@m, :title) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when validating a valid provided options' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :title column with: { message: 'dummy' } but found: { message: 'is not present' }/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_presence(@m, :title, { message: 'dummy' }) }
      end

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :presence for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_presence(@m, :author_id) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_presence(@m, :does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_presence(:model, :attribute, :opts, :msg)
end
