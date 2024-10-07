# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_paranoid_model(:model, :opts)' do
    describe 'a model with .plugin(:paranoid)' do
      describe 'should NOT raise an error' do
        it 'on a valid paranoid model' do
          m = Class.new(ParanoidPost)
          m.plugin(:paranoid)

          assert_no_error { assert_paranoid_model(m, { title: 'Paranoid' }) }
        end

        it 'when the model has a :deleted_at column' do
          m = Class.new(ParanoidPost)
          m.plugin(:paranoid)

          assert_no_error { assert_paranoid_model(m, { title: 'Paranoid' }) }
        end
      end
      # /should NOT raise an error

      describe 'should raise an' do
        it 'NoMethodError when the :deleted_at column is missing' do
          m = Class.new(NonParanoidPost)
          m.plugin(:paranoid)

          assert_raises(NoMethodError) { assert_paranoid_model(m, { title: 'Dummy' }) }
        end
      end
      # /should raise an
    end
    # /a model with .plugin(:paranoid)

    describe 'a model without .plugin(:paranoid)' do
      it 'should raise an error' do
        m = Class.new(ParanoidPost)

        msg = 'Not a plugin(:paranoid) model, available plugins are: '
        msg << '["Sequel::Model", "Sequel::Model::Associations"]'

        assert_returns_error(msg) do
          assert_paranoid_model(m, { title: 'Dummy' })
        end
      end
    end
    # /a model without .plugin(:paranoid)
  end
  # /#assert_paranoid_model(:model, :opts)
end
