# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#refute_timestamped_model(:model)' do
    describe 'should raise an error' do
      it 'on a .plugin(:timestamps) model' do
        m = Class.new(TimestampPost)
        m.plugin(:timestamps)

        msg = /expected .* to NOT be a :timestamps model, but it was. Debug: /

        assert_returns_error(msg) { refute_timestamped_model(m) }
      end
    end
    # /should raise an error

    describe 'should NOT raise an error' do
      describe 'on a NON .plugin(:timestamps) model' do
        it 'with :created_at & :updated_at columns' do
          m = Class.new(TimestampPost)

          assert_no_error { refute_timestamped_model(m) }
        end

        it 'without :created_at & :updated_at columns' do
          m = Class.new(NonTimestampPost)

          assert_no_error { refute_timestamped_model(m) }
        end
      end
    end
    # /should NOT raise an error
  end
  # /#refute_timestamped_model(:model)
end
