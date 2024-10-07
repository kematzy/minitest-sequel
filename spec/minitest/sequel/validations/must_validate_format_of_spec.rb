# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Expectations do
  describe '#must_validate_format_of():attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_format_of(:title, with: /\w+/)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the length of Post#title' do
        assert_no_error { _(@m).must_validate_format_of(:title) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating an incorrect provided option' do
        let(:regex) { /^\w$/ }

        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column with: { message: 'dummy', with: '(.*)' } but found: { message: 'is invalid', with: '(.*)' }/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, message: 'dummy')
          end
        end

        it ':nil_message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :nil_message;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, nil_message: 'dummy')
          end
        end

        it ':too_long' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :too_long;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, too_long: 'dummy')
          end
        end

        it ':too_short' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :too_short;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, too_short: 'dummy')
          end
        end

        it ':wrong_length' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :wrong_length;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, wrong_length: 'dummy')
          end
        end

        it ':is' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :is;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, is: 10)
          end
        end

        it ':minimum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :minimum;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, minimum: 10)
          end
        end

        it ':maximum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :maximum;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, maximum: 20)
          end
        end

        it ':within' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :within;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            _(@m).must_validate_format_of(:title, with: regex, within: 10..20)
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :format for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { _(@m).must_validate_format_of(:author_id) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          _(@m).must_validate_format_of(:does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#must_validate_format_of(:attribute, :opts, :msg)
end
