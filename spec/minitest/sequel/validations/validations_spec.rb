# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Assertions do
  describe '#assert_raises_validation_failed(:model)' do
    before do
      @c = Class.new(User) do
        plugin :validation_class_methods
        validates_uniqueness_of(:email, message: 'dummy')
      end
    end

    let(:email) { 'joe@email.com' }

    describe 'raises an error' do
      it 'when saving a record does not raise Sequel::ValidationFailed' do
        m = @c.new(name: 'Joe', email: email)

        msg = 'Sequel::ValidationFailed expected but nothing was raised.'

        assert_error_raised(msg) { assert_raises_validation_failed(m) }
      end

      it 'when saving a record does raise a Sequel::ValidationFailed' do
        m = @c.new(name: 'Jane', email: email) # intentionally duplicate email

        msg = 'Sequel::ValidationFailed expected but nothing was raised.'

        assert_error_raised(msg) { assert_raises_validation_failed(m) }
      end
    end
    # /raises an error
  end
  # /#assert_raises_validation_failed(:model)

  describe '#assert_fails_validation(:model)' do
    before do
      @c = Class.new(User) do
        plugin :validation_class_methods
        validates_uniqueness_of(:email, message: 'dummy')
      end
    end

    let(:email) { 'joe@email.com' }

    describe 'raises an error' do
      it 'when saving a record does not raise Sequel::ValidationFailed' do
        m = @c.new(name: 'Joe', email: email)

        msg = 'Sequel::ValidationFailed expected but nothing was raised.'

        assert_error_raised(msg) { assert_fails_validation(m) }
      end

      it 'when saving a record does raise a Sequel::ValidationFailed' do
        m = @c.new(name: 'Jane', email: email) # intentionally duplicate email

        msg = 'Sequel::ValidationFailed expected but nothing was raised.'

        assert_error_raised(msg) { assert_fails_validation(m) }
      end
    end
    # /raises an error
  end
  # /#assert_fails_validation(:model)

  describe '#_available_validation_types' do
    it 'returns an array of available validation type symbols' do
      res = %i[format length presence numericality confirmation acceptance inclusion uniqueness]
      assert_equal res, _available_validation_types
    end

    # it 'returns all validation types supported by Sequel' do
    #   sequel_types = Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.keys
    #   assert_equal sequel_types.sort, _available_validation_types.sort
    # end

    it 'does not include any duplicate validation types' do
      types = _available_validation_types
      assert_equal types.uniq, types
    end

    it 'returns an array of symbols' do
      # assert(_available_validation_types.all? { |type| type.is_a?(Symbol) })
      assert(_available_validation_types.all?(Symbol))
    end
  end
  # /#_available_validation_types

  describe '#_valid_validation_options(:type)' do
    describe 'default' do
      it 'returns an array with [:message] option only' do
        assert_equal [:message], _valid_validation_options
      end
    end

    describe ':acceptance' do
      it 'returns an array with [:message :accept] options' do
        assert_equal %i[message accept], _valid_validation_options(:acceptance)
      end
    end

    describe ':each' do
      it 'returns an array with [:message :allow_blank :allow_missing :allow_nil] options' do
        res = %i[message allow_blank allow_missing allow_nil]
        assert_equal res, _valid_validation_options(:each)
      end
    end

    describe ':format' do
      it 'returns an array with [:message :with] options' do
        assert_equal %i[message with], _valid_validation_options(:format)
      end
    end

    describe ':inclusion' do
      it 'returns an array with [:message :in] options' do
        assert_equal %i[message in], _valid_validation_options(:inclusion)
      end
    end

    describe ':numericality' do
      it 'returns an array with [:message :only_integer] options' do
        assert_equal %i[message only_integer], _valid_validation_options(:numericality)
      end
    end

    describe ':length' do
      it 'returns an array with [:message :is :maximum...] options' do
        res = %i[message is maximum minimum nil_message too_long too_short within wrong_length]

        assert_equal res, _valid_validation_options(:length)
      end
    end
  end
  # /#_valid_validation_options(:type)
end
