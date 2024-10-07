# frozen_string_literal: false

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_be_timestamped_model(:opts)' do
    describe 'a model with .plugin(:timestamps)' do
      describe 'should NOT raise an error' do
        it 'on a timestamped model' do
          m = Class.new(TimestampPost)
          m.plugin(:timestamps)

          assert_no_error { _(m).must_be_timestamped_model({ title: 'Timestamped' }) }
        end

        it 'when the :created_at and :updated_at columns are present' do
          m = Class.new(TimestampPost)
          m.plugin(:timestamps)

          assert_no_error { _(m).must_be_timestamped_model({ title: 'Dummy' }) }
        end
      end
      # /should NOT raise an error

      describe 'should raise an error' do
        it 'when the :created_at and :updated_at columns are NOT present' do
          m = Class.new(NonTimestampPost)
          m.plugin(:timestamps)

          msg = /Expected .* model to have column: :created_at but no such column exists/

          assert_returns_error(msg) { _(m).must_be_timestamped_model({ title: 'Dummy' }) }
        end

        it 'when the :created_at column is missing' do
          m = Class.new(UpdatedTimestampPost)
          m.plugin(:timestamps)

          msg = /Expected .* model to have column: :created_at but no such column exists/

          assert_returns_error(msg) { _(m).must_be_timestamped_model({ title: 'Dummy' }) }
        end

        it 'when the :updated_at column is missing' do
          m = Class.new(CreatedTimestampPost)
          m.plugin(:timestamps)

          msg = /Expected .* model to have column: :updated_at but no such column exists/

          assert_returns_error(msg) { _(m).must_be_timestamped_model({ title: 'Dummy' }) }
        end
      end
      # /should raise an error
    end
    # /a model with .plugin(:timestamps)

    describe 'a model without .plugin(:timestamps)' do
      it 'should raise an error' do
        m = Class.new(NonTimestampPost)

        msg = 'Not a plugin(:timestamps) model, available plugins are: '
        msg << '["Sequel::Model", "Sequel::Model::Associations"]'

        assert_returns_error(msg) { _(m).must_be_timestamped_model({ title: 'Dummy' }) }
      end
    end
    # /a model without .plugin(:timestamps)
  end
  # /#must_be_timestamped_model(:model, :opts)

  # testing the alias
  describe '#must_be_a_timestamped_model(:opts)' do
    let(:m) { Post.new }

    describe 'a model with .plugin(:timestamps)' do
      it 'should raise no error' do
        m = Class.new(Post)
        m.plugin(:timestamps)

        assert_no_error { _(m).must_be_a_timestamped_model({ title: 'Timestamped' }) }
      end
    end
    # /a model with .plugin(:timestamps)

    describe 'a model without .plugin(:timestamps)' do
      it 'should raise an error' do
        m = Class.new(Post)

        msg = /Not a plugin\(:timestamps\) model, available plugins are/

        assert_returns_error(msg) do
          _(m).must_be_a_timestamped_model({ title: 'Timestamped' })
        end
      end
    end
    # /a model without .plugin(:timestamps)
  end
  # /#must_be_a_timestamped_model(:model, :opts)
end
