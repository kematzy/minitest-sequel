# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_have_one_to_one_association(:attribute, :opts, :msg)' do
    before do
      @c = Class.new(Author)
      @c.one_to_one :key_post, class: :Post, order: :id
      @m = @c.new
    end

    it { _(@m).must_have_one_to_one_association(:key_post) }

    describe 'should NOT raise an error' do
      it 'on a correct association' do
        assert_no_error { _(@m).must_have_one_to_one_association(:key_post) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      it 'on incorrect association' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :one_to_one association :key_posts, but no association ':key_posts' was found - \navailable associations are: \[ {:attribute=>:key_post, :type=>:one_to_one, :class=>"(::)?Post", :keys=>\[:.*_id\]} \]/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_one_to_one_association(:key_posts, {})
        end
      end

      it 'on valid association with incorrect options passed' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to have a :one_to_one association :key_post with given options: {:class_name=>"Comments"} but should be {:class_name=>"(::)?Post"}/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) do
          _(@m).must_have_one_to_one_association(:key_post, { class_name: 'Comments' })
        end
      end
    end
    # /should raise an error
  end
  # /#must_have_one_to_one_association(:attribute, :opts, :msg)
end
