# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#wont_have_column(:attribute, :msg)' do
    let(:m) { Post.new }

    describe 'should not raise an error' do
      it 'on a non-existing column' do
        assert_no_error { _(m).wont_have_column(:does_not_exist) }
      end
    end
    # /should not raise an error

    describe 'should raise an error' do
      it 'on an existing column' do
        msg = 'Expected Post model to NOT have column: :title but such a column was found'

        assert_error_raised(msg) { _(m).wont_have_column(:title) }
      end
    end
    # /should raise an error
  end
end
