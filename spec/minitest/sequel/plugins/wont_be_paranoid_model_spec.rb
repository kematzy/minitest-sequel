# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe 'model#wont_be_paranoid_model())' do
    describe 'should raise an error' do
      it 'on a .plugin(:paranoid) model' do
        m = Class.new(ParanoidPost)
        m.plugin(:paranoid)

        msg = /expected .* to NOT be a :paranoid model, but it was. Debug: /

        assert_returns_error(msg) { _(m).wont_be_paranoid_model }
      end
    end
    # /should raise an error

    describe 'should NOT raise an error' do
      describe 'on a NON .plugin(:paranoid) model' do
        it 'with :deleted_at column' do
          m = Class.new(ParanoidPost)

          assert_no_error { _(m).wont_be_paranoid_model }
        end

        it 'without :deleted_at column' do
          m = Class.new(NonParanoidPost)

          assert_no_error { _(m).wont_be_paranoid_model }
        end
      end
    end
    # /should NOT raise an error
  end
  # /model#wont_be_paranoid_model()

  # testing the alias
  describe 'model#wont_be_a_paranoid_model())' do
    describe 'should raise an error' do
      it 'on a .plugin(:paranoid) model' do
        m = Class.new(ParanoidPost)
        m.plugin(:paranoid)

        msg = /expected .* to NOT be a :paranoid model, but it was/

        assert_returns_error(msg) { _(m).wont_be_a_paranoid_model }
      end
    end
    # /should raise an error

    describe 'should NOT raise an error' do
      it 'on a NON .plugin(:paranoid) model' do
        m = Class.new(NonParanoidPost)

        assert_no_error { _(m).wont_be_a_paranoid_model }
      end
    end
    # /should NOT raise an error
  end
  # /model#wont_be_a_paranoid_model()
end
