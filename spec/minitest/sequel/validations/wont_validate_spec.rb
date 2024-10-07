# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_validate(:validation_type, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_presence_of(:title)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when column is NOT validated' do
        assert_no_error { _(@m).wont_validate(:presence, :author_id) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when column is validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* NOT to validate :title with :presence, but the column :title was validated with :presence/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { _(@m).wont_validate(:presence, :title) }
      end

      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) { _(@m).wont_validate(:presence, :does_not_exist) }
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) { _(@m).wont_validate(:presence, :id) }
      end
    end
    # /should raise an error
  end
  # /#wont_validate(:validation_type, :attribute, :opts, :msg)
end
