# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#refute_paranoid_model(:model)' do
    describe 'should raise an error' do
      it 'on a .plugin(:paranoid) model' do
        m = Class.new(ParanoidPost)
        m.plugin(:paranoid)

        msg = /expected .* to NOT be a :paranoid model, but it was. Debug: /

        assert_returns_error(msg) { refute_paranoid_model(m) }
      end
    end
    # /should raise an error

    describe 'should NOT raise an error' do
      describe 'on a NON .plugin(:paranoid) model' do
        it 'with :deleted_at column' do
          m = Class.new(ParanoidPost)

          assert_no_error { refute_paranoid_model(m) }
        end

        it 'without :deleted_at column' do
          m = Class.new(NonParanoidPost)

          assert_no_error { refute_paranoid_model(m) }
        end
      end
    end
    # /should NOT raise an error
  end
  # /#refute_paranoid_model(:model)
end
