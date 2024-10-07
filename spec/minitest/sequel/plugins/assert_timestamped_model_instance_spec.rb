# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_timestamped_model_instance(:model, :opts)' do
    describe 'a model with .plugin(:timestamps)' do
      describe 'should NOT raise an error' do
        it 'on a new model and set the :created_at: to a timestamp' do
          m = Class.new(TimestampPost)
          m.plugin(:timestamps)
          mi = m.create(title: 'Dummy', created_at: nil)

          assert_no_error_raised { assert_timestamped_model_instance(mi) }

          assert_kind_of(Time, mi.created_at)
        end

        it 'on an updated model and set the :updated_at to a timestamp' do
          m = Class.new(TimestampPost)
          m.plugin(:timestamps)
          mi = m.create(title: 'Dummy')
          mi.update(title: 'updated')
          mi.save
          # _(mi.updated_at).wont_be_nil

          assert_no_error_raised do
            assert_timestamped_model_instance(mi, updated_record: true)
          end
        end
      end
      # /should NOT raise an error

      describe 'should raise an error' do
        it 'if :updated_at is not nil on a new model' do
          m = Class.new(TimestampPost)
          m.plugin(:timestamps)
          mi = m.create(title: 'Dummy', updated_at: Time.now)

          msg = /AssertTimestampedModelInstance - expected #updated_at to be NIL on new record/

          assert_error_raised(msg) do
            assert_timestamped_model_instance(mi, updated_record: false)
          end
        end

        it 'when a model is without .plugin(:timestamps)' do
          m = Class.new(TimestampPost)
          mi = m.create(title: 'Dummy', updated_at: Time.now)

          msg = 'Not a plugin(:timestamps) model, available plugins are: '
          msg << '["Sequel::Model", "Sequel::Model::Associations"]'
          # msg <<  '"Sequel::Plugins::ValidationClassMethods"]'

          assert_error_raised(msg) do
            assert_timestamped_model_instance(mi, updated_record: false)
          end
        end
        # /when a model is without .plugin(:timestamps)
      end
      # /should raise an error

      it 'should set :updated_at to NIL on a new model' do
        m = Class.new(TimestampPost)
        m.plugin(:timestamps)
        mi = m.create(title: 'Dummy')

        assert_no_error do
          assert_timestamped_model_instance(mi, updated_record: false)
        end

        assert_nil(mi.updated_at)
      end
    end
  end
  # /a model with .plugin(:timestamps)
end
