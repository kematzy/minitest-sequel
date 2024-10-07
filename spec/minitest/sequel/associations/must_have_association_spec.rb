# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_have_association(:association_type, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(Post)
      @c.one_to_many :comments
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on a correct association' do
        assert_no_error { _(@c).must_have_association(:one_to_many, :comments) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on incorrect association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :many_to_one association :comment, but no association ':comment' was found - \navailable associations are: \[ {:attribute=>:comments, :type=>:one_to_many, :class=>"(::)?Comment", :keys=>\[:.*_id\]} \]/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@c).must_have_association(:many_to_one, :comment)
        end
      end

      it 'on valid association with incorrect options passed' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :one_to_many association :comments with given options: {:key=>:comments_id} but should be {:key=>"_id"}/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@c).must_have_association(:one_to_many, :comments, { key: :comments_id })
        end
      end
    end
    # /should raise an error
  end
  # /#must_have_association(:association_type, :attribute, :opts, :msg)
end
