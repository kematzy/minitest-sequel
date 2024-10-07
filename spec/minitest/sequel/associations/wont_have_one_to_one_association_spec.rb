# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_have_one_to_one_association(:attribute, :msg)' do
    before do
      @c = Class.new(Post)
      @c.one_to_one :first_comment
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on non-existant association' do
        assert_no_error { _(@m).wont_have_one_to_one_association(:does_not_exist) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on existing association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to NOT have a :one_to_one association :first_comment, but such an association was found/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).wont_have_one_to_one_association(:first_comment)
        end
      end
    end
    # /should raise an error
  end
  # /#wont_have_one_to_one_association(:attribute, :msg)
end