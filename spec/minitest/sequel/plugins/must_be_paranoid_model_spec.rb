# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_be_paranoid_model(:opts)' do
    describe 'a model with .plugin(:paranoid)' do
      describe 'should NOT raise an error' do
        it 'on a valid paranoid model' do
          m = Class.new(ParanoidPost)
          m.plugin(:paranoid)

          assert_no_error { _(m).must_be_paranoid_model({ title: 'Paranoid' }) }
        end

        it 'when the model has a :deleted_at column' do
          m = Class.new(ParanoidPost)
          m.plugin(:paranoid)

          assert_no_error { _(m).must_be_paranoid_model({ title: 'Paranoid' }) }
        end
      end
      # /should NOT raise an error

      describe 'should raise an' do
        it 'NoMethodError when the :deleted_at column is missing' do
          m = Class.new(NonParanoidPost)
          m.plugin(:paranoid)

          assert_raises(NoMethodError) { _(m).must_be_paranoid_model({ title: 'Dummy' }) }
        end
      end
      # /should raise an
    end
    # /a model with .plugin(:paranoid)

    describe 'a model without .plugin(:paranoid)' do
      it 'should raise an error' do
        m = Class.new(NonParanoidPost)

        msg = 'Not a plugin(:paranoid) model, available plugins are: '
        msg << '["Sequel::Model", "Sequel::Model::Associations"]'

        assert_returns_error(msg) do
          _(m).must_be_paranoid_model({ title: 'Paranoid' })
        end
      end
    end
    # /should raise an error
  end
  # /#must_be_paranoid_model(:opts)

  # testing the alias
  describe '#must_be_a_paranoid_model(:opts)' do
    describe 'should NOT raise an error' do
      it 'on a model with .plugin(:paranoid)' do
        m = Class.new(ParanoidPost)
        m.plugin(:paranoid)

        assert_no_error { _(m).must_be_a_paranoid_model({ title: 'Paranoid' }) }
      end
      # /a model with .plugin(:paranoid)
    end

    describe 'should raise an error' do
      it 'on a model without .plugin(:paranoid)' do
        m = Class.new(NonParanoidPost)

        msg = /Not a plugin\(:paranoid\) model, available plugins are/

        assert_returns_error(msg) do
          _(m).must_be_a_paranoid_model({ title: 'Paranoid' })
        end
      end
    end
    # /should raise an error
  end
  # /#must_be_a_paranoid_model(:opts)
end