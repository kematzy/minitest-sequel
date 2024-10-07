# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#refute_association_many_to_many(:model, :attribute, :msg)' do
    before do
      @c = Class.new(Post)
      @c.many_to_many :authors
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on non-existant association' do
        assert_no_error { refute_association_many_to_many(@m, :does_not_exist) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on existing association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to NOT have a :many_to_many association :authors, but such an association was found/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          refute_association_many_to_many(@m, :authors)
        end
      end
    end
    # /should raise an error
  end
  # /#refute_association_many_to_many(:model, :attribute, :msg)
end
