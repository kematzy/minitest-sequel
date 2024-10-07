# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_have_association(:association_type, :attribute, :msg)' do
    before do
      @c = Class.new(Post)
      @c.many_to_one :comment
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on non-existant association' do
        assert_no_error { _(@c).wont_have_association(:one_to_many, :does_not_exist) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on existing association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to NOT have a :many_to_one association :comment, but such an association was found/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@c).wont_have_association(:many_to_one, :comment)
        end
      end
    end
    # /should raise an error
  end
  # /#wont_have_association(:association_type, :attribute, :msg)
end
