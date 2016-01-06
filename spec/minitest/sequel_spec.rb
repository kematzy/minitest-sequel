require_relative '../spec_helper'

describe Minitest::Sequel do
  
  it 'has a version number' do
    Minitest::Sequel::VERSION.wont_be_nil
    Minitest::Sequel::VERSION.must_match %r{^\d+\.\d+\.\d+$}
  end
  
end
