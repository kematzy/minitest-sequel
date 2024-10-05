# frozen_string_literal: true

require_relative '../../spec_helper'

describe Minitest::Sequel do
  it 'has a version number' do
    _(Minitest::Sequel::VERSION).wont_be_nil
    _(Minitest::Sequel::VERSION).must_match(/^\d+\.\d+\.\d+$/)
  end
end
