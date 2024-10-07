# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_have_many_to_one_association(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(Comment)
      @c.many_to_one :post
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on a correct association' do
        assert_no_error { _(@m).must_have_many_to_one_association(:post) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on incorrect association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :many_to_one association :posts, but no association ':posts' was found - \navailable associations are: \[ {:attribute=>:post, :type=>:many_to_one, :class=>"(::)?Post", :keys=>\[:.*_id\]} \]/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_many_to_one_association(:posts, {})
        end
      end

      it 'on valid association with incorrect options passed' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :many_to_one association :post with given options: {:class_name=>"Posts"} but should be {:class_name=>"(::)?Post"}/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_many_to_one_association(:post, { class_name: 'Posts' })
        end
      end
    end
    # /should raise an error
  end
  # /#must_have_many_to_one_association(:attribute, :opts, :msg)
end
