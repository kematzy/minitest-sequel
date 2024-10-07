# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_validate_format_of(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_format_of(:title, with: /\w/)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when column is NOT validated' do
        assert_no_error { _(@m).wont_validate_format_of(:author_id, with: /\w/) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when column is validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* NOT to validate :title with :format, but the column :title was validated with :format/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { _(@m).wont_validate_format_of(:title, with: /\w/) }
      end

      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) { _(@m).wont_validate_format_of(:does_not_exist, with: /\w/) }
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) { _(@m).wont_validate_format_of(:id, with: /\w/) }
      end
    end
    # /should raise an error
  end
  # /#wont_validate_format_of(:attribute, :opts, :msg)
end
