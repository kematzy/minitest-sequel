# frozen_string_literal: false

require_relative '../../../spec_helper'

# rubocop:disable Metrics/BlockLength
describe Minitest::Assertions do
  describe '#assert_have_column(:obj, :attribute, :opts, :msg)' do
    let(:m) { Post.new }

    describe 'a valid column' do
      it { assert_have_column(m, :title, type: :string, db_type: 'varchar(255)', allow_null: true) }

      describe 'raises no error' do
        it 'when given no options' do
          assert_no_error_raised { assert_have_column(m, :title) }
        end

        it 'with options type: string' do
          assert_no_error { assert_have_column(m, :title, { type: :string }) }
        end

        it "with options type: string, db_type: 'varchar(255)'" do
          assert_no_error_raised do
            assert_have_column(m, :title, { type: :string, db_type: 'varchar(255)' })
          end
        end

        it 'with options allow_null: true' do
          assert_no_error { assert_have_column(m, :title, { allow_null: true }) }

          assert_no_error { _(m).must_have_column(:title, { allow_null: true }) }
        end

        it 'with options default: nil' do
          assert_no_error { assert_have_column(m, :title, { default: :nil }) }
        end

        it "with options default: '1'" do
          assert_no_error { assert_have_column(m, :category_id, { default: '1' }) }
        end

        it 'with options max_length: 255' do
          assert_no_error { assert_have_column(m, :title, { max_length: 255 }) }
        end

        it 'with options primary_key: :true' do
          assert_no_error { assert_have_column(m, :id, { primary_key: true }) }
        end

        it 'with options auto_increment: :true' do
          assert_no_error { assert_have_column(m, :id, { auto_increment: true }) }
        end
      end
      # /raises no error

      describe 'raises an error' do
        it "with incorrect options type: string, db_type: 'varchar(250)'" do
          msg = "Expected Post model to have column: :title with: { type: 'string', "
          msg << "db_type: 'varchar(250)' } but found: { db_type: 'varchar(255)' }"

          assert_error_raised(msg) do
            assert_have_column(m, :title, { type: :string, db_type: 'varchar(250)' })
          end
        end

        it 'with incorrect options allow_null: :false' do
          msg = "Expected Post model to have column: :title with: { allow_null: 'false' } "
          msg << "but found: { allow_null: 'true' }"

          assert_error_raised(msg) { assert_have_column(m, :title, { allow_null: false }) }
        end

        it 'with incorrect options max_length: 200' do
          msg = "Expected Post model to have column: :title with: { max_length: '200' } "
          msg << "but found: { max_length: '255' }"

          assert_error_raised(msg) { assert_have_column(m, :title, { max_length: 200 }) }
        end

        it 'with incorrect options primary_key: false' do
          msg = 'Expected Post model to have column: :id with: '
          msg << "{ primary_key: 'false' } but found: { primary_key: 'true' }"

          assert_error_raised(msg) { assert_have_column(m, :id, { primary_key: false }) }
        end

        it "with incorrect options primary_key: 'invalid'" do
          msg = /column: :id with: { primary_key: 'invalid' } but found: { primary_key: 'true' }/

          assert_error_raised(msg) { assert_have_column(m, :id, { primary_key: 'invalid' }) }
        end

        it 'with incorrect options auto_increment: :false' do
          msg = 'Expected Post model to have column: :id with: '
          msg << "{ auto_increment: 'false' } but found: { auto_increment: 'true' }"

          assert_error_raised(msg) { assert_have_column(m, :id, { auto_increment: false }) }
        end

        it 'with incorrect options id: as string' do
          msg = 'Expected Post model to have column: :id with: '
          msg << "{ type: 'string' } but found: { type: 'integer' }"

          assert_error_raised(msg) { assert_have_column(m, :id, { type: :string }) }
        end

        it 'when invalid option(s) are passed' do
          msg = 'Expected Post model to have column: :id, but the following invalid option(s) '
          msg << 'was found: { :completey_invalid }. Valid options are: [:type, :db_type, '
          msg << ':allow_null, :default, :primary_key, :auto_increment, :max_length]'

          assert_error_raised(msg) { assert_have_column(m, :id, { completey_invalid: false }) }
        end
      end
      # /raises an error
    end
    # / a valid column

    describe 'an invalid column' do
      it 'should raise error' do
        msg = 'Expected Post model to have column: :does_not_exist but no such column exists'

        assert_error_raised(msg) { assert_have_column(m, :does_not_exist) }
      end
    end
    # /an invalid column
  end
end
# rubocop:enable Metrics/BlockLength
