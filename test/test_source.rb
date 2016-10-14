require 'minitest/autorun'
require_relative '../lib/source'

class TestSource < MiniTest::Test
  def test_source_inherits_from_transform
    assert Source < Transform, true
  end
end
