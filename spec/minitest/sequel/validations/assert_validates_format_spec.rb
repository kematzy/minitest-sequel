# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_validates_format(:model, :attribute, :opts, :msg)' do
    before do
      @c = Class.new(ValidationPost)
      @c.plugin :validation_class_methods
      @c.validates_format_of(:title, with: /\w+/)
      @m = @c.new
    end

    describe 'should NOT raise an error' do
      it 'when correctly validating the length of Post#title' do
        assert_no_error { assert_validates_format(@m, :title) }
      end
    end
    # /should NOT raise an error

    describe 'should raise an error' do
      describe 'when validating an incorrect provided option' do
        let(:regex) { /^\w$/ }

        it ':with' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column with: \{ with: '.*' \} but found: \{ with: '.*' \}/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex)
          end
        end

        it ':message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column with: \{ message: 'msg', with: '.*' \} but found: \{ message: 'is invalid', with: '.*' \}/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, message: 'msg')
          end
        end

        it ':nil_message' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :nil_message;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, nil_message: 'msg')
          end
        end

        it ':too_long' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :too_long;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, too_long: 'msg')
          end
        end

        it ':too_short' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :too_short;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, too_short: 'msg')
          end
        end

        it ':wrong_length' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :wrong_length;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, wrong_length: 'msg')
          end
        end

        it ':is' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :is;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_format(@m, :title, with: regex, is: 10) }
        end

        it ':minimum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :minimum;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_format(@m, :title, with: regex, minimum: 10) }
        end

        it ':maximum' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :maximum;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) { assert_validates_format(@m, :title, with: regex, maximum: 20) }
        end

        it ':within' do
          # rubocop:disable Layout/LineLength
          msg = /Expected .* to validate :format for :title column, but the following invalid option\(s\) was found: \{ :within;  \}. Valid options are: \[:message, :with\]/
          # rubocop:enable Layout/LineLength

          assert_error_raised(msg) do
            assert_validates_format(@m, :title, with: regex, within: 10..20)
          end
        end
      end
      # /when validating an incorrect provided option

      it 'when the attribute is not being validated' do
        # rubocop:disable Layout/LineLength
        msg = /Expected .* to validate :format for :author_id column, but no validations are defined for :author_id/
        # rubocop:enable Layout/LineLength

        assert_error_raised(msg) { assert_validates_format(@m, :author_id) }
      end

      it 'when the attribute is not present' do
        msg = /Column :does_not_exist is not defined in .*/

        assert_error_raised(msg) do
          assert_validates_format(@m, :does_not_exist)
        end
      end
    end
    # /should raise an error
  end
  # /#assert_validates_format(:model, :attribute, :opts, :msg)
end
