# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_validate_inclusion_of(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_inclusion_of(:title, in: %i[a b c])
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when column is NOT validated' do
        assert_no_error { _(@m).wont_validate_inclusion_of(:author_id, in: %i[a b c]) }

        assert_no_error { _(@m).wont_validate(:inclusion, :author_id, in: %i[a b c]) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'when column is validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* NOT to validate :title with :inclusion, but the column :title was validated with :inclusion/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { _(@m).wont_validate_inclusion_of(:title, in: %i[a b c]) }
      end

      it 'when trying to validate invalid column' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          _(@m).wont_validate_inclusion_of(:does_not_exist, in: %i[a b c])
        end
      end

      it 'when no validations are defined for the model' do
        msg = /No validations defined in .*/
        @m = Class.new(ValidationPost).new

        assert_error_raised(msg) { _(@m).wont_validate_inclusion_of(:id, in: %i[a b c]) }
      end
    end
    # /should raise an error
  end
  # /#wont_validate_inclusion_of(:attribute, :opts, :msg)
end
