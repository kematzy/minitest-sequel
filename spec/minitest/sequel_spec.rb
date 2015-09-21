require 'spec_helper'

module Minitest::Assertions
  
  # 
  def assert_returns_error(expected_msg, klass=Minitest::Assertion, &blk)
    e = assert_raises(klass) do
      yield
    end
    assert_equal expected_msg, e.message
  end
  
  # 
  def assert_no_error(&blk)
    e = assert_silent do
      yield
    end
  end
  
end
    refute_nil ::Minitest::Sequel::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
