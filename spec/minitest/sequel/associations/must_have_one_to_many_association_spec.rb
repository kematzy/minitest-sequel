# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_have_one_to_many_association(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(Post)
      @c.one_to_many :comments
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'on a correct association' do
        assert_no_error { _(@m).must_have_one_to_many_association(:comments) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on incorrect association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :one_to_many association :comment, but no association ':comment' was found - \navailable associations are: \[ {:attribute=>:comments, :type=>:one_to_many, :class=>"(::)?Comment", :keys=>\[:.*_id\]} \]/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_one_to_many_association(:comment, {})
        end
      end

      it 'on valid association with incorrect options passed' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :one_to_many association :comments with given options: {:class_name=>"Comments"} but should be {:class_name=>"(::)?Comment"}/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_one_to_many_association(:comments, { class_name: 'Comments' })
        end
      end
    end
    # /should raise an error
  end
  # /#must_have_one_to_many_association(:attribute, :opts, :msg)
end
